//
//  CustomMemeCell.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 5/08/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

class CustomMemeCell: UICollectionViewCell {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var botTextField: UITextField!
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeWidthAttributeName : -3.3,
    ]
    
    func setText(upperString:String, bottomString: String) {
        
        // assign the strings into textField
        topTextField.text = upperString
        botTextField.text = bottomString
        
        // configuring textField
        configureTextField(topTextField)
        configureTextField(botTextField)
        
    }
    
    func configureTextField(textField:UITextField){
        textField.enabled = false
        textField.backgroundColor = UIColor.clearColor()
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
}
