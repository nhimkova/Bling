//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    
    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var emergencyLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        var buttonCenter = chatButton.center
        buttonCenter.y = CGFloat(100)
        buttonCenter.x = CGFloat(185)
        
        chatButton.center = buttonCenter
        emergencyButton.center = buttonCenter
        faqButton.center = buttonCenter
        
        // Set all buttons to be transparent
        chatButton.alpha = 0
        emergencyButton.alpha = 0
        faqButton.alpha = 0
        
        // Set all buttons to be round
        chatButton.layer.cornerRadius = 30
        chatButton.clipsToBounds = true
        
        emergencyButton.layer.cornerRadius = 30
        emergencyButton.clipsToBounds = true
        
        faqButton.layer.cornerRadius = 30
        faqButton.clipsToBounds = true
        
        //Set text label position
        var labelCenter = chatButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(120) //add the distance that the first button will go at animation + the distance between the label and the button
        chatLabel.center = labelCenter
        
        labelCenter.y += CGFloat(140) //
        emergencyLabel.center = labelCenter
        
        labelCenter.y += CGFloat(140) //
        faqLabel.center = labelCenter
        
        
        // Set labels to be transparent
        chatLabel.alpha = 0
        emergencyLabel.alpha = 0
        faqLabel.alpha = 0

        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.chatButton.center.y += 80
            self.chatButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.chatLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: [], animations: {
            self.emergencyButton.center.y += 220
            self.emergencyButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.emergencyLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.6, delay: 0.4, options: [], animations: {
            
            self.faqButton.center.y += 360
            self.faqButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.faqLabel.alpha = 1
        })


    }//End of viewDidAppear
    
    
    
    
} //End of class