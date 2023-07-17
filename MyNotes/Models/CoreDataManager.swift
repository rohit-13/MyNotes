//
//  CoreDataManager.swift
//  MyNotes
//
//  Created by Rohit Kumar on 08/06/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager(modelName: "MyNotes")
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion : (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError("Unresolved error \(error?.localizedDescription)")
            }
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            }
            catch {
                print("An error occured while saving \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataManager {
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.lastUpdated = Date()
        note.text = ""
        note.isPrivateNote = false
        save()
        return note
    }
    
    func fetchNotes(filter: String? = nil, showPrivateNotes: Bool = false) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        if !showPrivateNotes {
            let predicate = NSPredicate(format: "isPrivateNote = %d", showPrivateNotes)
            request.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteNote(note: Note){
        viewContext.delete(note)
        save()
    }
}
