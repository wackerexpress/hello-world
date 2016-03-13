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
    @IBOutlet weak var lblAnswers: UILabel!
    @IBOutlet weak var cardPlaceholder_HolderUIView: UIView!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var labelTransparentOverlay: UILabel!
    
    
    var model = Model()
    
    var showingBack = false
    var front:UIImageView!
    var back:UIImageView!
    var cardView: UIView!
    var direction: UIViewAnimationOptions =
    UIViewAnimationOptions.TransitionFlipFromLeft
    var gesturesRegistered: Bool = false
    
    // Property to support formatting a string
    var attributedString:NSMutableAttributedString!
    
    // Lifecycle method for performing tasks after the view has loaded
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Hide controls on back of card
        labelTransparentOverlay.hidden = true
        lblText.hidden = true
        lblAnswers.text = "Think of a question, then click the button"
        
        // Set background color of the card placeholder to the same as the outer view
        imgCard.backgroundColor = UIColorFromRGB(0x4AABF7)
        
        // Set the inital card image to the an image that represents the back of the card
        imgCard.image = UIImage(named: "MajorArcana.jpg")
        
        // This allows the user to specify how large or small they want the text
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "preferredContentSizeChanged:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
    }
    
    // Allows the text to change based on user preferences
    func preferredContentSizeChanged(notification: NSNotification)
    {
        lblText.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    // Respond to the user clicking a button by providing advice from the oracle
    @IBAction func askTheOracle(sender: UIButton)
    {
        // Retrieve a random message from the oracle
        lblAnswers?.text = model.respond()
        
        // Change the image in the UIImageView to the currently selected card
        imgCard.image = UIImage(named:model.currentCard.imageName)
        
        // Only register the swipe gestures after the button has been clicked
        // so that the user cannot swipe the card before first selecting one.
        registerGestures()
    }
    
    
    // Register gestures for swiping the card left and right
    private func registerGestures()
    {
        // Only register the gestures after the user has clicked on the 'Ask Oracle' button
        // Only register the gestures once
        if(!gesturesRegistered)
        {
            gesturesRegistered = true
            
            /* Set up flipping behaviour.  For the flipping behaviour to work
            * a subview must be added to the item to be flipped.  Here I used
            * an additional image view so I can show the currently selected card
            * on the back but it will be faded.  I hide both of these, so it doesn't
            * matter what you set it to.*/
            front = UIImageView(image: UIImage(named: "Fool.jpg"))
            back = UIImageView(image: UIImage(named: "Fool.jpg"))
            cardPlaceholder_HolderUIView.addSubview(back)
            back.hidden = true
            front.hidden = true
            
            // Add Swipe Gesture to the placeholder for the card
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
            let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
            swipeRight.direction = UISwipeGestureRecognizerDirection.Right
            
            cardPlaceholder_HolderUIView.addGestureRecognizer(swipeLeft)
            cardPlaceholder_HolderUIView.addGestureRecognizer(swipeRight)
        }
    }
    
    // Determine direction of swipe
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if (sender.direction == .Left)
    {
            direction = UIViewAnimationOptions.TransitionFlipFromRight
        }
        if (sender.direction == .Right)
        {
            direction = UIViewAnimationOptions.TransitionFlipFromLeft
        }
        showCard(direction)
    }
    
    // Setup card for display
    private func showCard(direction: UIViewAnimationOptions)
    {
        if (showingBack)
    {
            UIView.transitionFromView(front, toView: back, duration: 1, options: direction, completion: nil)
            showingBack = false
            
            // Change the image in the UIImageView to the currently selected card
            imgCard.image = UIImage(named:model.currentCard.imageName)
            
            imgCard.hidden = false
            lblText.hidden = true
            
            button.hidden = false
            labelTransparentOverlay.hidden = true
    }
        else
    {
            UIView.transitionFromView(back, toView: front, duration: 1, options: direction, completion: nil)
            showingBack = true
            
            imgCard.hidden = false
            
            labelTransparentOverlay.hidden = false
            
            button.hidden = true
            
            formatText()
            lblText.hidden = false
            
        }
    }
    
    func applyHighlightsToText()
    {
        // 1. Create a range that equals the length of the string that contains the text to be highlighted
        let range = NSMakeRange(0, self.attributedString.length)
        
        // 2. Match items surrounded by single quotation marks
        let regexStr = "(\\'\\w+(.\\s\\w+)*\\')"
        let regex = try! NSRegularExpression(pattern: regexStr, options: [])
        
        // 3. Create attributes to apply to the text
        let colourAttributes = [NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]
        
        // 4. iterate over each match, making the text red
        regex.enumerateMatchesInString(attributedString.string, options: [], range: range)
            {
            match, flags, stop in
            let matchRange = match!.rangeAtIndex(1)
            self.attributedString.addAttributes(colourAttributes, range: matchRange)
        }
    }
    
    func applyFormattingToText()
    {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        let attributes = [
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font,
        ]
        attributedString = NSMutableAttributedString(string: model.currentCard.getCardDescription(), attributes: attributes)
    }
    
    private func formatText()
    {
        applyFormattingToText()
        applyHighlightsToText()
        
        lblText.attributedText = attributedString
    }
    
    // Lifecycle method for clearing up memory resources
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Translate hex colour to UIColor
    private func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
        )
    }
    
}
