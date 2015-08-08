//
//  ViewController.swift
//  SampleStorage
//
//  Created by Alex Blokker on 7/23/15.
//  Modified by Danel Bromberg 7/26/15.
//  Copyright (c) 2015 Harvard University. All rights reserved.
//

import UIKit

struct Defaults {
    static let StoredName = "Stored.plist"
    static let ImportedName = "ImportedData.plist"
}

class ViewController: UIViewController, UITextFieldDelegate {
	var storageFilePath: String!
	var importFilePath: String
	var dataDictionary: NSMutableDictionary
    var editor: UIView?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var loadButton: UIBarButtonItem!
	@IBOutlet weak var descriptionField: UITextField!
	@IBOutlet weak var firstnameField: UITextField!
	@IBOutlet weak var lastnameField: UITextField!
	@IBOutlet weak var ageField: UITextField!
	
    // Implemented for all text fields
    @IBAction func editingStarted(sender: UIView) {
        editor = sender
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        editor?.resignFirstResponder()
    }
    
	required init(coder aDecoder: NSCoder) {
        if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as? [String]
            where paths.count >= 1 {
                let documentsDirectory = paths.first!
                storageFilePath = documentsDirectory.stringByAppendingPathComponent(Defaults.StoredName)
                NSLog("storage: \(storageFilePath)")
        }
        else {
            saveButton.enabled = false
            loadButton.enabled = false
        }
        importFilePath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(Defaults.ImportedName)
        NSLog("defaults: \(importFilePath)")
        dataDictionary = NSMutableDictionary()
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        recursivelySetUpTextFields(view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if storageFilePath == nil {
            alert("Filesystem error", message: "Could not find storage path")
        }
    }
    
    // Find every text field in this view, set up event handlers to hide the keyboard:
    // -- When the return key is hit: use this VC as the delegate, thereby connecting to textFieldShouldReturn();
    // -- Track the editingDidBegin event so we know which first responder to resign when tap occurs in
    // neutral area of main view
    // This is an example of how to do something (a little odd) in code and sidestep StoryBoard completely
    func recursivelySetUpTextFields(v: UIView) {
        NSLog("Found subview: \(v)")
        for sv in v.subviews as! [UIView] {
            if let stv = sv as? UITextField {
                stv.addTarget(self, action: "editingStarted:", forControlEvents: .EditingDidBegin)
                stv.delegate = self
            }
            recursivelySetUpTextFields(sv)
        }
    }
    
	func updateTextFields() {
		// let description = dataDictionary?.objectForKey("Description") obj-c style styntax
		if let description = dataDictionary["Description"] as? String {
			descriptionField.text = description
		}

		if let title = dataDictionary["Title"] as? String {
			self.title = title
		}

		// We are only using the first element of the array for demo purposes
		if let users = dataDictionary["Users"] as? [AnyObject],
            userOne = users[0] as? [String: AnyObject],
            age = userOne["Age"] as? Int,
            fName = userOne["FirstName"] as? String,
            lName = userOne["LastName"] as? String {
            firstnameField.text = fName
            lastnameField.text = lName
            ageField.text = "\(age)"
		}
        else {
            alert("Invalid storage", message: "Could not parse user dictionary")
        }
	}

    @IBAction func loadFromImported() {
        loadFrom(importFilePath)
    }

    @IBAction func loadFromDisk() {
        loadFrom(storageFilePath)
	}
	
    func loadFrom(file: String) {
        if let loadedData = NSMutableDictionary(contentsOfFile: file) {
            dataDictionary = loadedData
            updateTextFields()
        }
        else {
            alert("Read failed", file: file)
        }
    }
    
	@IBAction func saveToDisk() {
		dataDictionary["Description"] = descriptionField?.text
        dataDictionary["Title"] = storageFilePath.lastPathComponent
        // HardCode assumption that there's only one user. Challenge: make a user interface with a Table that stores
        // an arbitrary number of dictionaries.
        let user1: [String: AnyObject] = ["FirstName" : firstnameField.text, "LastName" : lastnameField.text, "Age" : ageField.text.toInt() ?? 0]
		dataDictionary["Users"] = [ user1 ]

		let success = dataDictionary.writeToFile(storageFilePath, atomically: true)
		if !success {
            alert("Save Failed", file: storageFilePath)
		}
	}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alert(title: String, file: String? = nil, message: String? = nil) {
        let alertBox = UIAlertController(title: title, message: message ?? file!.lastPathComponent,
            preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertBox, animated: true, completion: nil)

        NSLog("\(title): \(message ?? file!))")
        // The below is deprecated for iOS 8.0
        // UIAlertView(title: title, message: alertMsg, delegate: nil, cancelButtonTitle: "OK").show()
    }
}

