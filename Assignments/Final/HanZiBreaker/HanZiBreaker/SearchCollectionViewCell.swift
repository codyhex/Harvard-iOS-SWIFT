//
//  SearchCollectionViewCell.swift
//  HanZiBreaker
//
//  Created by Peng on 8/3/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    var cellIsTapped = false
    
    var radicalCharacter: String? {
        didSet {
            radicalField.text = ("Item: " + radicalCharacter!)
        }
    }
    
    @IBOutlet weak var radicalImage: UIImageView!
    
    
    @IBOutlet weak var radicalField: UILabel!
    
}
