//
//  ViewController.swift
//  test
//
//  Created by LiMengyan on 11/15/16.
//  Copyright © 2016 LiMengyan. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController,
UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate {

    //@IBOutlet weak var mySearch: UISearchBar!
    
    @IBOutlet weak var category: UICollectionView!
    
    
    
    let categoryimages: [UIImage] = [
        UIImage(named: "dairy.jpg")!, UIImage(named: "fruits.jpg")!, UIImage(named: "vegetable.jpg")!, UIImage(named: "meat.jpg")!, UIImage(named: "sauce.jpg")!,UIImage(named: "others.jpg")!
    ]
    
    let categories = ["Dairy/Eggs","Fruits","Vegetables", "Meats", "Sauces","Others"]
    var selectedCell = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.category.dataSource = self
        self.category.delegate = self
      
        self.navigationItem.title = "Master Chef"
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print ("in cell for item at row \(indexPath.row) and section \(indexPath.section) ")
        
        let fram = collectionView.frame
        let rect = CGRect(origin: CGPoint(x: fram.minX,y :fram.minY), size: CGSize(width: fram.width, height: 20))
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        
        cell.backgroundColor = UIColor.green
        
        cell.image?.image = self.categoryimages[indexPath.row]
        //cell.title?.text = self.movies[indexPath.row]
        cell.name?.text = self.categories[indexPath.row]
      
        cell.name.bounds = rect

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCell = categories[indexPath.row]
        
        self.performSegue(withIdentifier: "showCategory", sender: self)
        
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory"
        {
            let vc = segue.destination as! CategoryViewController
            
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            navigationItem.backBarButtonItem = backBtn

            
            if selectedCell == "Fruits"{
             
                vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Fruits")
           //     vc.categorykey = "Grocery-Fruits"
                
            }else if selectedCell == "Meats" {
             
                vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Meats")
             //   vc.categorykey = "Grocery-Meats"
            
            }else if selectedCell == "Vegetables"{
           
                vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Vegetables")
             //   vc.categorykey = "Grocery-Vegetables"
            
            }else if selectedCell == "Sauces" {
             
                 vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Sauces")
              //   vc.categorykey = "Grocery-Sauces"
                
            }else if selectedCell == "Dairy/Eggs" {
               
                vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Dairy")
            //    vc.categorykey = "Grocery-Dairy"
                
            }else if selectedCell == "Others" {
             
                vc.showRef = FIRDatabase.database().reference(withPath: "Grocery-Others")
            //    vc.categorykey = "Grocery-Others"
                
            }
        }
    }




}

