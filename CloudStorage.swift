//
//  CloudStorage.swift
//  MyPersonalNotebook
//
//  Created by Tina Thomsen on 15/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CloudStorage{
	
	static var list = [ Note ]()
	static let db = Firestore.firestore()
	static let storage = Storage.storage()
	private static let notes = "Notes"
	static var imageArr: [UIImage] = []
	
	static func downloadImage(name: String, vc: AddScreenViewController){
		print("Download called...")
		let imgref = storage.reference(withPath: name) //get filehandler
		imgref.getData(maxSize: 400000) { (data, error) in
			if error == nil{
				print("Success downloading image ")
				let img = UIImage(data: data!)
				DispatchQueue.main.async {
					//prevents bg thread from interrupting main thread, that handles user input
					vc.imageView.image = img
				}
			}else{
				print("An error occureed when downloading image: \(error.debugDescription)")
			}
		}
	}
	
	static func uploadImage(imageData: Data, vc: AddScreenViewController){
		let data = Data ()
		let storageRef = storage.reference()
		let imageref = storageRef.child(<#T##path: String##String#>)
//		let storangeRef = storage.reference()
//		let imageRef = storangeRef.child("Images")
//		let uploadMetaData = StorageMetadata()
//		uploadMetaData.contentType = "image/jpeg"
//
//		imageRef.putData(imageData, metadata: uploadMetaData) { (uploadMetaData, error) in
//			if error != nil{
//				print("Erroer while uploading pic")
//				return
//			}else{
//				vc.imageView.image = UIImage(data: imageData)
//				print("Meta data of uploaded image: \(String(describing: uploadMetaData))")
//			}
//		}
		
	}
	
	static func getSize() -> Int{
		return list.count
	}
	
	static func getNoteAt(index: Int) -> Note{
		return list[index]
	}
	
	static func startListener(tableView: UITableView){
		print("Listening has begun")
		db.collection(notes).addSnapshotListener{ (snap, error) in
			if error == nil {
				self.list.removeAll() //empty array or duplicates will happen
				for note in snap!.documents{
					let map = note.data()
					let head = map["head"] as! String
					let body = map["body"] as! String
					let image = map["image"] as? String ?? "empty"
					let newNote = Note(id: note.documentID, head:head, body:body, img:image)
					self.list.append(newNote)
				}
				DispatchQueue.main.async {
					tableView.reloadData()
				}
			}
		}
	}

	static func deleteNote(id:String){
		let docRef = db.collection(notes).document(id)
		docRef.delete()
	}
	
	static func createNote(head: String, body: String, img: String) -> Note {
		var map = [String: String]()
		map["head"] = head
		map["body"] = body
		map["empty"] = img
		
		let docRef = db.collection(notes).addDocument(data: map)
		
		
		let newNote = Note(id: docRef.documentID, head: head, body: body, img: img)
		list.append(newNote)
		print(newNote)
		return newNote
	}
	
	static func updateNote(index: Int, head: String, body:String){
		let note = list[index]
		
		let docRef = db.collection(notes).document(note.id)
		var map = [String:String]()
		map["head"] = head
		map["body"] = body
		docRef.setData(map)
	}
}
