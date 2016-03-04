//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var under17Button: UIButton!
    @IBOutlet weak var under29Button: UIButton!
    @IBOutlet weak var from30Button: UIButton!
    
    @IBOutlet weak var under17Label: UILabel!
    @IBOutlet weak var under29Label: UILabel!
    @IBOutlet weak var aboveLabel: UILabel!
   
    @IBOutlet weak var question2Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        
        //Set original places of buttons
        var buttonCenter = under17Button.center
        buttonCenter.y = CGFloat(170)
        //buttonCenter.x = CGFloat(185)
        buttonCenter.x = UIScreen.mainScreen().bounds.width/2
        
        under17Button.center = buttonCenter
        under29Button.center = buttonCenter
        from30Button.center = buttonCenter
        
        // Set all buttons to be transparent
        under17Button.alpha = 0
        under29Button.alpha = 0
        from30Button.alpha = 0
        
        // Set all buttons to be round
        under17Button.layer.cornerRadius = 30
        under17Button.clipsToBounds = true
        
        under29Button.layer.cornerRadius = 30
        under29Button.clipsToBounds = true
        
        from30Button.layer.cornerRadius = 30
        from30Button.clipsToBounds = true
        
        //Set text label position
        var labelCenter = under17Button.center // we start at the position of the buttons
        labelCenter.y += CGFloat(70) //add the distance that the first button will go at animation + the distance between the label and the button
        under17Label.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        under29Label.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        aboveLabel.center = labelCenter
        
        labelCenter.y = CGFloat(85) //
        question2Label.center = labelCenter
        
        // Set labels to be transparent
        under17Label.alpha = 0
        under29Label.alpha = 0
        aboveLabel.alpha = 0
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.under17Button.center.y += 30
            self.under17Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.under17Label.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: [], animations: {
            self.under29Button.center.y += 150
            self.under29Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.under29Label.alpha = 1
        })
        
        UIView.animateWithDuration(0.6, delay: 0.4, options: [], animations: {
            
            self.from30Button.center.y += 270
            self.from30Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.aboveLabel.alpha = 1
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
                        self.performSegueWithIdentifier("goToContact", sender: self)
                    })
            })
            
        }
    }

    //Button interaction
    
    
    @IBAction func didPush17(sender: AnyObject) {
        
        let infoKey = NSString(string: "Age")
        let infoValue = NSString(string: "Under 17")
        
        putItemInVault(infoKey, infoValue: infoValue)

        
    }
    
    
    @IBAction func didPush29(sender: AnyObject) {
        
        let infoKey = NSString(string: "Age")
        let infoValue = NSString(string: "Between 17 and 29")
        
        putItemInVault(infoKey, infoValue: infoValue)
        
    }
 
    
    @IBAction func didPushAbove(sender: AnyObject) {
        
        let infoKey = NSString(string: "Age")
        let infoValue = NSString(string: "Above 29")
        
        putItemInVault(infoKey, infoValue: infoValue)
        
        
    }
    
    
    
    
    
    

    
    
} //End of class