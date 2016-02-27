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
        buttonCenter.y = CGFloat(330)
        buttonCenter.x = CGFloat(185)
        
        submitButton.center = buttonCenter
        submitButton.alpha = 1
        
        //Set text label position
        var labelCenter = submitButton.center // we start at the position of the buttons
        labelCenter.y += CGFloat(100) //add the distance that the first button will go at animation + the distance between the label and the button

        
        labelCenter.y += CGFloat(-375) //
        question3Label.center = labelCenter

        
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements

        
        
        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        
        
        
    }//End of viewDidAppear
    
    
    
    
} //End of class