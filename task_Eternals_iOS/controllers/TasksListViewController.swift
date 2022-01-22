//
//  SubCategoryListViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 18/01/22.
//

import UIKit
import CoreData

class TasksListViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var categoryName2: UILabel!
    
    @IBOutlet weak var tasksTV: UITableView!
    var categoryName: String!
    var details:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryName2.text = categoryName
        tasksTV.delegate = self
        tasksTV.dataSource = self
        showTasks()
        tasksTV.reloadData()
    }
    
    
    
    @IBAction func newTask(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert!", message: "New Task", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter Task name"
            field.returnKeyType = .next
            field.keyboardType = .emailAddress
        }
        alert.addTextField { field in
            field.placeholder = "Enter Task Description"
            field.returnKeyType = .next
            field.keyboardType = .emailAddress
        }
        //// - TODO SNEHITHA
        alert.addTextField{ field in
            field.placeholder = "Enter Status"
            field.returnKeyType = .next
            field.keyboardType = .emailAddress
        }
        
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
            let status = fields[2]
            print(status)
            guard let taskStatus = status.text, !taskStatus.isEmpty else{
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
            record.setValue(taskStatus, forKey: "status")
            print(taskStatus)
            
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
    
    func showTasks(){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //let predicate = NSPredicate(format: "categoryName == %@", categoryName)
        //print(categoryName)
        let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Task")
        //fetchRequest.predicate = predicate
        do {
            details =
            try managedContext.fetch(fetchRequest)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
}
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskFullDetails"{
            let destination = segue.destination as! TaskDetailsViewController
            let selectedRow = tasksTV.indexPathForSelectedRow!.row
            let cat = details[selectedRow]
            destination.categoryName3 = String(describing: cat.value(forKey: "categoryName") ?? "-")
            destination.taskName3 = String(describing: cat.value(forKey: "taskName") ?? "-")
            destination.status3 = String(describing: cat.value(forKey: "status") ?? "-")
            destination.description3 = String(describing: cat.value(forKey: "taskDescription") ?? "-")
            //destination.dueDate3 = Date(
           //destination.currentDate3 = Date(describing: cat.value(forKey: "startDate") ?? "-")
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
        self.performSegue(withIdentifier: "taskFullDetails", sender: self)
    }
}

extension TasksListViewController: UITableViewDataSource{
    
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
    
}
