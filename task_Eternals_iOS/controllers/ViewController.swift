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
    @IBOutlet weak var addCatBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTv.delegate=self
        categoryTv.dataSource=self
        
    }


    @IBAction func addCategory(_ sender: UIButton) {
        
        
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc=storyboard?.instantiateViewController(withIdentifier: "SubCategoryListViewController") as? SubCategoryListViewController{
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

