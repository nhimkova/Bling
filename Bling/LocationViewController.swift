//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    //Link UI elements here
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var question4Label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        var buttonCenter = locationButton.center
        buttonCenter.y = CGFloat(170)
        buttonCenter.x = CGFloat(185)
        
        locationButton.center = buttonCenter
        
        // Set all buttons to be transparent
        locationButton.alpha = 0
        question4Label.alpha = 1
        
        
        // Set all buttons to be round
        locationButton.layer.cornerRadius = 30
        locationButton.clipsToBounds = true
        
        
        //Set text label position
        var labelCenter = locationButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(100) //add the distance that the first button will go at animation + the distance between the label and the button
        
        locationLabel.center = labelCenter

        labelCenter.y += CGFloat(-185) //
        question4Label.center = labelCenter
        
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            self.locationButton.center.y += 180
            self.locationButton.alpha = 1
            
            }, completion: { (success: Bool) in
                
                self.locationLabel.alpha = 1
        })
        
        
    }//End of viewDidAppear
    
    
    
    
} //End of class