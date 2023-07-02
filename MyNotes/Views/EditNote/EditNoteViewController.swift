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
    var note: Note!
    weak var delegate: EditNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.text
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("ended")
    }
}

