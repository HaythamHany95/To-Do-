//
//  TableViewController.swift
//  To Do
//
//  Created by Haytham on 26/09/2023.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categoriesArr: Results<Category>?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        
        categoriesArr = realm.objects(Category.self)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let newCategory = Category()
            newCategory.title = textField.text

//            self.categoriesArr.append(newCategory)
            
            try! self.realm.write({
                self.realm.add(newCategory)
            })
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add Your Category"
            
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArr?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArr?[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        print(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ItemTableViewController
        let selectedCategory = categoriesArr?[tableView.indexPathForSelectedRow?.row ?? 0]
        vc.category = selectedCategory
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Delete")
        guard let category = categoriesArr?[indexPath.row] else { return }
        try! realm.write({
            realm.delete(category)
        })
        tableView.reloadData()
    }
}
