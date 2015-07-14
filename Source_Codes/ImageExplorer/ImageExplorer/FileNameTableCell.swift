//
//  FileNameTableCell.swift
//
//  Created by Daniel Bromberg on 5/12/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.

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
            assertionFailure("row or dataSink not set")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
