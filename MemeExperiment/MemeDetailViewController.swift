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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView.image = meme.memedImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToEditorVC" {
            let controller = segue.destination as! MemeEditorViewController
            controller.meme = meme
        }
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        //instance of AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //when you want to delete a meme
        appDelegate.memes.remove(at:index)
        
        // back to Sent Memes
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
