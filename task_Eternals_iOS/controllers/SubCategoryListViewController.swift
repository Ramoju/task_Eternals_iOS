//
//  SubCategoryListViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 18/01/22.
//

import UIKit

class SubCategoryListViewController: UIViewController {

    @IBOutlet weak var categoryName2: UILabel!
    
    var categoryName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryName2.text=categoryName
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
