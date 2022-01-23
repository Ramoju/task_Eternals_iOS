//
//  SubCategoryListViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 18/01/22.
//

import UIKit
import CoreData

class TasksListViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    //initiating date picker view
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let dateFormatter1 = DateFormatter()
    let date = Date()
    var searchController: UISearchController!
    
    @IBOutlet weak var categoryName2: UILabel!
    
    @IBOutlet weak var tasksTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var categoryName: String!
    var details:[NSManagedObject] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        categoryName2.text = categoryName
        tasksTV.delegate = self
        tasksTV.dataSource = self
        showTasks()
        tasksTV.reloadData()
    }
    
    
    
    @IBAction func newTask(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert!", message: "New Task", preferredStyle: .alert)
        
        //task name text field
        alert.addTextField { field in
            field.placeholder = "Enter Task name"
            field.returnKeyType = .next
            field.keyboardType = .emailAddress
        }
        //task description textfield
        alert.addTextField { field in
            field.placeholder = "Enter Task Description"
            field.returnKeyType = .next
            field.keyboardType = .emailAddress
        }
        //due date text field
        alert.addTextField { [self] (field) in
                field.text = eDate
                self.createDatePicker()
//              eDate=dateFormatter1.string(from: date)
                field.inputView = self.datePicker
                field.inputAccessoryView = self.toolBar
            }
        
        //// - TODO SNEHITHA
       
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            // read the textfields from alert box
            guard let fields = alert.textFields, fields.count == 3 else{
                return
            }
            let taskName = fields[0]
            guard let name = taskName.text, !name.isEmpty else{
                return
            }
            let taskdesc = fields[1]
            print(taskdesc)
            guard let taskDescription = taskdesc.text, !taskDescription.isEmpty else{
                return
            }
            let dueDate = fields[2]
            guard let endDate = dueDate.text else{
                return
            }
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName:"Task", in:managedContext)!
            let record = NSManagedObject(entity:entity, insertInto:managedContext)
            record.setValue(name, forKey:"taskName")
            record.setValue(categoryName, forKey: "categoryName")
            print(categoryName!)
            record.setValue(taskDescription, forKey:"taskDescription")
            record.setValue("Open", forKey: "status")
            record.setValue(datePicker.date, forKey: "dueDate")
            record.setValue(Date.now, forKey: "startDate")
            
            do {
                try managedContext.save()
                details.append(record)
                print("Task Added!")
                //To display an alert box
                let alertController = UIAlertController(title: "Message", message: "New Task Added!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } catch
            let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
            
            tasksTV.reloadData()
        }))
        present(alert, animated: true)
    }
    
    
    //datepickerview
    func createDatePicker(){
        //designing the datepicker
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 270, height: 200))
        self.datePicker.backgroundColor = UIColor.lightGray
        datePicker.datePickerMode = .dateAndTime
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TasksListViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(TasksListViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.toolBar.isHidden = false
        
    }


    var eDate: String = "00/00/00"
    @objc func doneClick() {
       // dateFormatter1.dateStyle = .short
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "YY/MM/DD"
        eDate = dateFormatter1.string(from: datePicker.date)
        print("here the date is:*****************"+eDate)
        

        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
    
    // used to fetch data from cd
    func showTasks(predicate: NSPredicate? = nil){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "categoryName == %@", categoryName)
        print(categoryName!)
        let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Task")
        fetchRequest.predicate = predicate
        do {
            details =
            try managedContext.fetch(fetchRequest)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
}
    
    
    
    
    var selectedRow: Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskFullDetails"{
            let destination = segue.destination as! TaskDetailsViewController
            selectedRow = tasksTV.indexPathForSelectedRow!.row
            let cat = details[selectedRow]
            destination.index = selectedRow
            destination.categoryName3 = String(describing: cat.value(forKey: "categoryName") ?? "-")
            destination.taskName3 = String(describing: cat.value(forKey: "taskName") ?? "-")
            destination.status3 = String(describing: cat.value(forKey: "status") ?? "-")
            destination.description3 = String(describing: cat.value(forKey: "taskDescription") ?? "-")
            destination.dueDate3 = String(describing: cat.value(forKey: "dueDate") ?? "-")
           destination.currentDate3 = String(describing: cat.value(forKey: "startDate") ?? "-")
            
          //destination.image3 = UIImage(
            
            
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension TasksListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cat = details[indexPath.row]
//       if let vc=storyboard?.instantiateViewController(withIdentifier: "taskslist") as? TasksListViewController{
//            vc.categoryName = String(describing: cat.value(forKey: "categoryName"))
//            self.navigationController?.pushViewController(vc, animated: true)
//       }
       // self.performSegue(withIdentifier: "taskFullDetails", sender: self)
    }
    
    
    
    
}

extension TasksListViewController: UITableViewDataSource{
    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            do{
//            self.context.delete(self.details[indexPath.row])
//                try self.context.save()
//                self.showTasks()
//            }catch{
//                print(error)
//            }
//            tasksTV.deleteRows(at: [indexPath], with: .fade)
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//
    //to delete row when you swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { [self] _, _, _ in
            do{
            self.context.delete(self.details[indexPath.row])
                try self.context.save()
                self.showTasks()
            }catch{
                print(error)
            }
            tasksTV.deleteRows(at: [indexPath], with: .automatic)
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
        let task = details[indexPath.row]
        let cell = tasksTV.dequeueReusableCell(withIdentifier: "taskDetails", for: indexPath)
        cell.textLabel?.text = String(describing: task.value(forKey: "taskName") ?? "-")
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // add predicate
            let predicate = NSPredicate(format: "taskName CONTAINS[cd] %@", searchBar.text!)
            showTasks(predicate: predicate)
        }
        
        
        /// when the text in text bar is changed
        /// - Parameters:
        ///   - searchBar: search bar is passed to this function
        ///   - searchText: the text that is written in the search bar
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                showTasks()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    
    
    
}
