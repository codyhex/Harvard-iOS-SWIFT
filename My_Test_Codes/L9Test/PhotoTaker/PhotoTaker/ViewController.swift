//
//  ViewController.swift
//  PhotoTaker
//
//  Created by Peng on 7/20/15.
//  Copyright (c) 2015 Peng. All rights reserved.
//

import UIKit

import MobileCoreServices

struct Identifiers {
    static let ImagePickerSegue = "Image Picker"
}

class ViewController: UIViewController , UIImagePickerControllerDelegate{

    let sourceType: UIImagePickerControllerSourceType = .Camera
    let mediaTypes = [kUTTypeImage]
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    
    func alert(message:String) {
        UIAlertView(title: "Photo error", message: message, delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dev = UIDevice.currentDevice()
        
        if dev.model == "iPhone Simulator" {
            takePhotoButton.enabled = false
            takePhotoButton.setTitle("No camera", forState: .Disabled)
            takePhotoButton.sizeToFit()
            
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier != Identifiers.ImagePickerSegue {
            alert ("Unkown segue \(identifier)")
            return false
            
        }
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            alert("source type \(sourceType.rawValue) not ava")
            return false
        }
        let types = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as? [String]
        if types == nil {
            alert("Could not retrieve media type for \(sourceType.rawValue) ")
        }
        
        for wantedType in  mediaTypes {
            if !contains(types!, wantedType as String) {
                alert("Media type \(wantedType) not ava for source type \(sourceType)")
                return false
            }
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != Identifiers.ImagePickerSegue {
            assertionFailure("Unkown Segue")
        }
        else if let picker = segue.destinationViewController as? UIImagePickerController {
            picker.delegate = self /* @HP: needs adopt protocols, which one? */
            picker.sourceType = sourceType
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = false
        }
        else {
            assertionFailure("Unkown destination")
        }
    }
    
    func verifySaved(image:UIImage, didFinishSavingWithError: NSError, contextInfo: UnsafeMutableBufferPointer<Void>){
        alert("")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageButton.setImage(image, forState: .Normal)
            UIImageWriteToSavedPhotosAlbum(image, self, "verifySaved:didFinishSavingWithError:contextInfo:", nil)
        }
        else {
            alert("No image was picked somehow")
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

