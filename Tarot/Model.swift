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
    let majorArcanaCards:[String:MajorArcanaCard]
    var currentCard:MajorArcanaCard = MajorArcanaCard.Fool;
    
    // Populate the model with a set of Major Arcana Cards
    init()
    {
        majorArcanaCards = MajorArcanaCard.createDeck()
    }


    // Return the oracles response to the question posed by the user
    func respond()->String
    {
        // Returns a random integer within the range of indexes for the answers array
        let response: Int = Int(arc4random_uniform(UInt32(majorArcanaCards.count)))
        
        // Set the current card name based on the specified index
        currentCard = Array(majorArcanaCards.values)[response]
        return currentCard.interpretation
    }

}

