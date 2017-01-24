//
//  GroceryViewController.swift
//  MasterChef1.1
//
//  Created by yejing zhou on 2016/12/6.
//  Copyright © 2016年 yejing zhou. All rights reserved.
//

import UIKit
import Firebase

class GroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var GroceryTable: UITableView!
   
    
    var ref: FIRDatabaseReference!
    var gname = ""
    var list = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.GroceryTable.delegate = self
        self.GroceryTable.dataSource = self
        
        self.ref = FIRDatabase.database().reference(withPath: "Shoplist")
        // Do any additional setup after loading the view.
        GroceryTable.allowsMultipleSelectionDuringEditing = true
        
        ref.queryOrdered(byChild: "Completed").observe(.value, with: { snapshot in
                
            for item in snapshot.children {
                    
                let newitem = Item(snapshot: item as! FIRDataSnapshot)
                    
                self.list.append(newitem)
            }
                self.GroceryTable.reloadData()
        })
        
    }
    
    @IBAction func addtolist(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "What Do You Want", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.text = "egg"
            textField.alpha = 0.6
        }
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
           
            self.ref.removeAllObservers()
            
            let textfield = alert?.textFields![0]
            
            let listitem = Item(Name: (textfield?.text)!, Completed: false)
            
            self.gname = listitem.Name
            
            self.list.append(listitem)
            
            self.ref.child(listitem.Name).setValue(listitem.toAnyObject())
            
            self.GroceryTable.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "item")
        
        myCell?.textLabel!.text = list[indexPath.row].Name
        
        return myCell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            self.ref.removeAllObservers()
            let deleteitem = list[indexPath.row]
            deleteitem.ref?.removeValue()
            list.remove(at: indexPath.row)
            self.GroceryTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
            self.ref.removeAllObservers()
            cell.accessoryType = .checkmark
            let completeitem = list[indexPath.row]
          //  list.remove(at: indexPath.row)
            completeitem.ref?.updateChildValues(["Completed": true])
          //  self.GroceryTable.reloadData()
        
    }
    

    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
