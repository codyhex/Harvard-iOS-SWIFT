// Way to think about it:
// "Box up" nested series of closures; start innermost with the UI request, and wrap boxes around it
// outermost is the lowest level (networking)
// Run the slow network request, and then unbox on the network thread.
// As each result becomes available, unbox the next closure and pass in the result for that stage
// of processing
// Finally at the end, pass the final result back to the UI thread

import Foundation

class JSONBackEnd: HTTPBackEnd {
    /* A JSON wrapper around the HTTP request. Performs JSON parsing immediately after network data arrives.
    Then calls the passed in block 'jsonDataDidArrive' on the main queue. This block should present the JSON data in the UI */
    func ajaxRequest(url: NSURL, jsonDataDidArrive: (dataDict: [NSDictionary]?, message: String?) -> ()) {
        Util.log("Request received for \(url)")
        
        // named closure
        func translateRawDataToJSON(rawData: NSData?, netErr: String?) -> (jsonDict: [NSDictionary]?, errMsg: String?) {
            Util.log("translating rawData to JSON, network error was: \(netErr ?? noErr)")
            if let rawJSON = rawData {
                var jsonError: NSError?
                // Actually doing de-serialization right now
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(rawJSON, options: .AllowFragments, error: &jsonError)
                
                // Assupmption based on structure of my API. THe JSON can be arbitrarily recursive, you just
                // need to know what to expect at the top level
                if let validParsedData = json as? [NSDictionary] { // Success clause at top, optimistic testing
                    Util.log("finished translating JSON successfully, returning it")
                    return (jsonDict: validParsedData, errMsg: nil)
                }
                else { // unable to parse JSON as dictionary
                    let errmsg: String
                    // if you were able to parse, but it was not an array of dictionaries, then this
                    if let ajaxMessage = json as? String {
                        errmsg = "AJAX API Error: \(ajaxMessage)"
                    }
                    // might happen if missing closing brace
                    else if let jErr = jsonError {
                        errmsg = "JSON Parsing Error: \(jErr.localizedDescription)"
                    }
                    // might happen if server responds with 500 / config error
                    else {
                        errmsg = "Server implementation error: Neither error string nor expected dictionary"
                    }
                    return (jsonDict: nil, errMsg: errmsg)
                }
            }
            // no Raw data available; HTTP or network level error
            return (jsonDict: nil, errMsg: netErr) // Pass through the error message returned by httpRequest
        } // end of my named closure translateRawDataToJSON
        
        // Make the http request. When it's done the block below will get called. Subsequently, when the translation is done,
        // the jsonDataArrive block, will be called.
        httpRequest(url) {
            [unowned self] (rawData, message) in
            Util.log("Response received for \(url), parsing now")
            let (parsedJSON, errMsg) = translateRawDataToJSON(rawData, message)
            jsonDataDidArrive(dataDict: parsedJSON, message: errMsg)
        }
    }
    
    
    /* Convenience wrapper around the above that expects and extracts a single integer.
    It expects the JSON data to be a 1-element array.
    That element should be a dictionary with one object: a named integer. */
    func ajaxRequest(url: NSURL, forSingleIntegerNamed intName: String, intDidArrive: (intValue: Int?, errMsg: String?) -> ()) {
        Util.log("Request received for single integer named \(intName)")
        
        func jsonDataArrivedHandler(response: [NSDictionary]?, netErrMsg: String?) {
            var intValue: Int? = nil
            var errMsg: String? = nil
            Util.log("Response arrived for single integer named \(intName), error: \(netErrMsg ?? noErr)")
            if let rowInfo = response {
                // Note! The JSON library far predates Swift, and uses entirely NS* Foundation classes. "as? Int" is not the same
                if rowInfo.count == 1 {
                    if let val = rowInfo[0][intName] as? NSInteger {
                        intValue = val
                    }
                    else {
                        errMsg = "Response has invalid field '\(intName)': \(rowInfo[0][intName])"
                    }
                }
                else {
                    errMsg = "Unexpected result count: \(rowInfo.count)"
                }
            }
            else {
                errMsg = netErrMsg
            }
            intDidArrive(intValue: intValue, errMsg: errMsg)
        }
        
        ajaxRequest(url, jsonDataDidArrive: jsonDataArrivedHandler)
    }
    
    
    func describeTable(table: String, tableDescriptionReadyHandler: (fieldNames: [String]?, message: String?) -> ()) {
        Util.log("Request received to describe \(table)")
        
        func makeTableDescriptionURLQuery(#tableName: String) -> NSURL {
            return NSURL(string: "\(staticURL)" + encode(["request": "describe", "table": tableName]))!
        }
        
        ajaxRequest(makeTableDescriptionURLQuery(tableName: table)) {
            (data, message) in
            // This closure gets bound to jsonDataDidArrive
            Util.log("Response arrived to describe table \(table)")
            // We're back on the main queue. This is UI-centric code now, so that's OK. Very fast process to push
            // field names into table cells
            if let fieldSpecs = data {
                let fieldNames: [String] = fieldSpecs.map {
                    if let fName = $0["Field"] as? String {
                        return fName
                    }
                    else {
                        return "ERROR: Bad field descriptor"
                    }
                }
                tableDescriptionReadyHandler(fieldNames: fieldNames, message: nil)
            }
            else {
                tableDescriptionReadyHandler(fieldNames: nil, message: message)
            }
        }
    }
    
    
    func insertInTable(table: String, didInsertInTable: (recordId: Int?, message: String?) -> ()) {
        Util.log("Request received for \(table)")
        
        func makeInsertQuery(tableName: String) -> NSURL {
            return NSURL(string: "\(staticURL)" + encode([ "request": "insert", "table": tableName]))!
        }
        
        ajaxRequest(makeInsertQuery(table), forSingleIntegerNamed: "record_id", intDidArrive: didInsertInTable)
    }
    
    // UP TO THE STUDENT TO IMPLEMENT: Need a lookup mode or separate screen so that text entered is used to lookup, not save
    // Then callback must populate the values
    // http://data.classyswift.com/lib/ajax/data.php?request=retrieve&table=users&match_field=first_name&match_value=Daniel
    func lookup(table: String, matchField: String, matchValue: String,
        lookupResultsDidArrive: ([NSDictionary]?, errMsg: String?) -> ()) {
        Util.log("Request received to find \(matchField) = \(matchValue) in table \(table)")
        func urlForLookup(tableName: String, matchField: String, matchValue: String) -> NSURL {
            return NSURL(string: "\(staticURL)" + encode([
                "request": "update",
                "table": tableName,
                "match_field": matchField,
                "match_value": matchValue]))!
            }

            ajaxRequest(urlForLookup(table, matchField, matchValue), jsonDataDidArrive: lookupResultsDidArrive)
    }
    
    func saveToTable(table: String, recordId: Int, dataField: String, dataValue: String,
        handleRecordIDArrived: (numRows: Int?, message: String?) -> ()) {
            Util.log("table: \(table) recordId: \(recordId) dataField: \(dataField) dataValue: \(dataValue)")
            func urlForUpdate(tableName: String, dataField: String, dataValue: String) -> NSURL {
                return NSURL(string: "\(staticURL)" + encode([
                    "request": "update",
                    "table": tableName,
                    "match_field": "id_pk",
                    "match_value": "\(recordId)",
                    "data_field": dataField,
                    "data_value": dataValue]))!
            }
            
            ajaxRequest(urlForUpdate(table, dataField, dataValue), forSingleIntegerNamed: "num_rows", intDidArrive: handleRecordIDArrived)
    }
}
