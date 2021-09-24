//
//  ViewController.swift
//  XinhaoSong-Lab2
//
//  Created by xinhao.song on 2021/9/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var happinessView: DisplayView!
    @IBOutlet weak var foodLevelView: DisplayView!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var playedTimes: UILabel!
    @IBOutlet weak var fedTimes: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    var pets:[PetGenre:Pet] = [:]
    
    var currentPet:Pet?{
        didSet{
            background.backgroundColor = currentPet!.color
            happinessView.color = currentPet!.color
            foodLevelView.color = currentPet!.color
            UpdateViewValue(needAnimation: false)
        }
    }
    
//    TODO:
//    The display bars animate when the pet is played or fed, but jump immediately to the correct values when switching between pets.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentPet = Pet(genre: .dog, color: UIColor.init(named: PetGenre.dog.description)!)
        pets[currentPet!.genre] = currentPet
    }
    
    @IBAction func OnPlayPressed(_ sender: Any) {
        currentPet?.play()
        UpdateViewValue()
    }
    
    @IBAction func OnFeedPressed(_ sender: Any) {
        currentPet?.feed()
        UpdateViewValue()
    }
    
    func UpdateViewValue(needAnimation : Bool = true){
        guard (currentPet != nil) else { return }
        let happinessVal = CGFloat(currentPet!.happiness/currentPet!.maxValue)
        let foodLevelVal = CGFloat(currentPet!.foodLevel/currentPet!.maxValue)
        if needAnimation{
            happinessView.animateValue(to: happinessVal)
            foodLevelView.animateValue(to: foodLevelVal)
        }else{
            happinessView.value = happinessVal
            foodLevelView.value = foodLevelVal
        }
        playedTimes.text = "played:\(String(currentPet!.playedTimes))"
        fedTimes.text = "fed:\(String(currentPet!.fedTimes))"
    }
    
    func SwitchPet(pet : PetGenre){
        if currentPet!.genre == pet {
            return
        }
        let theImage = UIImage.init(named: pet.description)
        petImage.image = theImage
        if pets[pet] == nil{
            let newPet = Pet(genre: pet, color: UIColor.init(named: pet.description)!)
            pets[newPet.genre] = newPet
        }
        currentPet = pets[pet]
    }
    
    @IBAction func OnDogPressed(_ sender: Any) {
        guard (currentPet != nil) else { return }
        SwitchPet(pet: .dog)
    }
    
    @IBAction func OnCatPressed(_ sender: Any) {
        guard (currentPet != nil) else { return }
        SwitchPet(pet: .cat)
    }
    @IBAction func OnBirdPressed(_ sender: Any) {
        guard (currentPet != nil) else { return }
        SwitchPet(pet: .bird)
    }
    @IBAction func OnBunnyPressed(_ sender: Any) {
        guard (currentPet != nil) else { return }
        SwitchPet(pet: .bunny)
    }
    @IBAction func OnFishPressed(_ sender: Any) {
        guard (currentPet != nil) else { return }
        SwitchPet(pet: .fish)
    }
    
}

