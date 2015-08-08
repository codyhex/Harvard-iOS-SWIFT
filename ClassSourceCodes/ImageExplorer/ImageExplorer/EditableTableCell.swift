//
//  EditableTableCell.swift
//
//  Created by Daniel Bromberg on 5/12/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.

import UIKit

protocol MutableStringArray {
    func stringShouldChange(atRow row: Int, toValue value: String) -> Bool
    
    subscript(row: Int) -> String? {
        get set
    }
}

class EditableTableCell: UITableViewCell, UITextFieldDelegate {
    var changeDelegate: MutableStringArray?
    var row: Int?
    var observer: NSObjectProtocol?
  
    @IBOutlet weak var validLabel: UILabel!

    @IBOutlet weak var editor: UITextField! {
        didSet {
            editor.delegate = self
            let center = NSNotificationCenter.defaultCenter()
            let mainQ = NSOperationQueue.mainQueue()
            observer = center.addObserverForName(UITextFieldTextDidChangeNotification, object: editor, queue: mainQ) {
                [unowned self] notification in
                self.valueDidChange()
            }
        }
    }

    func valueDidChange() {
        // failure of assert means the table manager failed to initalize this reusable cell -- see MasterViewController
        assert(changeDelegate != nil && editor != nil && editor.text != nil && row != nil)
        validLabel.text = changeDelegate!.stringShouldChange(atRow: row!, toValue: editor.text!) ? "✅" : "❌"
    }

    func textFieldDidEndEditing(textField: UITextField) {
        // In case edited value ended up invalid when focus left, revert to actual model value
        editor.text = changeDelegate![row!]
        validLabel.text = "✅"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Util.log("cell awoke from NIB")
        // Initialization code
    }
    
    deinit {
        Util.log("cell deinitialized, removing observer")
        let center = NSNotificationCenter.defaultCenter()
        if let obs = observer {
            center.removeObserver(obs)
        }
    }
}
