//
//  CookViewController.swift
//  Master Chef
//
//  Created by LiMengyan on 12/1/16.
//  Copyright © 2016 LiMengyan. All rights reserved.
//

import UIKit
import Firebase

class CookViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

   
    var allpost = [GroceryItem]()
    
    let refkey = ["Grocery-Fruits","Grocery-Meats","Grocery-Vegetables","Grocery-Dairy","Grocery-Others","Grocery-Sauces"]
    
    @IBOutlet weak var mySearch: UISearchBar!
    
    @IBOutlet weak var RecommendTable: UITableView!
    
  //  var ingredients = ["apples", "milk"]
    
    var search = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecommendTable.delegate = self
        RecommendTable.dataSource = self
        mySearch.delegate = self
        
        RecommendTable.allowsMultipleSelectionDuringEditing = true
        for i in 0...5{
            FIRDatabase.database().reference(withPath: refkey[i]).observe(.value, with: { snapshot in
                
                for item in snapshot.children {
                    let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                    self.allpost.append(groceryItem)
                }
                self.RecommendTable.reloadData()
            })
        }

        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allpost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyProtoCell") as! MyGroceryCell
        
        let groceryItem = allpost[indexPath.row]
        
        myCell.showName.text = groceryItem.Name
        myCell.showQuantity.text = "Quantity:" + groceryItem.Quantity
        myCell.showBestbyDate.text = "Best by Date:" + groceryItem.BestbyDate
        
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let myCell = tableView.cellForRow(at: indexPath) as! MyGroceryCell
            print(myCell.showName.text!)
            //myCell.accessoryType = .checkmark
            
            //let myCell = tableView.cellForRow(at: indexPath) as! MyGroceryCell
            
            mySearch.text?.append("\(myCell.showName.text!)"+" ")
            
            //     mySearch.text = inputs
        }
        
    }


//##################  Delete Cell##################
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            myArray.remove(at: indexPath.row)
//            myTable.reloadData()
//            
//        }
//    }
    
    
    
    //Search staff
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mySearch.resignFirstResponder()
        self.search = ""
        
        let input = mySearch.text!
        
        
        for s in input.lowercased().characters {
            if (s >= "a" && s <= "z")  {
                self.search += "\(s)"
            } else {
                self.search += "%2C"
            }
        }
        print(search)
        
//########   need to modify inputs to the following format
//        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=false&ingredients=apples%2Cflour%2Csugar&limitLicense=false&number=20&ranking=1"
        

        self.performSegue(withIdentifier: "showRecipies", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipies"
        {
            

            let vc = segue.destination as! SearchRecipiesViewController
            vc.search = self.search
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            navigationItem.backBarButtonItem = backBtn
        }
    }
}
