//
//  ViewController.swift
//  RendezvousResponder
//
//

import UIKit

class ChatViewController: UIViewController,
    QredoConversationObserver
    
{
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    
    
    var client       : QredoClient?
    var rendezvous   : QredoRendezvous?
    var conversation : QredoConversation?
    
    override func viewDidLoad() {
        
        // replace appSecret with the Qredo supplied appSecret given to you when you registered
        // replace userID and userSecret with values to be used for testing
        // these credentials will be provided by the user, see the tutorial for more information
        // replace the bundle identifier in build settings with your own appID
        
        let appSecret = "215123b8dd"
        let userID =  "tutorialuser@test.com"
        let userSecret = "!%usertutorialPassword"
        
        
        QredoClient.initializeWithAppSecret(appSecret, userId: userID, userSecret: userSecret) { (client, error) -> Void in
            if error != nil {
                // handle error
                self.showMessage ("Authorize failed with error",
                    message: error.localizedDescription,
                    completionBlock: { () -> Void in
                        return })
                return
            }
            self.client = client
            self.requestRendezvousTag();
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        let message = self.messageTextField.text
        postMessage(conversation!, messageToSend: message!)
        
    }
    
    
    
    
    func qredoConversation(conversation: QredoConversation!, didReceiveNewMessage message: QredoConversationMessage!) {
        
        // show the message that we received from rendezvous responder
        let messageString = NSString(data: message.value, encoding: NSUTF8StringEncoding)
        self.showMessage("Message received", message: messageString as! String,                        completionBlock: { () -> Void in
            
            // send a message in response
            self.postMessage(conversation, messageToSend: "Is it me you're looking for ?")
        })
        
    }
    
    func requestRendezvousTag()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: "Rendezvous responder", message: "Respond to a Rendezvous with the tag:", preferredStyle: .Alert)
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {action in
            }));
            
            
            alert.addAction(UIAlertAction(title: "Respond", style: UIAlertActionStyle.Default, handler: {action in
                let textfield = alert.textFields![0]
                
                let tag = textfield.text
                
                self.respondToRendezvous(tag!);
            }));
            
            alert.addTextFieldWithConfigurationHandler { textfield -> Void in
                textfield.placeholder = "Enter Rendezvous tag"
            }
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        })
    }
    
    func postMessage(conversation: QredoConversation, messageToSend message: NSString)
    {
        // post a message in this conversation
        let currentDateTime: NSDate = NSDate()
        
        let messageValue = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let conversationMessage = QredoConversationMessage(value: messageValue, summaryValues: ["title" : "Responder first message", "date" : currentDateTime])
        
        conversation.publishMessage(conversationMessage, completionHandler:
            {(highwatermark, error) -> Void in
        })
        
        
    }
    
    func respondToRendezvous(tag: String)
    {
        
        self.client?.respondWithTag(tag, completionHandler:
            {(conversation, error) -> Void in
                if (error != nil)
                {
                    NSLog("Responding to Rendezvous failed with error");
                    return;
                }
                
                self.conversation = conversation;
                NSLog("Responding to Rendezvous successful");
                conversation.addConversationObserver(self);
                
        })
        
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
}

