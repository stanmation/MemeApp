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
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the borders between cell
        tableView.separatorColor = UIColor.clear

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")! as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the text and image
        cell.memeText.isEditable = false
        cell.memeText.text = meme.upperTextString! + "..." + meme.lowerTextString!
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailViewController
        
        //send the meme object into detailVC
        let meme = self.memes[indexPath.row]
        detailVC.meme = meme
        detailVC.index = indexPath.row
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            
            //instance of AppDelegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
            //when you want to delete a meme
            appDelegate.memes.remove(at: indexPath.row)
            
            // delete row
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
