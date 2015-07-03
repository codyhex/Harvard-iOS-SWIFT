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
    var item1Num: Int = 0
    var item1Price: Double = 0.0
    
    var serviceLevel: ServiceLevel = ServiceLevel.good


    @IBOutlet weak var item1Quantity: UILabel!

    @IBOutlet weak var item1PriceInput: UITextField! {
        didSet {
            self.item1PriceInput.delegate = self
        }
    }

    @IBAction func item1PriceInputEntered(sender: AnyObject) {
        item1Price = Double(item1PriceInput.text.toInt()!)
        
//        println("enterne \(item1Price)")
    }
    
    
    @IBAction func item1QuantityIncreaseButton(sender: AnyObject) {
        ++item1Num
        item1Quantity.text = "\(item1Num)"
        
        myBill.addLineItem("Pizza", quantity: item1Num, price: item1Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
        
//        println("\(myBill.billItems)")
        
    }
    
    @IBAction func item1QuantityDecreaseButton(sender: AnyObject) {
        --item1Num
        item1Quantity.text = "\(item1Num)"
        
        myBill.addLineItem("Pizza", quantity: item1Num, price: item1Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
    }
    
    
    
    
    // For the total calculation
    
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    @IBOutlet weak var taxTextLabel: UILabel!
    
    @IBOutlet weak var baseTotalTextLabel: UILabel!
    
    @IBOutlet weak var finalTotalTextLabel: UILabel!
    

    
    func setLabels () {
        tipTextLabel.text = "\(round(Double(myBill.baseTotal) * serviceLevel.rawValue))"
    
        taxTextLabel.text = "\(round(Double(myBill.baseTotal) * 0.07))"
    
        baseTotalTextLabel.text = "\(myBill.baseTotal)"
    
        finalTotalTextLabel.text = "\(myBill.finalTotal)"
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    


}

