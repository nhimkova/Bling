//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var emergencyNewButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var explainTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        
        var buttonCenter = emergencyNewButton.center
        buttonCenter.y = CGFloat(150)
        buttonCenter.x = CGFloat(185)
        
        emergencyNewButton.center = buttonCenter
        
        buttonCenter.y = CGFloat(520)
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
    
    
    
    
} //End of class