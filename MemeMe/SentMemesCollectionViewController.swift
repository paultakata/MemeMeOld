//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let reuseIdentifier = "MemeCollectionViewCell"
    var memes: [Meme]!
    
    //MARK: - Overrides
    //MARK: View methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Set local memes storage and reload collection view data.
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    //MARK: Memory management

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
        
        //Configure cell background and image.
        cell.backgroundColor = UIColor.blackColor()
        cell.cellImageView.image = memes[indexPath.item].memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Get meme image, pass it and indexPath to the detail view controller.
        let image = memes[indexPath.item].memedImage
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        
        nextVC.receivedImage = image
        nextVC.receivedIndex = indexPath
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    //The following 3 methods all relate to providing a custom "Delete" menu
    //which pops up when a user long-presses a cell.
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        //Create a Delete Meme menu item and add it to the Shared menu Controller.
        let deleteMenuItem = UIMenuItem(title: "Delete Meme", action: "deleteItem:")
        UIMenuController.sharedMenuController().menuItems = [deleteMenuItem]
        
        return true
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        //Only allow the custom "deleteItem:" method to be available.
        return action == "deleteItem:"
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        if action == "deleteItem:" {
            
            //Remove item from shared storage, update the local copy
            //and delete it from the collection view.
            appDelegate.memes.removeAtIndex(indexPath.item)
            self.memes = appDelegate.memes
            collectionView.deleteItemsAtIndexPaths([indexPath])
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //This changes the size of the collection view cells depending on device screen size.
        //The cells are sized to 1/3 the length of the shorter side of the screen,
        //minus 10 points for margins.
        let frameSize = self.collectionView?.frame.size
        let shortestSide = min(frameSize!.height, frameSize!.width)
        let sizeOfItem = CGSizeMake(shortestSide / 3 - 10, shortestSide / 3 - 10)
        return sizeOfItem
    }
}
