//
//  Model.swift
//  Tarot
//
//  Created by Rodney Cocker on 29/02/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation

class Model
{
    var answers = ["Go forth with faith",
        "Magic is on your side",
        "Plant the seed and it will grow"]
    
    init()
    {
        // Adds an element to the end of the array
        answers.append("Look to the stars to find your answer")
        
        // Inserts an element at a specified index of the array
        // all other elements are moved forward one position
        answers.insert("You cannot do this alone", atIndex: 3)
        
        // Removes an element at a specified index of the array
        // all other elements are moved backward one position
        answers.removeAtIndex(4)
        
        // Removes the last element in the array
        // answers.removeLast()
    }
    
    // Returns the oracles response to the question posed by the user
    func respond()->String
    {
        // Returns a random integer within the range of indexes for the answers array
        let response = Int(arc4random_uniform(UInt32(answers.count)))
       
        // Gets the relevant message from the array at the specified random index
        return answers[response]
    }
}
