import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	//Fields
	private var newNoteMode = false
	
	//Outlets
	@IBOutlet var notesoverview: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		notesoverview.delegate = self // handles event for Tableview
		notesoverview.dataSource = self // provides data for tableview
		CloudStorage.startListener(tableView: notesoverview)
	}

	override func viewWillAppear(_ animated: Bool) {
		notesoverview.reloadData()
	}
	
	@IBAction func addNote(_ sender: UIButton) {
		//newNoteMode = true
		//print("mode should be changed now to ture:  \(newNoteMode) ")
	}
	
	//TABLE VIEW FUNCTIONS
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//tableView.reloadData()
		return CloudStorage.getSize()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = notesoverview.dequeueReusableCell(withIdentifier: "Cell")
		cell?.textLabel?.text = CloudStorage.getNoteAt(index: indexPath.row).head
		return cell!
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
		if segue.identifier == "editNoteSegue"{
			if let destination = segue.destination as? AddScreenViewController{
					destination.rowNumber = notesoverview.indexPathForSelectedRow!.row
			}
		}else if segue.identifier == "addNoteSegue"{
			newNoteMode = true
			if let destination = segue.destination as? AddScreenViewController{
				destination.behaveAsNew = newNoteMode
			}
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Selected row number \(indexPath.row)")
	}
}
