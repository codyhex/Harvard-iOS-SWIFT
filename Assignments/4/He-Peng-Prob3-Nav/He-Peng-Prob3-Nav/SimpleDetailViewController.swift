//
//  SimpleDetailViewController.swift
//  Lecture7Demo
//
//  Created by Daniel Bromberg on 7/13/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

class SimpleDetailViewController: UIViewController, UITextFieldDelegate {
    // prepareForSegue, where this field is set up, is very early in the
    // destination view controller's lifecycle, before the outlets below are set up
    var imageName: String? {
        didSet {
            if let imgName = imageName {
                image = UIImage(named: imgName)
            }
        }
    }
    
    
    var image : UIImage?
    
    var myBill : RestaurantBill
    
    var myBills: RestaurantBill? {
        didSet {
                myBill = myBills!
        }
    }
    
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
        // if user click on the text field and leave with a blank, the text field will be nil
        if let priceTemp = item1PriceInput.text.toInt() {
            item1Price = Double(priceTemp)
        } else {
            item1Price = 0
        }
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
        // do not allow order under zero
        if item1Num > 0 { --item1Num } else {return}
        
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
        // if user click on the text field and leave with a blank, the text field will be nil
        if let priceTemp = item2PriceInput.text.toInt() {
            item2Price = Double(priceTemp)
        } else {
            item2Price = 0
        }
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
        
        if item2Num > 0 { --item2Num } else {return}
        
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
        // if user click on the text field and leave with a blank, the text field will be nil
        if let priceTemp = item3PriceInput.text.toInt() {
            item3Price = Double(priceTemp)
        } else {
            item3Price = 0
        }
        
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
        
        if item3Num > 0{ --item3Num } else {return}
        
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

    
}
