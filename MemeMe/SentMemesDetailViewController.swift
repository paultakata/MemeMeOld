//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var longPressLabel: UILabel!
    
    var receivedImage: UIImage!
    var receivedIndex: NSIndexPath!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: - Overrides
    //MARK: View methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set imageView to the image received from the parent view conroller.
        memeImageView.image = receivedImage
        
        //The following is to show an explanatory label to the user
        //only on first use, and make sure it stays hidden after that.
        longPressLabel.alpha = 0.0
        
        if appDelegate.shouldShowLabel {
            
            longPressLabel.alpha = 1.0
            UIView.animateWithDuration(1.0,
                delay: 1.0,
                options: nil,
                animations: {self.longPressLabel.alpha = 0.0},
                completion: nil)
            
            appDelegate.shouldShowLabel = false
        }
    }

    //MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IB Action methods
    
    @IBAction func imageLongPressed(sender: UILongPressGestureRecognizer) {
        
        //Create an alert popup to allow the user to delete the meme
        //or go to the editor.
        let alert = UIAlertController(title: "Delete",
            message: "Would you like to delete this meme?",
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Yes, I didn't lol",
            style: .Destructive,
            handler: { (action) in
                
                let parentVC = self.parentViewController
                
                if parentVC!.isMemberOfClass(SentMemesTableViewController) {
                    self.appDelegate.memes.removeAtIndex(self.receivedIndex.row)
                } else {
                    self.appDelegate.memes.removeAtIndex(self.receivedIndex.item)
                }
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        )
        
        let noAction = UIAlertAction(title: "No, it's soooo funny!!!11!",
            style: .Cancel,
            handler: nil)
        
        let editAction = UIAlertAction(title: "Wanna make betterer one",
            style: .Default,
            handler: { (action) in
                
                let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
                self.navigationController?.presentViewController(nextVC, animated: true, completion: nil)
            }
        )
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        alert.addAction(editAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
