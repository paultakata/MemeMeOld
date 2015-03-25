//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - Properties

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var chooseAnImageLabel: UILabel!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    //Use "Impact" font for true meme wow factor.
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 50)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    var viewHasMovedUp = false
    var memedImage: UIImage?

    //MARK: - Overrides
    //MARK: View methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set all text field attributes.
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.minimumFontSize = 10
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.minimumFontSize = 10
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Set all button, label and text field availabilities.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = (memeImageView.image != nil)
        cancelButton.enabled = (appDelegate.memes.count != 0)
        chooseAnImageLabel.hidden = (memeImageView.image != nil)
        topTextField.hidden = (memeImageView.image == nil)
        bottomTextField.hidden = (memeImageView.image == nil)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //Make sure to unsubscribe from notifications.
        self.unsubscribeFromKeyboardNotifications()
    }

    //MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Touch responder
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        //Hide the keyboard if the user touches anywhere
        //outside the keyboard area.
        let touch = touches.anyObject() as UITouch
        
        if touch.phase == UITouchPhase.Began {
            
            if topTextField.isFirstResponder() {
                topTextField.resignFirstResponder()
                
            } else if bottomTextField.isFirstResponder() {
                bottomTextField.resignFirstResponder()
            }
        }
    }
    
    //MARK: - IB Action methods

    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        //Create a memed image, pass it to the activity view controller.
        self.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!],
            applicationActivities: nil)
        
        //If the user completes an action in the activity view controller,
        //save the meme to the shared storage.
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        //Return to previous view.
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        
        //Present camera interface.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonPressed(sender: UIBarButtonItem) {
        
        //Present photo library interface.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Helper methods
    //MARK: Keyboard view handling and notifications

    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        //Move view up only if user is editing the bottom text field.
        if self.bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            viewHasMovedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //Move view back down only if it has previously moved up.
        if viewHasMovedUp {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            viewHasMovedUp = false
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Meme generating and saving

    func saveMeme() {
        
        //Create a new meme object and add it to the shared storage.
        let meme = Meme(topText: topTextField.text,
            bottomText: bottomTextField.text,
            originalImage: self.memeImageView.image!,
            memedImage: self.memedImage!)
        
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide the toolbars.
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        //Get a screenshot.
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show the toolbars.
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        
        //Crop the image to get rid of the extremely annoying status bar.
        let croppedImage = CGImageCreateWithImageInRect(memedImage.CGImage, self.memeImageView.frame)
        
        return UIImage(CGImage: croppedImage)!
    }

    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //If user has picked an image, put it in the imageView and dismiss the image picker.
        if let newImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            memeImageView.image = newImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //Remove placeholder text when user begins editing.
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Return key also dismisses keyboard.
        textField.resignFirstResponder()
        
        return true
    }
}
