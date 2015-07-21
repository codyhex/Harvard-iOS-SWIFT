//
//  Persistance.swift
//  Lecture3Demos
//
//  Created by Peng on 7/20/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import Foundation

class SuperSimpleSave: NSObject, NSCoding {
    var superSimpleSaveString: String
    
    override init() {
        superSimpleSaveString = "Supper String, Saved Simply"
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


class Persistence {
    static let ModelFileName = "AppleModel.serialized"
    static let FileMgr = NSFileManager.defaultManager()
    
    static var path: String? {
        if let dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.AdminApplicationDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String] where dirPaths.count > 0 {
            if !FileMgr.fileExistsAtPath(dirPaths[0]) && !mkdir(dirPaths[0]) {
                return nil
            }
        }
        
        return dirPaths[0].stringByAppendingPathComponent(ModelFileName)
    }
    
    static func mkdir(newDirPath: String) -> Bool {
        var createDirErr: NSError?
        let createDirRes = FileMgr.createDirectoryAtPath()
    }
    
    static func save(model:NSObject) -> Bool {
        var success = false
        if let savePath = Persistence.path {
            success = NSKeyedArchiver.archivedDataWithRootObject(model, toFile:savePath)
        }
        return success
    }
    
    static func restore() -> NSObject? {
        if let savePath = Persistence.path {
            if let rawData = NSData(contentsOfFile: savePath) {
                let unarchiver = NSKeyUnarchiver(forReadingWithData:rawData)
            }
        }
    }
}