//
//  NoteDetailVC.swift
//  NotesProject
//
//  Created by Codefights on 12/18/16.
//  Copyright © 2016 Codefights. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController {

    @IBOutlet weak var noteDetailTextView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var noteDetailTextViewHeight: NSLayoutConstraint!
    
    var isAddNoteButtonPressed = false
    var selectedNote: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        if let selectedNote = selectedNote {
            noteDetailTextView.text = selectedNote.noteInfo
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (selectedNote == nil) {
            noteDetailTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isMovingFromParentViewController && !self.isAddNoteButtonPressed {
            self.f()
        }
        NotificationCenter.default.removeObserver(self) // interesting!
    }
    
    @IBAction func addNoteButtonAction(_ sender: UIButton) {
        self.isAddNoteButtonPressed = true
        self.f()
    }
    
    func getCurrentDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    func f() {
        if noteDetailTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && !noteDetailTextView.text.isEmpty {
            let moc = CoreDataManger.sharedManager.getContext() // ??? outside if i ujas
            if let selectedNote = selectedNote {
                selectedNote.noteInfo = self.noteDetailTextView.text
            } else {
                let newNote = Notes(context: moc)
                // ??? Question about time, time, today, yesterday, ..., date
                //Notes(entity: Notes.entity(), insertInto: moc)
                //let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context) as! Notes
                newNote.noteInfo = noteDetailTextView.text
                newNote.dateTime = self.getCurrentDateAsString()
                _ = self.navigationController?.popViewController(animated: true)
            }
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context.")
            }
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            //noteDetailTextView.frame.size.height ???
            self.noteDetailTextViewHeight.constant = self.view.frame.height - (keyboardRectValue.height + self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + 40)
            self.addNoteButton.isHidden = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
