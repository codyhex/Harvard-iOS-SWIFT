//
//  ViewController.swift
//  MyRestaurantBill
//
//  Created by HePeng on 7/1/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var myBill = RestaurantBill()
    var item1num: Int = 0
    var item1price: Double = 0.0

    @IBOutlet weak var item1PriceInput: UITextField! {
        didSet {
            self.item1PriceInput.delegate = self
        }
    }

    @IBAction func item1PriceInputEntered(sender: AnyObject) {
        println("enterne \(item1PriceInput.text)")
    }
    
    @IBOutlet weak var item1Quantity: UILabel!
    
    @IBAction func item1QuantityIncreaseButton(sender: AnyObject) {
        ++item1num
        item1Quantity.text = "\(item1num)"
        
    }
    
    @IBAction func item1QuantityDecreaseButton(sender: AnyObject) {
        --item1num
        item1Quantity.text = "\(item1num)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    


}

