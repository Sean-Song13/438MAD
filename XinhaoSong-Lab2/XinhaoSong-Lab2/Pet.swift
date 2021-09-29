//
//  Pet.swift
//  XinhaoSong-Lab2
//
//  Created by xinhao.song on 2021/9/17.
//

import Foundation
import UIKit
import AudioToolbox
class Pet {
    
    var genre:PetGenre
    var color:UIColor
    
    var happiness: Float
    var foodLevel: Float
    
    var playedTimes: Int
    var fedTimes: Int
    
    let maxValue:Float = 10.0
    
    init(genre: PetGenre, color: UIColor) {
        happiness = 0
        foodLevel = 0
        playedTimes = 0
        fedTimes = 0
        self.genre = genre
        self.color = color
    }
    
    func play(){
        happiness += 1
        foodLevel -= 1
        playedTimes += 1
        if(foodLevel < 0){
            foodLevel += 1
            happiness -= 1
            playedTimes -= 1
        }else{
            MakeSound(type: "play")
        }
        if(happiness > maxValue){
            happiness = maxValue
        }
    }
    
    func feed(){
        foodLevel += 1
        if(foodLevel > maxValue){
            foodLevel = maxValue
            fedTimes -= 1
        }
        MakeSound(type: "feed")
        fedTimes += 1
    }
    
    func MakeSound(type:String){
        var soundID:SystemSoundID = 0
        var path = Bundle.main.path(forResource: self.genre.description+type, ofType: "wav")
        if(path == nil){
            path = Bundle.main.path(forResource: self.genre.description+type, ofType: "mp3")
        }
        guard path != nil else { return }
        let baseURL = NSURL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
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
