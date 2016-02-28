//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phone1TextField: UITextField!
    @IBOutlet weak var phone2TextField: UITextField!
    @IBOutlet weak var question3Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set original places of buttons
        var buttonCenter = submitButton.center
        buttonCenter.y = CGFloat(360)
        buttonCenter.x = CGFloat(185)
        
        submitButton.center = buttonCenter
        
        let textFieldCenterX = submitButton.center.x
        phone1TextField.center.x = textFieldCenterX
        phone2TextField.center.x = textFieldCenterX
        
        
        submitButton.alpha = 1
        
        //Set text label position
        var labelCenter = submitButton.center // we start at the position of the button

        
        labelCenter.y = CGFloat(85) //
        question3Label.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        phone1TextField.center = labelCenter

        labelCenter.y += CGFloat(67) //
        phone2TextField.center = labelCenter

        
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements

        
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        
        
        
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
                        self.performSegueWithIdentifier("goToLocation", sender: self)
                    })
            })
            
        }
    }
    
    //Button interaction
    
    @IBAction func didPushSubmitButton(sender: AnyObject) {
        
        let infoValue = NSString(string: phone2TextField.text!)
        let infoKey = NSString(string: "Contact")
        
        putItemInVault(infoKey, infoValue: infoValue)
        
        
    }
    
    
    
    
} //End of class