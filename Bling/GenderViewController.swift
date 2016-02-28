//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var naButton: UIButton!
    
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var naLabel: UILabel!
   
    @IBOutlet weak var questionLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize Qredo Client
        QredoClient.initializeWithAppSecret(MyQredo.Constants.appSecret, userId: MyQredo.Constants.userID, userSecret: MyQredo.Constants.userSecret) { (client, error) -> Void in
            if error != nil {
                // handle error
                self.showMessage ("Authorize failed with error",
                    message: error.localizedDescription,
                    completionBlock: { () -> Void in
                        return })
                return
            }
            MyQredo.sharedInstance().client = client
        }

        
        
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
         //Set original places of buttons
        var buttonCenter = maleButton.center
        buttonCenter.y = CGFloat(170)
        buttonCenter.x = CGFloat(185)
        
        maleButton.center = buttonCenter
        femaleButton.center = buttonCenter
        naButton.center = buttonCenter
        
        // Set all buttons to be transparent
        maleButton.alpha = 0
        femaleButton.alpha = 0
        naButton.alpha = 0
        
        // Set all buttons to be round
        maleButton.layer.cornerRadius = 30
        maleButton.clipsToBounds = true
        
        femaleButton.layer.cornerRadius = 30
        femaleButton.clipsToBounds = true
        
        naButton.layer.cornerRadius = 30
        naButton.clipsToBounds = true
        
        //Set text label position
        var labelCenter = maleButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(100) //add the distance that the first button will go at animation + the distance between the label and the button
        maleLabel.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        femaleLabel.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        naLabel.center = labelCenter
        
        labelCenter.y += CGFloat(-425) //
        questionLabel.center = labelCenter
        
        // Set labels to be transparent
        maleLabel.alpha = 0
        femaleLabel.alpha = 0
        naLabel.alpha = 0

        
        
        
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.maleButton.center.y += 60
            self.maleButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.maleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: [], animations: {
            self.femaleButton.center.y += 180
            self.femaleButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.femaleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.6, delay: 0.4, options: [], animations: {
            
            self.naButton.center.y += 300
            self.naButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.naLabel.alpha = 1
        })
        
        
        
    }//End of viewDidAppear
    
    
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
                        self.performSegueWithIdentifier("goToAge", sender: self)
                    })
            })
            
        }
    }

    //Button interactions
    
    @IBAction func didPushMale(sender: AnyObject) {
        
        let infoKey = NSString(string: "Gender")
        let infoValue = NSString(string: "Male")
        
        putItemInVault(infoKey, infoValue: infoValue)
        
    }
    
    
    
    @IBAction func didPushFemale(sender: AnyObject) {
        
        let infoKey = NSString(string: "Gender")
        let infoValue = NSString(string: "Female")
        
        putItemInVault(infoKey, infoValue: infoValue)
        
    }
    
    

    @IBAction func didPushNoGender(sender: AnyObject) {
        
        let infoKey = NSString(string: "Gender")
        let infoValue = NSString(string: "Not Specified")
        
        putItemInVault(infoKey, infoValue: infoValue)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
} //End of class