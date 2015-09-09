//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let reuseIdentifier = "MemeTableViewCell"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var memes: [Meme]!
    
    //MARK: - Overrides
    //MARK: View methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Set local memes storage and editing status.
        self.editing = false
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Segue to editor view if app launches with no sent memes.
        if memes.count == 0 {
            self.performSegueWithIdentifier("TableViewToEditorSegue", sender: self)
        }
    }

    //MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesTableViewCell
        
        //Set up cell with data from Meme object.
        cell.cellImageView.image = memes[indexPath.row].memedImage
        cell.cellMainTextLabel.text = memes[indexPath.row].topText
        cell.cellDetailTextLabel.text = memes[indexPath.row].bottomText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            //Remove meme from shared storage, update local copy,
            //delete from table view and change edit button text back to "Edit".
            appDelegate.memes.removeAtIndex(indexPath.row)
            self.memes = appDelegate.memes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.editButton.title = "Edit"
        }
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Get meme image, pass it and indexPath to the detail view controller.
        let image = memes[indexPath.row].memedImage
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesDetailViewController") as! SentMemesDetailViewController
        
        nextVC.receivedImage = image
        nextVC.receivedIndex = indexPath
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - IB Action methods
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        
        //Toggles the table view in and out of editing mode
        //and changes the edit button text.
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        self.editButton.title = self.tableView.editing ? "Cancel" : "Edit"
    }
}
