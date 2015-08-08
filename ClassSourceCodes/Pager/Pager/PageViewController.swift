//
//  ViewController.swift
//  Pager
//
//  Created by Van Simmons on 7/31/15.
//  Copyright (c) 2015 Harvard Extension School. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var page1ViewController:Page1ViewController!
    var page2ViewController:Page2ViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        page1ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Page1ViewController")
            as! Page1ViewController
        page2ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Page2ViewController")
            as! Page2ViewController
        
        self.setViewControllers([self.page1ViewController],
            direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var retVal:UIViewController? = nil
        if viewController == page1ViewController {
            retVal = page2ViewController
        }
        return retVal
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var retVal:UIViewController? = nil
        if viewController == page2ViewController {
            retVal = page1ViewController
        }
        return retVal
    }
    
    
}

