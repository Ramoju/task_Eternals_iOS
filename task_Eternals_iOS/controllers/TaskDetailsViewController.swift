//
//  TaskDetailsViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 19/01/22.
//

import UIKit

class TaskDetailsViewController: UIViewController {

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
    
    @IBAction func editTaskBtn(_ sender: UIButton) {
        
        
        
        
        
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
