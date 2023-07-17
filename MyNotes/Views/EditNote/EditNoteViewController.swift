//
//  EditNoteViewController.swift
//  MyNotes
//
//  Created by Rohit Kumar on 08/06/23.
//

import UIKit

protocol EditNoteDelegate: AnyObject {
    func updateNotes(with note: Note)
    func deleteNote(with note: Note)
}

class EditNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var eyeButton: UIBarButtonItem!
    var note: Note!
    weak var delegate: EditNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.text
        eyeButton.image =  note.isPrivateNote ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        note?.text = textView.text
        if note?.title.isEmpty == true {
            delegate?.deleteNote(with: note)
        } else {
            delegate?.updateNotes(with: note)
        }
    }
    
    
    @IBAction func eyeButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Please enter the password to \(note.isPrivateNote ? "remove from private notes" : "mark as private note").", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if KeychainHelper.shared.checkPassword(password: alertController.textFields?.first?.text ?? "") {
                self.note.isPrivateNote = !self.note.isPrivateNote
                self.eyeButton.image = self.note.isPrivateNote ? UIImage(systemName: "eye") :  UIImage(systemName: "eye.slash")
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "Wrong password", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Close", style: .default)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

