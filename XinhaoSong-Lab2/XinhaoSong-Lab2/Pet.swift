//
//  Pet.swift
//  XinhaoSong-Lab2
//
//  Created by xinhao.song on 2021/9/17.
//

import Foundation
import UIKit

class Pet {
    
    var genre:PetGenre
    var color:UIColor
    
    var happiness: Float
    var foodLevel: Float
    
    var playedTimes: Int
    var fedTimes: Int
    
    let maxValue:Float = 100.0
    
    init(genre: PetGenre, color: UIColor) {
        happiness = 0
        foodLevel = 0
        playedTimes = 0
        fedTimes = 0
        self.genre = genre
        self.color = color
    }
    
    func play(){
        happiness += 10
        foodLevel -= 20
        playedTimes += 1
        if(foodLevel < 0){
            foodLevel += 20
            happiness -= 10
            playedTimes -= 1
        }
        if(happiness > maxValue){
            happiness = maxValue
        }
    }
    
    func feed(){
        foodLevel += 10
        if(foodLevel > maxValue){
            foodLevel = maxValue
            fedTimes -= 1
        }
        fedTimes += 1
    }
}

enum PetGenre {
    case dog
    case cat
    case fish
    case bunny
    case bird
    
    var description : String{
        switch self {
        case .dog:
            return "dog"
        case .bird:
            return "bird"
        case .bunny:
            return "bunny"
        case .fish:
            return "fish"
        case .cat:
            return "cat"
        }
    }
}
