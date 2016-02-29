//
//  ViewController.swift
//  Tarot
//
//  Created by Rodney Cocker on 29/02/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Property referencing the label in the view
    @IBOutlet weak var lblAnswers: UILabel!
    
    // Property referencing the model for managing data and business logic
    var model = Model()
    
    // Respond to the user clicking a button by providing advice from the oracle
    @IBAction func askTheOracle(sender: UIButton)
    {
        lblAnswers.text = model.respond()
    }
    
    // Lifecycle method for performing tasks after the view has loaded
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Lifecycle method for clearing up memory resources
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
