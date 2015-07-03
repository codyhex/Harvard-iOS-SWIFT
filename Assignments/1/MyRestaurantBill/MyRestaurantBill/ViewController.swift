//
//  ViewController.swift
//  MyRestaurantBill
//
//  Created by HePeng on 7/1/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UITextFieldDelegate {
    
    var myBill = RestaurantBill()
    var serviceLevel: ServiceLevel = ServiceLevel.good

    var item1Num: Int = 0
    var item1Price: Double = 0
    
    var item2Num: Int = 0
    var item2Price: Double = 0
    
    var item3Num: Int = 0
    var item3Price: Double = 0


    @IBOutlet weak var item1Quantity: UILabel!

    @IBOutlet weak var item1PriceInput: UITextField! {
        didSet {
            item1PriceInput.delegate = self
        }
    }

    @IBAction func item1PriceInputEntered(sender: AnyObject) {
        item1Price = Double(item1PriceInput.text.toInt()!)
        
    }
    
    
    @IBAction func item1QuantityIncreaseButton(sender: AnyObject) {
        ++item1Num
        item1Quantity.text = "\(item1Num)"
        
        myBill.addLineItem("Pizza", quantity: item1Num, price: item1Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
        
    }
    
    @IBAction func item1QuantityDecreaseButton(sender: AnyObject) {
        --item1Num
        item1Quantity.text = "\(item1Num)"
        
        myBill.addLineItem("Pizza", quantity: item1Num, price: item1Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
    }
    
    
    // Item 2
    
    @IBOutlet weak var item2Quantity: UILabel!
    
    @IBOutlet weak var item2PriceInput: UITextField! {
        didSet {
            item2PriceInput.delegate = self
        }
    }
    
    @IBAction func item2PriceInputEntered(sender: AnyObject) {
        item2Price = Double(item2PriceInput.text.toInt()!)
        
    }
    
    
    @IBAction func item2QuantityIncreaseButton(sender: AnyObject) {
        ++item2Num
        item2Quantity.text = "\(item2Num)"
        
        myBill.addLineItem("Burger", quantity: item2Num, price: item2Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
        
    }
    
    @IBAction func item2QuantityDecreaseButton(sender: AnyObject) {
        --item2Num
        item2Quantity.text = "\(item2Num)"
        
        myBill.addLineItem("Burger", quantity: item2Num, price: item2Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
    }

    // item 3
    
    @IBOutlet weak var item3Quantity: UILabel!
    
    @IBOutlet weak var item3PriceInput: UITextField! {
        didSet {
            item3PriceInput.delegate = self
        }
    }
    
    @IBAction func item3PriceInputEntered(sender: AnyObject) {
        item3Price = Double(item3PriceInput.text.toInt()!)
        
    }
    
    
    @IBAction func item3QuantityIncreaseButton(sender: AnyObject) {
        ++item3Num
        item3Quantity.text = "\(item3Num)"
        
        myBill.addLineItem("Water", quantity: item3Num, price: item3Price)
        
        // fake service
        myBill.setServiceLevel(serviceLevel)
        
        setLabels()
        
    }
    
    @IBAction func item3QuantityDecreaseButton(sender: AnyObject) {
        --item3Num
        item3Quantity.text = "\(item3Num)"
        
        myBill.addLineItem("Water", quantity: item3Num, price: item3Price)
        
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

