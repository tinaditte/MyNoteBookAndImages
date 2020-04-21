//
//  EditingNoteController.swift
//  MyPersonalNotebook
//
//  Created by Tina Thomsen on 18/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import UIKit

class EditingNoteController: UIViewController {
	@IBOutlet weak var noteTitle: UITextField!
	@IBOutlet weak var noteText: UITextView!
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		noteTitle.text = "This is editing" //should equal the note pressed
		noteTitle.text = "Editing here" //should equal the note presseds text
		
		
    }
	
	@IBAction func saveEdit(_ sender: Any) {
		//update
		
	}
	
}
