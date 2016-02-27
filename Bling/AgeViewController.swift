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
        buttonCenter.x = CGFloat(185)
        
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
        labelCenter.y += CGFloat(100) //add the distance that the first button will go at animation + the distance between the label and the button
        under17Label.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        under29Label.center = labelCenter
        
        labelCenter.y += CGFloat(120) //
        aboveLabel.center = labelCenter
        
        labelCenter.y += CGFloat(-425) //
        question2Label.center = labelCenter
        
        // Set labels to be transparent
        under17Label.alpha = 0
        under29Label.alpha = 0
        aboveLabel.alpha = 0
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.under17Button.center.y += 60
            self.under17Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.under17Label.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: [], animations: {
            self.under29Button.center.y += 180
            self.under29Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.under29Label.alpha = 1
        })
        
        UIView.animateWithDuration(0.6, delay: 0.4, options: [], animations: {
            
            self.from30Button.center.y += 300
            self.from30Button.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.aboveLabel.alpha = 1
        })

        
        
        
    }//End of viewDidAppear
    
    
    
    
} //End of class