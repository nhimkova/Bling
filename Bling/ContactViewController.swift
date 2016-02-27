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
    
    
    
    
} //End of class