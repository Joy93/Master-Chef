//
//  StepsViewController.swift
//  MasterChef1.1
//
//  Created by LiMengyan on 12/6/16.
//  Copyright © 2016 yejing zhou. All rights reserved.
//

import UIKit
import CoreLocation
import Social

class StepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var stepTable: UITableView!
    
    let locationManager = CLLocationManager()
    let imagePicker = UIImagePickerController()
    
    var image = UIImage()
    var id = String()
    var instructions:[String] = []
   
    
    var showimage = UIImage()
    var getimage = UIImage()
    
    //var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        self.dishImage.image = image
        
        self.imagePicker.delegate = self

        
        
        self.stepTable.dataSource = self
        self.stepTable.delegate = self
        
        print(id)
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(id)/analyzedInstructions"
        
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
                    
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    
                    if json.count == 0 {
                        let alertController = UIAlertController(title: "No details found", message: "No further instructions are given", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "ok", style: .default, handler: {action in})
                        alertController.addAction(okAction)
                        self.present(alertController, animated:true, completion: nil)
                    } else {
                        let temp = json[0] as! [String: Any]
                        let steps = temp["steps"] as! Array<Dictionary<String, Any>>

                    
                    
                        for result in steps {
                        
                            let step = result["step"] as! String
                            self.instructions.append(step)
                        
                        }
                    }
                    
                }catch{
                    print("Could not serialize")
                }
            }
            
            
            
            
            
            DispatchQueue.main.async {
                    self.stepTable.reloadData()
            }
            
            
        }.resume()

        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "step")! as UITableViewCell
        
        
        //let myCell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        myCell.textLabel?.font = UIFont(name: "Avenir",size: 17)
        
        myCell.textLabel!.text = instructions[indexPath.row]
        
        myCell.textLabel?.numberOfLines = 0
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    var latitude = ""
    var longitude = ""
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let someLocation = locations[0]
        //print("A single location is \(someLocation)")
        latitude = "\(someLocation.coordinate.latitude)"
        longitude = "\(someLocation.coordinate.longitude)"
       
        
    }
    
    
    @IBAction func SharetoFB(_ sender: Any) {
     //   self.performSegue(withIdentifier: "share", sender: self)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
            
        }

        
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        getimage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        showimage = getimage
        //        if getimage == (info[UIImagePickerControllerOriginalImage] as? UIImage)!{
        //            showimage = getimage
        //        }
        
        picker.dismiss(animated: true, completion: nil)
        
        self.post(toService: SLServiceTypeFacebook)
        
        
    }
    
    func post(toService service: String) {
        if(SLComposeViewController.isAvailable(forServiceType: service)) {
            let socialController = SLComposeViewController(forServiceType: service)
            socialController?.setInitialText("#\(self.title!)")
            socialController?.add(showimage)
            //            socialController.addURL(someNSURLInstance)
            self.present(socialController!, animated: true, completion: nil)
        }
    }
    
    
    

    @IBAction func toMap(_ sender: Any) {
        
        if let url = NSURL(string: "http://maps.apple.com/?q=restaurant&sll="+latitude+","+longitude+"&z=10&t=s") {
            UIApplication.shared.openURL(url as URL)
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
