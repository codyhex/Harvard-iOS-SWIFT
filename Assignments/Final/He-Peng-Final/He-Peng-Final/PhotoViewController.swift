//
//  PhotoViewController.swift
//  PhotoTaker
//
//  Created by Daniel Bromberg on 7/20/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit
import MobileCoreServices

struct Identifiers {
    static let ImagePickerSegue = "Show Image Picker"
}

// UPDATE: The bug was that the TYPE of the Button was 'System', which only accomodates text. It has been changed in StoryBoard to 'Custom'
// in the attributes inspector.
class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let sourceType: UIImagePickerControllerSourceType = .Camera
    let mediaTypes = [kUTTypeImage]
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    func alert(message: String) {
        UIAlertView(title: "Photo message", message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    
    // UPDATE: Added just to show how to get a button's image and its size
    @IBAction func photoButtonTapped(sender: UIButton) {
        alert("Image dimensions: \(sender.currentImage?.size)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dev = UIDevice.currentDevice()
        print("Device: \(dev.model) \(dev.description)")
        if dev.model == "iPhone Simulator" {
            takePhotoButton.enabled = false
            takePhotoButton.setTitle("No camera on simulator", forState: .Disabled)
            takePhotoButton.sizeToFit()
        }
    }

    // gets called before prepareForSegue, and if false, the prepare/transition is
    // canceled
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier != Identifiers.ImagePickerSegue {
            alert("Unknown segue \(identifier)")
            return false
        }
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            alert("source type \(sourceType.rawValue) not available")
            return false
        }
        let types = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as? [String]
        if types == nil {
            alert("Could not retrieve media types for \(sourceType.rawValue)")
        }
        // make sure that all the media types we want are in fact available
        for wantedType in mediaTypes {
            if !contains(types!, wantedType as String) {
                alert("Media type \(wantedType) not available for source type \(sourceType)")
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != Identifiers.ImagePickerSegue {
            assertionFailure("Unknown segue: \(segue.identifier)")
            println("1")
        }
        else if let picker = segue.destinationViewController as? UIImagePickerController {
            println("2")
            picker.delegate = self
            picker.sourceType = sourceType
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = false
            

        }
        else {
            println("3")
            assertionFailure("Unknown destination controller type: \(segue.destinationViewController)")
            

        }
    }
    
    func verifySaved(image: UIImage, didFinishSavingWithError: NSError, contextInfo: UnsafeMutablePointer<Void>) {
        alert("Image saved to library at \(NSDate())")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // we have our image!
            imageButton.setImage(image, forState: .Normal)
            UIImageWriteToSavedPhotosAlbum(image, self, "verifySaved:didFinishSavingWithError:contextInfo:", nil)
        }
        else {
            alert("No image was picked somehow!")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // UPDATE: This was left out in lecture, but is critical!
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("Image picker canceled!")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

