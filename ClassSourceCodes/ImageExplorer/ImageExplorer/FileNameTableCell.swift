//
//  FileNameTableCell.swift
//
//  Created by Daniel Bromberg on 5/12/15.

import UIKit

protocol TableDataReceiverDelegate {
    func setElementAtIndex(index: Int, toValue: String) -> Void
}

class FileNameTableCell: UITableViewCell, UITextFieldDelegate {
    var row: Int?
    var dataSink: TableDataReceiverDelegate?
        
    @IBOutlet weak var editor: UITextField! {
        didSet {
            editor.delegate = self
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        Util.log("enter")
        if let r = row, sink = dataSink {
            sink.setElementAtIndex(r, toValue: textField.text)
        }
        else {
            assertionFailure("row \(row) or dataSink \(dataSink) not set")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
