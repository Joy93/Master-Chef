//
//  ScanViewController.swift
//  test
//
//  Created by yejing zhou on 2016/11/18.
//  Copyright © 2016年 LiMengyan. All rights reserved.
//

import UIKit
import AVFoundation


class ScanViewcontroller: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    

    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var barCodeFrameView:UIView?
    
    var scanresults = [Food]()
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeQRCode]
    
    var name = String()
    var id: Int = 0
    var quantity:Int = 0
    var image =  UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            let videobound = self.view.bounds
            videoPreviewLayer?.frame = videobound
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            barCodeFrameView = UIView()
            
            if let barCodeFrameView = barCodeFrameView {
                barCodeFrameView.layer.borderColor = UIColor.magenta.cgColor
                barCodeFrameView.layer.borderWidth = 2
                view.addSubview(barCodeFrameView)
                view.bringSubview(toFront: barCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            barCodeFrameView?.frame = CGRect.zero
            
            let alertController = UIAlertController(title: "Oops!", message: "No valid barcode found in your product", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: {action in})
            alertController.addAction(okAction)
            self.present(alertController, animated:true, completion: nil)
            
            return
        }
        
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            //   let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            let barObject = metadataObj.bounds
            
            barCodeFrameView?.frame = barObject
            
            if metadataObj.stringValue != nil {
                
                let barcode = metadataObj.stringValue
                
                var upcCode = ""
                //print(barcode!)
                for index in (barcode?.characters.indices)! {
                    if (index != barcode?.startIndex){
                        upcCode.append((barcode?[index])!)
                    }
                }
                
                captureSession?.stopRunning()
    
                
                let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/products/upc/\(upcCode)"
                let session = URLSession.shared
                let url = NSURL(string: urlString)!
                //print("\(url)")
                let request = NSMutableURLRequest(url: url as URL)
                
                request.addValue("vLQQCs88ebmsh1A5fLiPdNWF0wBMp12iuMLjsnqnXzhyszYsnX", forHTTPHeaderField: "X-Mashape-Key")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                //print("\(request)")
                
                session.dataTask(with: request as URLRequest) {data, response,error -> Void in
                    
                    if let responseData = data
                    {
                        //print("response not nil")
                        do{
                            
                            let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                            
                            if let title = json["title"]
                            {
                                //print(title)
                                self.name = title as! String
                                
                                //assume all have images here
                                let images = json["images"] as! NSArray
                                
                                let imageURL = images[0] as! String
                                let temp = URL(string: imageURL)
                                let data = try? Data(contentsOf: temp!)
                                self.image = UIImage(data: data!)!
                                
                                
                                //self.id = json["id"] as! String
                                self.quantity = json["number_of_servings"] as! Int
                                
                                //print(self.name)
                                //self.messagelabel.text = self.name
                             //   self.performSegue(withIdentifier: "showDetail", sender: self)
                                DispatchQueue.main.async {
                                    
                                    self.performSegue(withIdentifier: "showDetail", sender: self)
                                }
                            } else {
                                print("barcode not in database")
                                //need OKAction
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Oops!", message: "No valid barcode found in your product", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "ok", style: .default, handler: {action in})
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated:true, completion: nil)
                                }
                                self.captureSession?.startRunning()
                            }
                            
                            
                        }catch{
                            print("Could not serialize")
                        }
                    }
                    //print("response nil")
                    //print(error)
                    
                    }.resume()
                
                
                
            }
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"
        {
            let backBtn = UIBarButtonItem()
            backBtn.title = ""
            navigationItem.backBarButtonItem = backBtn

            let vc = segue.destination as! ScanDetailViewController
            //let vc = segue.destination as! AddViewController
            print(self.name)
//            vc.scanname = self.name
//            vc.scanquantity = String(self.quantity)
            vc.foodname = self.name
            vc.foodquantity = self.quantity
            vc.foodposter = self.image
            print(vc.foodname)
                        
        }
    }
    

    
    
    
    
}









