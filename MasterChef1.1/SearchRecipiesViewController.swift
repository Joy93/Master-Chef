//
//  SearchRecipiesViewController.swift
//  Master Chef
//
//  Created by LiMengyan on 12/2/16.
//  Copyright © 2016 LiMengyan. All rights reserved.
//

import UIKit

class SearchRecipiesViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var recipeCollection: UICollectionView!
    
    var recipeImages: [UIImage] = []
    var recipeNames: [String] = []
    var recipeID: [String] = []
    var search = String()
    //var request = NSMutableURLRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeCollection.delegate = self
        self.recipeCollection.dataSource = self

        InitializeSpinner()
        loadingSpinner()
        
        
        var images:[String] = []
        
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=false&ingredients=\(search)&limitLicense=false&number=20&ranking=1"
        
        let session = URLSession.shared
        let url = NSURL(string: urlString)!
        //print("\(url)")
        let request = NSMutableURLRequest(url: url as URL)
        
        request.addValue("vLQQCs88ebmsh1A5fLiPdNWF0wBMp12iuMLjsnqnXzhyszYsnX", forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        session.dataTask(with: request as URLRequest) { data, response,error -> Void in
            
            if let responseData = data{
                //print("response not nil")
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as! Array<Dictionary<String, Any>>
                    
                    //print(json)
                    if (json.count == 0) {
                        let alertController = UIAlertController(title: "Oops!", message: "No data found", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "ok", style: .default, handler: {action in})
                        alertController.addAction(okAction)
                        self.present(alertController, animated:true, completion: nil)
                        
                    }
                    
                    for result in json {
                        
                        let name = result["title"] as! String
                        print(name)
                        let id = String(describing: result["id"]!)
                        print("id:\(id)")
                        let imageURL = result["image"] as! String
                        
                        
                        self.recipeNames.append(name)
                        self.recipeID.append(id)
                        images.append(imageURL)
                        
                        
                    }
                    
                }catch{
                    print("Could not serialize")
                }
            }
            print("done")
            print("get json:\(self.recipeNames.count)")
            
            func cacheImages() {
                print("start cashe image")
                print("images numbers:\(images.count)")
                for item in images{
                    if let url = URL(string :item) {
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data){
                                self.recipeImages.append(image)
                            } else {
                                let temp = URL(string: "https://spoonacular.com/recipeImages/Grilled-Herb-Steaks-163864.jpg")
                                let data = try? Data(contentsOf: temp!)
                                let image = UIImage(data: data!)
                                self.recipeImages.append(image!)
                            }
                            print("image added")
                        } else {
                            let temp = URL(string: "https://spoonacular.com/recipeImages/Grilled-Herb-Steaks-163864.jpg")
                            let data = try? Data(contentsOf: temp!)
                            let image = UIImage(data: data!)
                            self.recipeImages.append(image!)
                            print("data not found")
                        
                        }
                    } else {
                        let temp = URL(string: "https://spoonacular.com/recipeImages/Grilled-Herb-Steaks-163864.jpg")
                        let data = try? Data(contentsOf: temp!)
                        let image = UIImage(data: data!)
                        self.recipeImages.append(image!)
                        print("url not found")
                    }

            
                }
                
            }
            
            
            DispatchQueue.global(qos: .userInitiated).async {
                cacheImages()
                print("image fine")
                DispatchQueue.main.async {
                    self.loadingEndSpinner()
                    self.recipeCollection.reloadData()
                }
            }
            
            }.resume()
        
        
        
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let wait = UIActivityIndicatorView(frame:CGRect(x:0,y:0,width: 50,height: 50))
    func InitializeSpinner() {
        wait.color = UIColor.black
        //wait.backgroundColor=UIColor.blueColor()
        wait.hidesWhenStopped = true
        
        wait.center = self.view.center
        self.view.addSubview(wait)
        
    }
    func loadingSpinner() {
        //wait.hidden = false
        wait.startAnimating()
    }
    func loadingEndSpinner() {
        //wait.hidden = true
        wait.stopAnimating()
    }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print ("in cell for item at row \(indexPath.row) and section \(indexPath.section) ")
        
        let fram = collectionView.frame
        let rect = CGRect(origin: CGPoint(x: fram.minX,y :fram.minY), size: CGSize(width: fram.width, height: 20))
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipe", for: indexPath as IndexPath) as! RecipiesCollectionViewCell
    
        cell.image?.image = self.recipeImages[indexPath.row]
        cell.name?.text = self.recipeNames[indexPath.row]
        
        cell.name.bounds = rect
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showSteps", sender: self)
        //loadingSpinner()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSteps"
        {
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            navigationItem.backBarButtonItem = backBtn

            
            let indexPaths = self.recipeCollection.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as IndexPath
            
            let vc = segue.destination as! StepsViewController
            
            vc.image = self.recipeImages[indexPath.row]
            vc.title = self.recipeNames[indexPath.row]
            vc.id = self.recipeID[indexPath.row]
            
            
            //let tempjson = getJSON("http://www.omdbapi.com/?i=\(id)&y=&plot=short&r=json")
            //print(tempjson)
            
            //            vc.year = "Released: " + self.movies[indexPath.row].year
            //            vc.rating = "Rating: " + tempjson["imdbRating"].stringValue
            //            vc.director = "Director: " + tempjson["Director"].stringValue
            //loadingEndSpinner()
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
