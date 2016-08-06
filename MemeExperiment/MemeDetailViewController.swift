//
//  MemeDetailViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 6/08/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var MemeImageView: UIImageView!
    
    var meme:Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MemeImageView.image = meme.memedImage
    }
    
}
