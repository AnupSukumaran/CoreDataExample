//
//  ViewController.swift
//  Saving Data BayBeh
//
//  Created by Kyle Lee on 7/2/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
        } catch {}
        
    }
    @IBAction func trashuButton(_ sender: UIBarButtonItem) {
        
         let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        let deleteData = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        
        do {
            try PersistenceServce.context.execute(deleteData)
            print("ALLDataDeleted")
            people.removeAll()
            tableView.reloadData()
        } catch  {
             print(error.localizedDescription)
        }
        
    }
    
    @IBAction func onPlusTapped() {
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        let action = UIAlertAction(title: "Post", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let age = alert.textFields!.last!.text!
            
            let person = Person(context: PersistenceServce.context)
            person.name = name
            
            person.age = Int16(age)!
            PersistenceServce.saveContext()
            self.people.append(person)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func delete(_ sender: Any?) {
        print("Done")
        let index = sender as! Int
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        if var results:[Person] = try? PersistenceServce.context.fetch(fetchRequest) {
            
            PersistenceServce.context.delete(results[index])
            results.remove(at: index)
            
        }
        
            do {
                try PersistenceServce.context.save()
                tableView.reloadData()
            } catch  let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        
        tableView.reloadData()
        }
        
        
    }
    


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = String(people[indexPath.row].age)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected ROw = \(indexPath.row)")
        // delete(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
           people.remove(at: indexPath.row)
            delete(indexPath.row)
            
            
        }
    }
}

