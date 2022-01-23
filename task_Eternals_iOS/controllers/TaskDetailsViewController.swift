//
//  TaskDetailsViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 19/01/22.
//

import UIKit

class TaskDetailsViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var categoryName3: String!
    var taskName3: String!
    var status3: String!
    var description3: String!
    var currentDate3: Date!
    var dueDate3: Date!
    var image3: UIImage!
    /// audio??
    
    
    
    
    @IBOutlet weak var categoryNameLb: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dueDateLb: UILabel!
    @IBOutlet weak var startDateLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var taskNameLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameLb.text = categoryName3
        taskNameLb.text = taskName3
        statusLb.text = status3
        descriptionLb.text = description3
        //music
        //imageView.image
        //startDateLb.text =
        //dueDateLb.text =
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
    let image = UIImagePickerController()
            image.delegate=self
            image.sourceType = .photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true)
            {
                
            }
            
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                print("success")
                print(image)
                imageView.contentMode = .scaleToFill
                imageView.image=image
                
            }
            else{
                
            }
            self.dismiss(animated: true, completion:nil)
    }
    @IBAction func editTaskBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert!", message: "Please enter the Category Name", preferredStyle: .alert)
                
                //adding text field
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    field.placeholder = self.categoryName3
                }
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    
                    field.placeholder = self.taskName3
                }
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    
                    field.placeholder = self.description3
                }
               

                
                //adding two buttons to alert
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
                    // read the textfields from alert box
                    guard let fields = alert.textFields, fields.count == 3 else{
                        return
                    }
                    let catName = fields[0]
                    guard let name = catName.text, !name.isEmpty  else{
                        return
                    }
                    let taskName = fields[1]
                    guard let name = taskName.text, !name.isEmpty  else{
                        return
                    }
                    let description = fields[2]
                    guard let name = description.text, !name.isEmpty  else{
                        return
                    }
                   
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                        }

                    
                }))
                self.present(alert, animated: true, completion: nil)
        
        
        
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
