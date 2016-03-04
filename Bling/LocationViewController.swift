//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    //Link UI elements here
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var question4Label: UILabel!
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        var buttonCenter = locationButton.center
        buttonCenter.y = CGFloat(170)
        //buttonCenter.x = CGFloat(185)
        buttonCenter.x = UIScreen.mainScreen().bounds.width/2
        
        locationButton.center = buttonCenter
        
        // Set all buttons to be transparent
        locationButton.alpha = 0
        question4Label.alpha = 1
        
        
        // Set all buttons to be round
        locationButton.layer.cornerRadius = 30
        locationButton.clipsToBounds = true
        
        
        //Set text label position
        var labelCenter = locationButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(180) //add the distance that the first button will go at animation + the distance between the label and the button
        locationLabel.center = labelCenter

        labelCenter.y = CGFloat(85) //
        question4Label.center = labelCenter
        
        // Set labels to be transparent
        locationLabel.alpha = 0
       
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: {
            self.locationButton.center.y += 140
            self.locationButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.locationLabel.alpha = 1
        })
        
        
    }//End of viewDidAppear
    
    @IBAction func allowLocation(sender: AnyObject) {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.performSegueWithIdentifier("GoToMain", sender: self)

    }
    
    
    //Qredo Vault methods
    
    func showMessage(title: String, message: String, completionBlock: () -> Void) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK action"),
                style: UIAlertActionStyle.Default,
                handler: { (action) -> Void in
                    completionBlock()
            })
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    func putItemInVault(infoKey: NSString!, infoValue: NSString!) {
        
        if let vault = MyQredo.sharedInstance().client?.defaultVault() {
            let metadata = QredoVaultItemMetadata(
                summaryValues: [infoKey : infoValue])
            
            let vaultValue = "Test string".dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true)
            
            let vaultItem = QredoVaultItem(metadata: metadata, value: vaultValue)
            
            vault.putItem(vaultItem, completionHandler:
                { (newVaultItemMetadata, error)
                    -> Void in
                    if error != nil {
                        self.showMessage("Put failed with error",
                            message: error.localizedDescription,
                            completionBlock: { () -> Void in
                                return
                        })
                        return
                    }
                    // tell the user the item has been added
                    print("Item added to the vault")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("goToContact", sender: self)
                    })
            })
            
        }
    }
    
    
    
} //End of class