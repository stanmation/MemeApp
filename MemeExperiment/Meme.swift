//
//  Meme.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 29/07/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

struct Meme {

    var upperTextString:String?
    var lowerTextString:String?
    var image:UIImage?
    var memedImage:UIImage?

    init (upperTextString:String, lowerTextString:String, image:UIImage, memedImage:UIImage){
        self.upperTextString = upperTextString
        self.lowerTextString = lowerTextString
        self.image = image
        self.memedImage = memedImage
    }
    

}