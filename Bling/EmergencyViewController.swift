//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController, QredoConversationObserver {
    
    //Link UI elements here
    
    @IBOutlet weak var emergencyNewButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var explainTextView: UITextView!
    
    var myGender: String?
    var myAge: String?
    var myContact: String?
    
    let genderKey = NSString(string: "Gender")
    let ageKey = NSString(string: "Age")
    let contactKey = NSString(string: "Contact")
    
    var rendezvous   : QredoRendezvous?
    var conversation : QredoConversation?
    var watermarkAfterEnumeration : QredoConversationHighWatermark? = QredoConversationHighWatermarkOrigin
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This tag can be replaced by a general helpline emergency tag
        respondToRendezvous("index")
        
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        
        var buttonCenter = emergencyNewButton.center
        buttonCenter.y = CGFloat(130)
        //buttonCenter.x = CGFloat(185)
        buttonCenter.x = UIScreen.mainScreen().bounds.width/2
        
        emergencyNewButton.center = buttonCenter
        
        buttonCenter.y = CGFloat(470)
        agreeButton.center = buttonCenter
        
        // Set all buttons to be transparent
        emergencyNewButton.alpha = 0
        explainTextView.alpha = 0.8
        agreeButton.alpha = 1
        
        // Set all buttons to be round
        emergencyNewButton.layer.cornerRadius = 30
        emergencyNewButton.clipsToBounds = true
        
        agreeButton.layer.cornerRadius = 26
        
        //Set text label position
        var labelCenter = emergencyNewButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(200) //add the distance that the first button will go at animation + the distance between the label and the button
        
        explainTextView.center = labelCenter
        
        labelCenter.y += CGFloat(00) //
        explainTextView.center = labelCenter

        
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.emergencyNewButton.center.y += 60
            self.emergencyNewButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.explainTextView.alpha = 1
        })


    }//End of viewDidAppear
    
    func sendEmergencyMessage() {
        
        //Find personal data in Vault
        searchForVaultItemByName(self.genderKey)
        
        searchForVaultItemByName(self.ageKey)
        
        searchForVaultItemByName(self.contactKey)
        
        //create message
        var textMessage = "Please send help. Personal info: "
        if let age = self.myAge {
            textMessage += age + ", "
        }
        if let gender = self.myGender {
            textMessage += gender + ", "
        }
        if let contact = self.myContact {
            textMessage += contact
        }
        
        if let conversation = self.conversation {
            postMessage(conversation, messageToSend: textMessage)
        }
    }
    
    func searchForVaultItemByName(infoKey: NSString!) {
        
        let searchPredicate =
        NSPredicate (format: "key=='\(infoKey)'")
        
        if let vault = MyQredo.sharedInstance().client?.defaultVault() {
            
            vault.enumerateIndexUsingPredicate(searchPredicate, withBlock: {(itemMetadata, stop) -> Void in
                
                let itemResult = itemMetadata.summaryValues[infoKey] as! String;
                
                if (infoKey == self.genderKey) {
                    self.myGender = itemResult
                } else if (infoKey == self.ageKey) {
                    self.myAge = itemResult
                } else if (infoKey == self.contactKey) {
                    self.myContact = itemResult
                }
                
                NSLog("Item found in vault: " + itemResult)
                
                }, completionHandler: { (error) -> Void in
                    
                    if (error != nil) {
                        if (infoKey == self.genderKey) {
                            self.myGender = ""
                        } else if (infoKey == self.ageKey) {
                            self.myAge = ""
                        } else if (infoKey == self.contactKey) {
                            self.myContact = ""
                        }
                        
                    }

            })
        }
    }
    
    func postMessage(conversation: QredoConversation, messageToSend message: NSString)
    {
        // post a message in this conversation
        let currentDateTime: NSDate = NSDate()
        
        let messageValue = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let conversationMessage = QredoConversationMessage(value: messageValue, summaryValues: ["title" : "Responder first message", "date" : currentDateTime])
        
        conversation.publishMessage(conversationMessage, completionHandler:
            {(highwatermark, error) -> Void in
                
                if (error != nil) {
                    self.showMessage ("Message cannot be sent",
                        message: "Please try later.",
                        completionBlock: { () -> Void in
                            return })
                } else {
                    print(message)
                    self.showMessage ("Message sent",
                        message: "We will get in touch with you soon.",
                        completionBlock: { () -> Void in
                            return })
                }
        })
    }
    
    func respondToRendezvous(tag: String)
    {
        MyQredo.sharedInstance().client?.respondWithTag(tag, completionHandler:
            {(conversation, error) -> Void in
                if (error != nil)
                {
                    NSLog("Responding to Rendezvous failed with error");
                    return;
                }
                
                self.conversation = conversation;
                NSLog("Responding to Rendezvous successful");
                self.conversation!.addConversationObserver(self);
        })
    }
    
    // MARK: QredoConversationDelegate
    
    func qredoConversation(conversation: QredoConversation!, didReceiveNewMessage message: QredoConversationMessage!) {
        if let lastWatermark = watermarkAfterEnumeration {
            if !message.highWatermark.isLaterThan(lastWatermark) {
                // we already have this message from enumeration
                return;
            }
        }
    }

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
    
    @IBAction func didPushSendEmergency(sender: AnyObject) {
        
        sendEmergencyMessage()
        
    }
    

    
} //End of class