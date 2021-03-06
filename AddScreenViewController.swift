//
//  AddScreenViewController.swift
//  MyPersonalNotebook
//
//  Created by Tina Thomsen on 15/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//
/*
Upload image from camera or photoroll to Cloudstorage
Upload image from an imageview, where the image was just dragged an image to storyboard

1) Download image from Cloud Storage (V)
2) Add image field to Note class (V)
3) Display image when note is shown
4) Upload an image from image view to Cloud storage
5) Use ios photoalbum to select an image
6) Allow user to change current photo to a photo 
*/

import UIKit

class AddScreenViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	
	//Fields
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var imageView: UIImageView!
	var rowNumber = 0
	var behaveAsNew = false
	var imagePicker = UIImagePickerController()
	
    override func viewDidLoad() {
		super.viewDidLoad()
		imagePicker.delegate = self //assign the object from this class to handle image picking return. Self reference the object
		config()
		
		if behaveAsNew == false{
			showNote()
		}else if behaveAsNew == true{
			print("new note mode entered in asvc")
			
		}
	}
	
	func config() {
		imageView.image = UIImage()
	}
	
	//IMAGE FUNCTIONS'
	
	@IBAction func downloadBtn(_ sender: Any) {
		imagePicker.sourceType = .photoLibrary
		imagePicker.delegate = self
		present(imagePicker, animated: true, completion: nil)
	}
	
	private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) != nil{
			CloudStorage.uploadImage(imageData: (imageView.image?.jpegData(compressionQuality: 0.6))! , vc: self)
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}

	//NOTE FUNCTIONS
	
	@IBAction func saveNote(_ sender: Any) {
		if behaveAsNew == true{
			insertNewNote()
		}else if behaveAsNew == false{
			CloudStorage.updateNote(index: rowNumber, head: textField.text!, body: textView.text!)
		}
	}
	
	func showNote(){
		let note = CloudStorage.getNoteAt(index: rowNumber)
		textField.text = note.head
		textView.text = note.body
		if note.image != "empty"{
			CloudStorage.downloadImage(name: note.image, vc: self)
		}else{
			print("Note is empty")
		}
	}
	
	func insertNewNote(){
		let newNote = CloudStorage.createNote(head: textField.text!, body: textView.text!, img: "empty")
		CloudStorage.list.append(newNote)
	}
}
