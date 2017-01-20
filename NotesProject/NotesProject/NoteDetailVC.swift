//
//  NoteDetailVC.swift
//  NotesProject
//
//  Created by Codefights on 12/18/16.
//  Copyright © 2016 Codefights. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteDetailTextView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var noteDetailTextViewHeight: NSLayoutConstraint!
    
    var isAddNoteButtonPressed = false
    var selectedNote: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteDetailTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if let selectedNote = selectedNote {
            noteDetailTextView.text = selectedNote.noteInfo
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !noteDetailTextView.text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (selectedNote == nil) {
            noteDetailTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isMovingFromParentViewController && !self.isAddNoteButtonPressed {
            self.addOrUpdateNote()
        }
        NotificationCenter.default.removeObserver(self) // interesting!
    }
    
    // MARK: - UITextViewDelegate method
    
    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.isEnabled = !textView.text.isEmpty
    }
    
    // MARK: - IBActions
    
    @IBAction func addNoteButtonAction(_ sender: UIButton) {
        self.isAddNoteButtonPressed = true
        self.addOrUpdateNote()
    }

    @IBAction func shareAction() {
        let activityViewController = UIActivityViewController(activityItems: [noteDetailTextView.text], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getCurrentDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        formatter.dateStyle = .short
        return formatter.string(from: date)
        //Question about time, time, today, yesterday, ..., date ???
    }

    func addOrUpdateNote() {
        if noteDetailTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && !noteDetailTextView.text.isEmpty {
            if let selectedNote = selectedNote {
                selectedNote.noteInfo = self.noteDetailTextView.text
                CoreDataManager.shared.saveContext()
            } else {
                CoreDataManager.shared.insertNewNote(with: noteDetailTextView.text, dateTime: getCurrentDateAsString())
            }
             _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.noteDetailTextViewHeight.constant = self.view.frame.height - (keyboardRectValue.height + (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + 50)
            self.addNoteButton.isHidden = false
            UIView.animate(withDuration: 5, animations: {
                self.addNoteButton.transform = CGAffineTransform(scaleX: 3, y: 3) // buttons height, width * 3
                // why animateWithDuration change nothing ???
            })
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
