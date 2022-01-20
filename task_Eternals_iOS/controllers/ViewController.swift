//
//  ViewController.swift
//  task_Eternals_iOS
//
//  Created by Sravan Sriramoju on 2022-01-12.
//

import UIKit

class ViewController: UIViewController {

    
    var categories = ["Books", "Groceries", "Shopping-List", "Movies"]
    @IBOutlet weak var categoryTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTv.delegate=self
        categoryTv.dataSource=self
        categoryTv.reloadData()
    }
    
    @IBAction func addCategory() {
        showAlert()
    }
    
   
    func showAlert(){
        let alert = UIAlertController(title: "Alert!", message: "Please enter the Category Name", preferredStyle: .alert)
        
        //adding text field
        alert.addTextField { field in
            field.placeholder = "category name"
            field.returnKeyType = .continue
            field.keyboardType = .emailAddress
        }
        
        //adding two buttons to alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [self] _ in
            // read the textfields from alert box
            guard let fields = alert.textFields, fields.count == 1 else{
                return
            }
            let catName = fields[0]
            guard let name = catName.text, !name.isEmpty else{
                return
            }
            self.categories.append(name)
            categoryTv.reloadData()
        }))
        present(alert, animated: true)
    }
    }
    
  

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc=storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController") as? TasksListViewController{
            vc.categoryName = categories[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTv.dequeueReusableCell(withIdentifier: "categories", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
}

