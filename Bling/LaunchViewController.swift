//  Created by Quynh Tran and Saci Sebo on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    //Link UI elements here
    
    
   
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "timeToMoveOn", userInfo: nil, repeats: false)
        
    } //End of viewDidLoad
    
    
    override func viewWillAppear(animated: Bool) {
        //Initial settings of UI elements
        
        logoImageView.center.y = CGFloat(300)
        logoImageView.center.x = CGFloat(0)
        
        logoTextField.center.y = CGFloat(360)
        logoTextField.center.x = CGFloat(370)
        
        logoImageView.alpha = 0
        logoTextField.alpha = 0

        
    } //End of viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        //animations
        
        UIView.animateWithDuration(0.4, delay: 1, options: [], animations: {
            self.logoImageView.center.x += 185
            self.logoImageView.alpha = 1
            
            }, completion: { (success: Bool) in
                self.logoTextField.center.x = 185
                self.logoTextField.alpha = 1
        })
        
        
    }//End of viewDidAppear
    
    func timeToMoveOn() {
        self.performSegueWithIdentifier("goToNext", sender: self)
    }
    
    
} //End of class