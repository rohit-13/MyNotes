//
//  ListNotesViewController.swift
//  MyNotes
//
//  Created by Rohit Kumar on 08/06/23.
//

import UIKit

class ListNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, EditNoteDelegate, UISearchBarDelegate {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var notesCountLabel: UILabel!
    
    private var search: UISearchController!
    
    private var filteredNotes: [Note] = []
    private var allNotes: [Note] = [] {
        didSet {
            notesCountLabel.text = "\(allNotes.count) \(allNotes.count == 1 ? "Note" : "Notes")"
            filteredNotes = allNotes
        }
    }
    
    private var searchedText = "" {
        didSet {
            if searchedText.isEmpty {
                filteredNotes = allNotes
            } else {
                filteredNotes = allNotes.filter { $0.text.lowercased().contains(searchedText.lowercased()) }
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        self.navigationItem.searchController = search
        
        fetchNotesFromStorage()
    }
    
    @IBAction func newNoteButtonClicked(_ sender: Any) {
        goToEditNote(createNote())
    }
    
    private func goToEditNote(_ note: Note) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let controller = storyboard?.instantiateViewController(identifier: "EditNoteViewController") as! EditNoteViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func fetchNotesFromStorage() {
        allNotes = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        CoreDataManager.shared.deleteNote(note: note)
    }
    
    private func searchNotesFromStorage(_ searchText: String) {
        allNotes = CoreDataManager.shared.fetchNotes(filter: searchText)
    }
    
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        allNotes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        return note
    }
    
    // MARK: ListNotes Delegate
    func updateNotes(with note: Note) {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        allNotes = allNotes.sorted { $0.lastUpdated > $1.lastUpdated }
        tableView.reloadData()
    }
    
    func deleteNote(with note: Note) {
        let indexPath = indexForNote(id: note.id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        allNotes.remove(at: indexForNote(id: note.id, in: allNotes).row)
        deleteNoteFromStorage(note)
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNoteTableViewCell") as! ListNoteTableViewCell
        cell.setup(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(with: filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Search Controller Configuration
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedText = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
}
