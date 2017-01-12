//
//  NotesVC.swift
//  NotesProject
//
//  Created by Codefights on 12/7/16.
//  Copyright © 2016 Codefights. All rights reserved.
//

import UIKit
import CoreData

//extension

class NotesVC: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    // ??? remove UITableViewDataSource, UITableViewDelegate and enjoy the crash of the app :P
    @IBOutlet weak var notesTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNotes = [Notes]()
    var allNotes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allNotes = CoreDataManger.sharedManager.fetchAllNotes()

        self.definesPresentationContext = true // ???
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        notesTableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.allNotes = CoreDataManger.sharedManager.fetchAllNotes()
        //self.notesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        self.notesTableView.reloadData()
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredNotes = self.allNotes.filter { note in
            return note.noteInfo!.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        notesTableView.reloadData()
    }
    
    // MARK: - Table view data source and delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNotesList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = getNotesList()[indexPath.row]
        noteCell.noteNameLabel.text = note.noteInfo
        noteCell.dateTimeLabel.text = note.dateTime
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNoteObjectID = getNotesList()[indexPath.row].objectID
        let selectedNote = CoreDataManger.sharedManager.fetchSelectedNote(with: selectedNoteObjectID)
        // did force unwrap below ???
        let noteDetailsVC = storyboard!.instantiateViewController(withIdentifier: "newNoteVC") as! NoteDetailVC
        noteDetailsVC.selectedNote = selectedNote
        self.navigationController!.pushViewController(noteDetailsVC, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func newNoteButtonAction(_ sender: UIButton) {
        let noteDetailsVC = storyboard?.instantiateViewController(withIdentifier: "newNoteVC")
        self.navigationController?.pushViewController(noteDetailsVC!, animated: true)
        // why not  force self.navigationController!.pushViewController(noteDetailsVC!, animated: true) ???
    }
    
    // MARK: - Other functions
    
    func getNotesList() -> [Notes] {
        return searchController.isActive && searchController.searchBar.text != "" ? self.filteredNotes : self.allNotes
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
