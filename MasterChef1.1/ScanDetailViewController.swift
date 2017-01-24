//
//  ScanDetailViewController.swift
//  test
//
//  Created by yejing zhou on 2016/12/1.
//  Copyright © 2016年 LiMengyan. All rights reserved.
//

import UIKit
import Firebase

class ScanDetailViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var Poster: UIImageView!
    //@IBOutlet weak var sname: UITextField!
    
    @IBOutlet weak var squantity: UITextField!
    
    @IBOutlet weak var sname: UILabel!
    //@IBOutlet weak var squantity: UILabel!
    
    
    @IBOutlet weak var BestbyDate: UITextField!
    @IBOutlet weak var CategoryField: UITextField!
    
    var foodposter = UIImage()
    var foodname = String()
    var foodquantity: Int = 0
    let Category = UIPickerView()
    let Bestby = UIDatePicker()
    var choices = [String](arrayLiteral: "Dairy/Egg","Fruits","Meats","Vegetables","Sauces","Others")
    var choice:String = "Others"
    var scanfood = Food(FoodName: "null",Quantity: "1", BestbyDate: "N/N",Category: "Others")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Poster.image = self.foodposter
        self.sname.text = self.foodname
        self.squantity.text = String(self.foodquantity)
        CategoryField.inputView = Category
        BestbyDate.inputView = Bestby
        Bestby.datePickerMode = UIDatePickerMode.date
        
        //sname.delegate = self
        squantity.delegate = self
        Category.delegate = self
        Category.dataSource = self
        BestbyDate.delegate = self
        
        
        
        

        
        // Do any additional setup after loading the vie w.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        Bestby.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        //    handleDatePicker(sender: Bestby)
        //        print("\(Bestby.date)")
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        BestbyDate.text = dateFormatter.string(from: sender.date)
        BestbyDate.resignFirstResponder()
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        CategoryField.text = choices[row]
        choice = choices[row]
        CategoryField.resignFirstResponder()
        
    }

    func textFieldDidEndEditing(_ userText: UITextField) {
        
        
        sname.resignFirstResponder()
        squantity.resignFirstResponder()
        print("call did end")
        
    }
    
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        sname.resignFirstResponder()
        squantity.resignFirstResponder()
        return true
    }    

    @IBAction func scantolist(_ sender: Any) {
        scanfood.FoodName = sname.text!
        scanfood.Quantity = squantity.text!
        scanfood.BestbyDate = BestbyDate.text!
        scanfood.Category = choice
        
        if scanfood.BestbyDate.isEmpty || scanfood.Category.isEmpty || scanfood.FoodName.isEmpty || scanfood.Quantity.isEmpty{
            
            let alert = UIAlertController(title: "Caution!", message: "Please Enter All Info of Your Grocery", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil ))
            
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            if choice == "Fruits"{
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Fruits").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
                
            }else if choice == "Dairy/Egg"{
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Dairy").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Meats"{
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Meats").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Vegetables"{
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Vegetables").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Sauces"{
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Sauces").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else {
                let groceryItem = GroceryItem(Name: self.scanfood.FoodName, BestbyDate: self.scanfood.BestbyDate, Quantity: self.scanfood.Quantity)
                
                let groceryItemRef = FIRDatabase.database().reference(withPath: "Grocery-Others").child(scanfood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
                
            }
            
            let alert = UIAlertController(title: "Added!", message: "Successfully!", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "Main Page", style: .default, handler: { [weak alert] (_) in
                
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue Scan", style: .default, handler: { [weak alert] (_) in
                
                
                self.navigationController?.popViewController(animated: true)
                
                
            }))
            
            
            self.present(alert, animated: true, completion: nil)

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
