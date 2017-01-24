//
//  AddViewController.swift
//  test
//
//  Created by yejing zhou on 2016/11/18.
//  Copyright © 2016年 LiMengyan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var BestbyDate: UITextField!
    @IBOutlet weak var CategoryField: UITextField!
    @IBOutlet weak var addbutton: UIButton!
 

//    var scanname: String = "default"
//    var scanquantity: String = "default"
    
    var NewinFood = Food(FoodName: "null",Quantity: "1", BestbyDate: "N/N",Category: "Others")
    var choice:String = "Others"
    var choices = [String](arrayLiteral: "Dairy/Egg","Fruits","Meats","Vegetables","Sauces","Others")
    let Category = UIPickerView()
    
    let Bestby = UIDatePicker()
    
    
    let Fruitsref = FIRDatabase.database().reference(withPath: "Grocery-Fruits")
    let Diaryref = FIRDatabase.database().reference(withPath: "Grocery-Dairy")
    let Meatsref = FIRDatabase.database().reference(withPath: "Grocery-Meats")
    let Vegetablesref = FIRDatabase.database().reference(withPath: "Grocery-Vegetables")
    let Saucesref = FIRDatabase.database().reference(withPath: "Grocery-Sauces")
    let Othersref = FIRDatabase.database().reference(withPath: "Grocery-Others")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Category.delegate = self
        Category.dataSource = self
        
        CategoryField.inputView = Category

        Bestby.datePickerMode = UIDatePickerMode.date
        BestbyDate.inputView = Bestby
        
        
        
        Name.delegate = self
        Quantity.delegate = self
        BestbyDate.delegate = self



       
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
    
    
    func textFieldDidEndEditing(_ userText: UITextField) {
        
        
        Name.resignFirstResponder()
        Quantity.resignFirstResponder()
        print("call did end")
        
    }
    
    
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        Name.resignFirstResponder()
        Quantity.resignFirstResponder()
        return true
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
    
    
//    @IBAction func DatePicker(_ sender: UITextField) {
//        
//        let Bestby = UIDatePicker()
//        Bestby.datePickerMode = UIDatePickerMode.date
//        sender.inputView = Bestby
//        Bestby.addTarget(self, action: Selector(("handleDatePicker:")), for: UIControlEvents.valueChanged)
//
//
//    }
    

    
    
    @IBAction func AddtoList(_ sender: Any) {
        
     //   NewinFood.append(Food(FoodName: Name.text!, Quantity: Quantity.text!, BestbyDate: BestbyDate.text!, Category: choice))
        
        NewinFood.FoodName = Name.text!
        NewinFood.Quantity = Quantity.text!
        NewinFood.BestbyDate = BestbyDate.text!
        NewinFood.Category = choice
        
      //  print("\(NewinFood)")
        
        if NewinFood.FoodName.isEmpty || NewinFood.Category.isEmpty || NewinFood.BestbyDate.isEmpty
            || NewinFood.Quantity.isEmpty{
            
            let alert = UIAlertController(title: "Caution!", message: "Please Enter All Info of Your Grocery", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil ))
            
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            if choice == "Fruits"{
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Fruitsref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Dairy/Egg"{
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Diaryref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Meats"{
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Meatsref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Vegetables"{
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Vegetablesref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else if choice == "Sauces" {
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Saucesref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }else {
                let groceryItem = GroceryItem(Name: self.NewinFood.FoodName, BestbyDate: self.NewinFood.BestbyDate, Quantity: self.NewinFood.Quantity)
                
                let groceryItemRef = self.Othersref.child(NewinFood.FoodName)
                
                groceryItemRef.setValue(groceryItem.toAnyObject())
            }
            
            let alert = UIAlertController(title: "Add!", message: "Successfully!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil ))
            
            //        let imageView = UIImageView(frame: CGRect(x: 50,y:50,width: 40,height: 40))
            //        imageView.image = UIImage(named: "checked.png")
            //
            //        alert.view.addSubview(imageView)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
