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
    
    @IBOutlet weak var notesTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNotes = [Notes]()
    var allNotes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.allNotes = CoreDataManager.shared.fetchAllNotes() // ?????
        
        self.definesPresentationContext = true // ???
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        notesTableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.action = #selector(editDoneButtonAction(sender:))
    }
    
    func editDoneButtonAction(sender: UIBarButtonItem) {
        sender.title = sender.title == "Edit" ? "Done" : "Edit"
        
        if self.notesTableView.isEditing {
            self.notesTableView.isEditing = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.allNotes = CoreDataManager.shared.fetchAllNotes()
         notesTableView.setContentOffset(CGPoint(x: 0, y: self.searchController.searchBar.frame.height), animated: false)
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
        let selectedNote = getNotesList()[indexPath.row]
        // did force unwrap below ???
        let noteDetailsVC = storyboard!.instantiateViewController(withIdentifier: "newNoteVC") as! NoteDetailVC
        noteDetailsVC.selectedNote = selectedNote
        self.navigationController!.pushViewController(noteDetailsVC, animated: true)
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.delete(note: getNotesList()[indexPath.row])
            self.allNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade) // ???
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.title = "Done"
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.rightBarButtonItem?.title = "Edit"
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
