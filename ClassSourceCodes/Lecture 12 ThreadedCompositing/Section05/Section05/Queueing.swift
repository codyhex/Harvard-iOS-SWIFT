//
//  ThreadSafeQueue.swift
//  Section05
//
//  Created by Van Simmons on 7/29/15.
//  Copyright (c) 2015 ComputeCycles, LLC. All rights reserved.
//

import Foundation

public func synchronized(object: AnyObject, closure: () -> Void) {
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

public typealias Operation = () -> Void

public class QueueOperation {
    var operation : Operation
    required public init(op:Operation) {
        operation = op
    }
    
    public func execute () {
        operation()
    }
}

public class ThreadSafeQueue {
    private var _queue = [] as [QueueOperation]
    
    public func enqueueObject(obj:QueueOperation) {
        synchronized (_queue) {
            self._queue.append(obj)
        }
    }
    
    public func dequeueObject() -> QueueOperation?
    {
        var retVal:QueueOperation?
        if (_queue.count > 0)
        {
            synchronized(_queue) {
                retVal = self._queue[0]
                self._queue.removeAtIndex(0)
            }
        }
        return retVal;
    }

    var count:Int {
        get {
            var retVal = 0
            synchronized(_queue)  {
                retVal = self._queue.count;
            }
            return retVal;
        }
    }
}

