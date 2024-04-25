//
//  MemeCollectionViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 5/08/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup flow layout
        let space: CGFloat = 5.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
 
        flowlayout.minimumInteritemSpacing = space
        flowlayout.minimumLineSpacing = space
        flowlayout.itemSize = CGSizeMake(dimension, dimension)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload collection view everytime it appears
        self.collectionView?.reloadData()
        
        // unhide the tabBar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        
        cell.backgroundView = UIImageView(image: meme.memedImage)
        cell.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit

        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailViewController
        
        //s end the meme object into detailVC
        let meme = self.memes[indexPath.item]
        detailVC.meme = meme
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
