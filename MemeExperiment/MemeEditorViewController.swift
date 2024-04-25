//
//  MemeEditorViewController.swift
//  MemeExperiment
//
//  Created by Stanley Darmawan on 24/07/2016.
//  Copyright © 2016 Stanley Darmawan. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var botText: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var memedImage: UIImage?
    var meme: Meme?
    
    // configuring the text attributes
    let memeTextAttributes = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeWidth: -3.3,
    ] as [NSAttributedString.Key : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disabling shareButton
        shareButton.isEnabled = false

        // set the properties of textFields
        topText.text = "TOP"
        botText.text = "BOTTOM"
        configureTextField(textField: topText)
        configureTextField(textField: botText)
        
        // setting imagePickerView ContentMode
        imagePickerView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    // will set the detailed properties of top and bottom textFields
    func configureTextField(textField:UITextField) {
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable the camera button if camera source isn't found
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        
        self.tabBarController?.tabBar.isHidden = true
        
        // check if we create a new meme or editing existing meme
        if (meme != nil) {
            topText.text = meme?.upperTextString
            botText.text = meme?.lowerTextString
            imagePickerView.image = meme?.image
            shareButton.isEnabled = true
        }
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    // when album button is clicked
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFromSource(source: .photoLibrary)
    }
    
    // when camera button is clicked
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFromSource(source: .camera)
    }
    
    // helper function for camera/album buttons
    func pickAnImageFromSource(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if (botText.isFirstResponder){
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
            self.navigationController!.navigationBar.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
        self.navigationController!.navigationBar.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(upperTextString: self.topText.text!, lowerTextString:self.botText.text!, image:imagePickerView.image!, memedImage: memedImage!)
        
        // add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // generate memedImage
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        self.navigationController?.isNavigationBarHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        self.navigationController?.isNavigationBarHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    // share the meme
    @IBAction func shareMeme() {
        
        // generate memedImage
        memedImage = generateMemedImage()

        // pass generatedMemedImage as an activityItem
        let controller = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        //present ActivityViewController
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            if completed {
                
                // call save() when activity completed
                self.save()
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    // called when we hit the 'Cancel' button
    @IBAction func cancelModifyingImage(sender: AnyObject) {
//        shareButton.enabled = false
//        imagePickerView.image = nil
//        topText.text = "TOP"
//        botText.text = "BOTTOM"
        
        // return to the Sent Memes View
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    // MARK: delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear default textfield's texts
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismissing the keyboard when enter key is hit
        textField.resignFirstResponder()
        
        return true
    }
}

