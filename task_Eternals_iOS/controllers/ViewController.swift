//
//  ViewController.swift
//  task_Eternals_iOS
//
//  Created by Sravan Sriramoju on 2022-01-12.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories:[String] = []
    var details:[NSManagedObject] = []
    
    //creating category array to get the core data variables
    var category = [Categories]()
    
    var duplicateCategoryCheck = false
    
    @IBOutlet weak var categoryTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do List"
        
        categoryTv.delegate=self
        categoryTv.dataSource=self
        showCategories()
        categoryTv.reloadData()
        
       
    }
    
    @IBAction func addCategory() {
        showAlert()
    }
    
   
    func showAlert(){
        let alert = UIAlertController(title: "Alert!", message: "Please enter the Category Name", preferredStyle: .alert)
        
        //adding text field
        alert.addTextField { field in
            field.placeholder = "Category name"
            field.returnKeyType = .continue
            field.keyboardType = .emailAddress
        }
        
        //adding two buttons to alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] _ in
            // read the textfields from alert box
            guard let fields = alert.textFields, fields.count == 1 else{
                return
            }
            let catName = fields[0]
            guard let name = catName.text, !name.isEmpty  else{
                return
            }
            /// for same name for category alert
            //let categoryNames = self.category.map {$0.categoryName?.lowercased()}
            //guard categoryNames.contains(name.lowercased()) else {self.showAlertWhenSameName(); return}
            
            // for same name for category alert
            for i in 0..<details.count{
                if name == String(describing: details[i].value(forKey: "categoryName") ?? "_"){
                    self.showAlertWhenSameName()
                }
            }
            
            //self.categories.append(name)
            if duplicateCategoryCheck == false {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName:"Categories", in:managedContext)!
            let record = NSManagedObject(entity:entity, insertInto:managedContext)
            record.setValue(name, forKey:"categoryName")
            
            do {
                try managedContext.save()
                details.append(record)
                print("Category Added!")
                //To display an alert box
                let alertController = UIAlertController(title: "Message", message: "New Category Added!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } catch
            let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
            categoryTv.reloadData()
        }
            
        }))
        present(alert, animated: true)
    }
    
    // show alert when the name of the folder is taken
    func showAlertWhenSameName() {
        duplicateCategoryCheck = true
        let alert = UIAlertController(title: "Name Taken", message: "Please choose another name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        return
    }
    
    //fetching data from coredata
    func showCategories(){
        var statusOpen = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Categories")
        do {
            details =
            try managedContext.fetch(fetchRequest)
        } catch
            let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        var i = details.count
        var j = 0
        
        while(i > 0){
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format: "categoryName = %@", details[j].value(forKey: "categoryName") as! CVarArg)
            print(details[j].value(forKey: "categoryName") as! CVarArg)
            do {
                let results = try managedContext.fetch(fetchRequest)
                var k = results.count
                var l = 0
                
                while(k > 0) {
                    let object = results[l] as! NSManagedObject
                    if((object.value(forKey: "status")) as! String == "Open"){
                        statusOpen = true
                        print("true")
                        details[j].setValue(" ", forKey: "statusIndicator")
                    }else{
                        details[j].setValue("✓", forKey: "statusIndicator")
                    }
                    k -= 1
                    l += 1
                    
                }
            } catch
            let error as NSError {
                print(error)
            }
            i -= 1
            j += 1
        }
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        showCategories()
        categoryTv.reloadData()
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "taskslist" {
//            if let indexPath = sender as? IndexPath {
//                let destVC = segue.destination as! TasksListViewController
//                let new = String(details[indexPath.row].value(forKey: "categoryName"))
//                destVC.categoryName = new
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskslist"{
            let destination = segue.destination as! TasksListViewController
            let selectedRow = categoryTv.indexPathForSelectedRow!.row
            let cat = details[selectedRow]
            destination.categoryName = String(describing: cat.value(forKey: "categoryName") ?? "-")
        }
    }
}
    
  

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cat = details[indexPath.row]
//       if let vc=storyboard?.instantiateViewController(withIdentifier: "taskslist") as? TasksListViewController{
//            vc.categoryName = String(describing: cat.value(forKey: "categoryName"))
//            self.navigationController?.pushViewController(vc, animated: true)
//       }
      //  self.performSegue(withIdentifier: "taskslist", sender: self)
    }

    
}

extension ViewController: UITableViewDataSource{
    
    //to delete row when you swipe
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { [self] _, _, _ in
            do{
                self.context.delete(self.details[indexPath.row])
                try self.context.save()
                self.showCategories()
            }catch{
                print(error)
            }
            categoryTv.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cat = details[indexPath.row]
        let cell = categoryTv.dequeueReusableCell(withIdentifier: "categories", for: indexPath) as! CategoryTableViewCell
        //cell.textLabel?.text = categories[indexPath.row]
        cell.categoryLabel?.text = String(describing: cat.value(forKey: "categoryName") ?? "-")
        cell.statusLabel?.text = String(describing: cat.value(forKey: "statusIndicator") ?? ">")
        
        return cell
    }
    
    
}

class CategoryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
   
}


