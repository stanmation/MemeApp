//
//  MemeEditorViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 24/07/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    struct Meme {
        var upperTextString:String?
        var lowerTextString:String?
        var image:UIImage?
        var memedImage:UIImage?
    }
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton:UIBarButtonItem!
    @IBOutlet weak var topText:UITextField!
    @IBOutlet weak var botText:UITextField!
    @IBOutlet weak var cancelButton:UIBarButtonItem!
    var memedImage: UIImage?
    
    // configuring the text attributes
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeWidthAttributeName : -3.3,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disabling shareButton and cancelButton
        shareButton.enabled = false
        cancelButton.enabled = false

        // set the properties of textFields
        topText.text = "TOP"
        botText.text = "BOTTOM"
        configureTextField(topText)
        configureTextField(botText)
        
        // setting imagePickerView ContentMode
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    // will set the detailed properties of top and bottom textFields
    func configureTextField(textField:UITextField){
        textField.delegate = self
        textField.backgroundColor = UIColor.clearColor()
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable the camera button if camera source isn't found
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    // when album button is clicked
    @IBAction func pickAnImageFromAlbum(sender: AnyObject){
        pickAnImageFromSource(.PhotoLibrary)
    }
    
    // when camera button is clicked
    @IBAction func pickAnImageFromCamera(sender: AnyObject){
        pickAnImageFromSource(.Camera)
    }
    
    // helper function for camera/album buttons
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification:NSNotification){
        if (botText.isFirstResponder()){
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            self.navigationController!.navigationBar.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.view.frame.origin.y = 0
        self.navigationController!.navigationBar.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillHideNotification, object:nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(upperTextString: self.topText.text!, lowerTextString:self.botText.text!, image:imagePickerView.image, memedImage: memedImage)
    }
    
    // generate memedImage
    func generateMemedImage() -> UIImage
    {
        // hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        self.toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        self.navigationController?.navigationBarHidden = false
        self.toolBar.hidden = false
        
        return memedImage
    }
    
    // share the meme
    @IBAction func shareMeme(){
        
        // generate memedImage
        memedImage = generateMemedImage()

        // pass generatedMemedImage as an activityItem
        let controller = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        //present ActivityViewController
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if completed {
                // call save() when activity completed
                self.save()
            }
        }
    }
    
    // called when we hit the 'Cancel' button
    @IBAction func cancelModifyingImage(sender: AnyObject) {
        shareButton.enabled = false
        cancelButton.enabled = false
        imagePickerView.image = nil
        topText.text = "TOP"
        botText.text = "BOTTOM"
    }

    // MARK: delegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
        cancelButton.enabled = true

    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // clear default textfield's texts
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismissing the keyboard when enter key is hit
        textField.resignFirstResponder()
        
        return true
    }
    

    
    
    
}
