//
//  ItemTableViewController.swift
//  To Do
//
//  Created by Haytham on 26/09/2023.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    var itemsArr: Results<Item>?
    var category: Category? {
        didSet {
            print(category?.title ?? "")
            itemsArr = category?.items.sorted(byKeyPath: "title")
        }
    }
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category?.title
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let newItem = Item()
            newItem.title = textField.text
            
            //            self.itemsArr.append(newItem)
            
            try! self.realm.write({
                self.category?.items.append(newItem)
            })
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { itemTextField in
            itemTextField.placeholder = "Add Your Item Here"
            
            textField = itemTextField
        }
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item = itemsArr?[indexPath.row]
        try! realm.write({
            item!.checked = !item!.checked
        })
        
        if item?.checked == true {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        try! realm.write({
            realm.add(item!)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArr?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemsArr?[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Delete")
        
        guard let item = itemsArr?[indexPath.row] else { return }
        try! realm.write({
            realm.delete(item)
        })
        tableView.reloadData()
    }
    
}
