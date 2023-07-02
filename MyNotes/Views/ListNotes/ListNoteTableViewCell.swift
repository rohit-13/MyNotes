//
//  ListNoteTableViewCell.swift
//  MyNotes
//
//  Created by Rohit Kumar on 08/06/23.
//

import UIKit

class ListNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func setup(note: Note) {
        titleLabel.text = note.title
        
        let attributedString = NSMutableAttributedString(string: note.description)
        let range = NSRange(location: 0, length: note.lastUpdated.format().count)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: range)
        descriptionLabel.attributedText = attributedString
    }

}
