//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//  Using Qredo XDK Framework

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var incomingMessage: UILabel!
    @IBOutlet weak var outgoingMessage: UILabel!
    
    
}

class ChatViewController: UIViewController,
    QredoRendezvousObserver,
    QredoConversationObserver,
    UITextFieldDelegate
    
{
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var client       : QredoClient?
    var rendezvous   : QredoRendezvous?
    var conversation : QredoConversation?
    
    var messages : [QredoConversationMessage] = []
    
    var receivedSentMessages : Bool = false
    var receivedIncomingMessages : Bool = false
    
    // SET THIS BEFORE RUNNING APP
    let isRendezvousCreator : Bool = false
    let chatId : String = "SaciNhimProba3"
    
    var watermarkAfterEnumeration : QredoConversationHighWatermark? = QredoConversationHighWatermarkOrigin
    
    override func viewDidLoad() {
        
        // replace appSecret with the Qredo supplied appSecret given to you when you registered
        // replace userID and userSecret with values to be used for testing
        // these credentials will be provided by the user, see the tutorial for more information
        // replace the bundle identifier in build settings with your own appID
        
        let appSecret = "215123b8dd"
        let userID =  "tutorialuser@test.com"
        let userSecret = "!%usertutorialPassword"
        
        subscribeKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
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
            
            if (self.isRendezvousCreator) {
                self.createRendezvous(self.chatId)
            } else {
                self.respondToRendezvous(self.chatId)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendMessagePushButton(sender: AnyObject) {
        sendMessage()
    }
    
    
    func sendMessage() {
        if let conversation = conversation {
            let messageText = self.messageTextField.text
            let message =  QredoConversationMessage(
                value: messageText!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true),
                summaryValues: ["time": NSDate(), "dataType":"com.qredo.plaintext"])
            self.messages.append(message)
            self.messageTextField.text = ""
            self.tableView.reloadData()
            postMessage(conversation, messageToSend: messageText!)
        } else {
            self.showMessage ("Message cannot be sent",
                message: "No rendezvous respond.",
                completionBlock: { () -> Void in
                    return })
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
                    print("message could not be sent")
                } else {
                    print("message sent")
                }
        })
    }
    
    func createRendezvous (tag: String)
    {
        self.client?.createAnonymousRendezvousWithTag(tag,
            completionHandler: {(createdRendezvous, error) ->Void in
                
                if error != nil {
                    NSLog("Rendezvous creation failed!");
                    return
                }
                
                // start listening for responses
                self.rendezvous = createdRendezvous;
                self.rendezvous!.addRendezvousObserver(self);
                print("rendezvous created")
                
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
                self.conversation!.addConversationObserver(self);
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
    
    func listConversationMessages()
    {
        self.conversation?.enumerateSentMessagesUsingBlock({ (message : QredoConversationMessage!, stop) in
            self.messages.append(message)
            }, since: QredoConversationHighWatermarkOrigin, completionHandler: { error in
                self.receivedSentMessages = true
                print("calling from enumerateSentMessagesUsingBlock")
                //self.startListeningIfReady()
        })
        
        self.conversation?.enumerateReceivedMessagesUsingBlock({ message, stop in
            self.messages.append(message)
            if message.highWatermark.isLaterThan(self.watermarkAfterEnumeration) {
                self.watermarkAfterEnumeration = message.highWatermark
            }
            }, since: QredoConversationHighWatermarkOrigin, completionHandler: { error in
                self.receivedIncomingMessages = true
                
                print ("calling from enumerateReceivedMessagesUsingBlock")
                
                //self.startListeningIfReady()
        })
        self.tableView.reloadData()
    }
    
    func startListeningIfReady() {
        if receivedIncomingMessages && receivedSentMessages {
            dispatch_async(dispatch_get_main_queue()) {
                self.conversation?.addConversationObserver(self)
                //self.resort()
            }
        }
    }
    
    //QredoRendezvous delegate
    func qredoRendezvous (rendezvous: QredoRendezvous!, didReceiveReponse conversation: QredoConversation!)
    {
        NSLog("Rendezvous responded to");
        
        self.showMessage ("Rendezvous responded to",
            message: rendezvous.metadata.tag,
            completionBlock: { () -> Void in
                
                // send a message back to the responder
                self.conversation = conversation;
                conversation.addConversationObserver(self);
                
                self.postMessage(conversation, messageToSend: "Hello! How can I help?");
                
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
        
        dispatch_async(dispatch_get_main_queue(), {
            self.messages.append(message)
            self.tableView.reloadData()
        })
    }
    
    //Keyboard methods
    
    func subscribeKeyboardNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil);
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.height
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.frame.origin.y -= keyboardHeight!
        })
    }
    
    func keyboardDidShow(notification: NSNotification) {
        self.scrollToBottomMessage()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.frame.origin.y = 0
        })
    }
    
    func scrollToBottomMessage() {
        if self.messages.count == 0 {
            return
        }
        let bottomMessageIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1,
            inSection: 0)
        self.tableView.scrollToRowAtIndexPath(bottomMessageIndex, atScrollPosition: .Bottom,
            animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage()
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

// MARK: UITableView Delegate
extension ChatViewController: UITableViewDelegate {
    
    // Return number of rows in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // Create table view rows
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            
            let message = self.messages[indexPath.row]
            
            let messageText = NSString(data: message.value, encoding: NSUTF8StringEncoding) as String!
            
            cell.selectionStyle = .None
            
            //set color and message
            let isIncoming = message.incoming
            if (isIncoming) {
                cell.incomingMessage.text = messageText
                cell.outgoingMessage.text = ""
                cell.incomingMessage.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                
            } else {
                cell.outgoingMessage.text = messageText
                cell.incomingMessage.text = ""
                cell.outgoingMessage.textColor = UIColor(red: 53/255, green: 235/255, blue: 244/255, alpha: 1)
            }
            
            return cell
    }
}

// MARK: UITableViewDataSource Delegate
extension ChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

