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

    var currentCard:MajorArcanaCard = MajorArcanaCard.Fool;
    
    var deckOfCards:DeckOfCards
    
    // Populate the model with a set of Major Arcana Cards
    init()
    {
                 deckOfCards = DeckOfCards()
    }


    // Returns the oracles response to the question posed by the user
    func respond()->String
    {
        // Returns a random integer within the range of indexes for the answers array
        let response: Int =
        Int(arc4random_uniform(UInt32(deckOfCards.deckOfCards.count)))
        
        // Set the current card name based on the specified index
        currentCard = Array(deckOfCards.deckOfCards)[response]
        
        return currentCard.interpretation

    }
    
    // The use of the 'inout' keyword enables us to treat this parameter as pass by reference
    func changeCardByReference(inout card:MajorArcanaCard)
    {
        card = MajorArcanaCard(number:17)!
    }
    
    // This is a regular method where the paramter is being treated as a local variable inside the method.
    func changeCardByValue(var card:MajorArcanaCard)
    {
        card = MajorArcanaCard(number:22)!
    }


}

