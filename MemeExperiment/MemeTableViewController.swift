//
//  MemeTableViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 5/08/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the borders between cell
        tableView.separatorColor = UIColor.clearColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")! as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the text and image
        cell.memeText.editable = false
        cell.memeText.text = meme.upperTextString! + "..." + meme.lowerTextString!
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        // Grab the DetailVC from Storyboard
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        
        //send the meme object into detailVC
        let meme = self.memes[indexPath.row]
        detailVC.meme = meme
        detailVC.index = indexPath.row
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //instance of AppDelegate
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
            //when you want to delete a meme
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            // delete row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

                
        }
    }


}
