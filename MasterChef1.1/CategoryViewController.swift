//
//  CategoryViewController.swift
//  MasterChef1.1
//
//  Created by yejing zhou on 2016/12/4.
//  Copyright © 2016年 yejing zhou. All rights reserved.
//

import UIKit
import Firebase



class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var CategoryTable: UITableView!
    


    var posts = [GroceryItem]()
    var showRef: FIRDatabaseReference!
    var categorykey = "Fruits"
    var updatekey = ""
    var updatevalue = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        
        self.CategoryTable.delegate = self
        
        self.CategoryTable.dataSource = self
        
    //    CategoryTable.reloadData()
        
        CategoryTable.allowsMultipleSelectionDuringEditing = true
    
        showRef.observe(.value, with: { snapshot in
            
                                for item in snapshot.children {
                                    let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                               //   self.posts.insert(groceryItem, at: (item as AnyObject).index)
                                    self.posts.append(groceryItem)
                                    print("\(self.posts)")
                                }
            
                                self.CategoryTable.reloadData()
                            })
        categorykey = showRef.key
        
        self.title = categorykey

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(animated)
//        
//        showRef.observe(.value, with: { snapshot in
//            
//            for item in snapshot.children {
//                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
//                //   self.posts.insert(groceryItem, at: (item as AnyObject).index)
//                self.posts.append(groceryItem)
//                print("\(self.posts)")
//            }
//            
//            self.CategoryTable.reloadData()
//        })
//        
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        
//        super.viewDidDisappear(animated)
//        
//        showRef.removeAllObservers()
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   print("in posts \(posts.count)")
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyProtoCell") as! MyGroceryCell
        
        
        let groceryItem = posts[indexPath.row]
        
        myCell.showName.text = groceryItem.Name
        myCell.showQuantity.text = "Quantity:" + groceryItem.Quantity
        myCell.showBestbyDate.text = "Best by Date:" + groceryItem.BestbyDate
        
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "  Edit") { action, index in
            
            let alert = UIAlertController(title: "Editing", message: "New Quantity Here", preferredStyle: .alert)
            
            alert.addTextField{ (textField) in
                textField.text = "0"
                textField.alpha = 0.6
            }
            
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
                
                self.showRef.removeAllObservers()
                
                let textfield = alert?.textFields![0]
                
                let myCell = tableView.cellForRow(at: indexPath) as! MyGroceryCell
                
                myCell.showQuantity.text = "Quantity:" + (textfield?.text)!

                self.updatekey = myCell.showName.text!
                self.updatevalue = (textfield?.text)!
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: self.categorykey).child(self.updatekey)
                
                groceryItemRef.updateChildValues(["Quantity": self.updatevalue])
                
           //     self.CategoryTable.reloadRows(at: [indexPath], with: .automatic)
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
         //   print("edit done")
        }
        
        edit.backgroundColor = UIColor.magenta
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") {action, index in
            
        self.showRef.removeAllObservers()
            
        let willdelete = self.posts[indexPath.row]
            
        
        FIRDatabase.database().reference().child(self.categorykey).child(willdelete.Name).removeValue()

        self.posts.remove(at: indexPath.row)
            
        self.CategoryTable.deleteRows(at: [indexPath], with: .automatic)
            
        
        }
        
        delete.backgroundColor = UIColor.red
        
        return [edit,delete]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
