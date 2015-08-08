//
//  ViewController.swift
//  FormEditor
//
//  Created by Daniel Bromberg on 5/8/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

let noErr = "[No error]"


class ViewController: UIViewController, UITextFieldDelegate {
    let backEnd = JSONBackEnd()
    let tableName = "users"
    var textFields = [String: UITextField]()
    
    @IBAction func addRecord() {
        Util.log("Request received for adding a new record")
        backEnd.insertInTable(tableName) {
            [unowned self] (id, msg) in
            dispatch_async(dispatch_get_main_queue()) {
                if let newId = id {
                    Util.log("Response arrived for adding record ID \(newId)")
                    self.textFields["id_pk"]?.text = "\(newId)"
                }
                else {
                    self.notifyUser(title: "Server error", message: msg!)
                }
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Util.log("User finished editing text: '\(textField.text)', will attempt save")
        if let recordId = self.textFields["id_pk"]?.text?.toInt(), fieldName = textField.placeholder, fieldValue = textField.text {
            Util.log("About to make request to save: table \(tableName) id \(recordId) fieldName \(fieldName) value \(fieldValue)")
            backEnd.saveToTable(tableName, recordId: recordId, dataField: fieldName, dataValue: fieldValue) {
                [unowned self] (numRows, message) in
                dispatch_async(dispatch_get_main_queue()) {
                    Util.log("Result arrived #rows \(numRows ?? 0) message \(message ?? noErr)")
                    if let errmsg = message {
                        self.notifyUser(title: "Failure saving", message: errmsg)
                    }
                    else if numRows != 1 {
                        self.notifyUser(title: "Server error", message: "\(numRows) rows updated instead of 1")
                    }
                    else {
                        Util.log("save of edit successful")
                    }
                }
            }
        }
        else {
            Util.log("Cancelling save, invalid id or text")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.log("enter")
        backEnd.describeTable(tableName) {
            [unowned self] (fieldNames: [String]?, message: String?) in
            Util.log("Table description arrived on background queue for \(self.tableName), forwarding to UI main queue")
            dispatch_async(dispatch_get_main_queue()) {
                Util.log("Table description arrived on main queue for \(self.tableName)")
                if let names = fieldNames {
                    let height: CGFloat = 30.0
                    var yOffset: CGFloat = height
                    let fields: [UITextField] = names.map {
                        let f = UITextField(frame: CGRect(x: 8.0, y: yOffset, width: self.view.bounds.width - 16.0, height: height))
                        f.backgroundColor = UIColor.yellowColor()
                        f.borderStyle = .Line
                        f.placeholder = $0
                        f.delegate = self
                        self.textFields[$0] = f
                        self.view.addSubview(f)
                        yOffset += height + 8
                        return f
                    }
                }
                else {
                    self.notifyUser(title: "Form building failed ⚠️", message: message!)
                }
                Util.log("finished executing \(self.tableName) description closure within UI main queue")
            }
            Util.log("finished dispatching \(self.tableName) description to UI main queue from background closure")
        }
        Util.log("leave viewDidLoad in startup")
    }
    
    func notifyUser(#title: String, message: String) {
        let alertBox = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        // Study & absorb the difference between a ViewController, which is "active" and must be presented as a
        // layer, VERSUS a UIView, which is just a hierchical building block of a single VC
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
}

