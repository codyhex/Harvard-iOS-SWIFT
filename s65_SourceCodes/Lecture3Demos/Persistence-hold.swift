//
//  Persistence.swift
//  Lecture3Demos
//
//  Created by Daniel Bromberg on 7/19/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import Foundation

class SuperSimpleSaveHold: NSObject, NSCoding {
    var superSimpleSaveString: String
    
    override init() {
        superSimpleSaveString = "Super String, Saved Simply"
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        superSimpleSaveString = aDecoder.decodeObjectForKey("superSimpleSaveString") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(superSimpleSaveString, forKey: "superSimpleSaveString")
    }
}

class PersistenceHold {
    static let ModelFileName = "AppModel.serialized"
    static let FileMgr = NSFileManager.defaultManager()
    
    static func mkdir(newDirPath: String) -> Bool {
        var createDirErr: NSError?
        let createDirRes = FileMgr.createDirectoryAtPath(newDirPath, withIntermediateDirectories: false,
            attributes: nil, error: &createDirErr)
        if let err = createDirErr where !createDirRes {
            println("Could not create directory: \(err.localizedDescription)")
            return false
        }
        return true
    }
    
    // Calculate the application's sandbox Application Support directory, which is a good place to
    // save internal data. It gets backed up but the user is never expected to browse there.
    // The "Application Support" directory does not exist by default, so we must create it if it's not
    // there.
    static var path: String? {
        if let dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as? [String] where dirPaths.count > 0 {
                if !FileMgr.fileExistsAtPath(dirPaths[0]) && !mkdir(dirPaths[0]) {
                    return nil
                }
                return dirPaths[0].stringByAppendingPathComponent(ModelFileName)
        }
        
        return nil
    }
    
    static func save(model: NSObject) -> Bool {
        var success = false
        if let savePath = Persistence.path {
            success = NSKeyedArchiver.archiveRootObject(model, toFile: savePath)
            println("saved model: \(success) at \(NSDate()) to path: \(savePath)")
        }
        return success
    }
    
    static func restore() -> NSObject? {
        if let savePath = Persistence.path, rawData = NSData(contentsOfFile: savePath) {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: rawData)
            if let model = unarchiver.decodeObjectForKey("root") as? NSObject {
                println("restored model successfully at \(NSDate())")
                return model
            }
            else {
                println("could not decode object as CellGridModel")
            }
        }
        else {
            println("could not make data file from \(path)")
        }
        return nil
    }
}
