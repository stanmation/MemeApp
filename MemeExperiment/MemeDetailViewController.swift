//
//  MemeDetailViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 6/08/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    var index:Int!
    
    
    var meme:Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView.image = meme.memedImage
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailToEditorVC" {
            let controller = segue.destinationViewController as! MemeEditorViewController
            controller.meme = meme
        }
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        //instance of AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //when you want to delete a meme
        appDelegate.memes.removeAtIndex(index)
        
        // back to Sent Memes
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
}
