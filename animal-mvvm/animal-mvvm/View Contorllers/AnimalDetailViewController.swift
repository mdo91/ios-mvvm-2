//
//  AnimalDetailViewController.swift
//  animal-mvvm
//
//  Created by Mdo on 19/05/2021.
//

import Foundation
import UIKit

class AnimalDetailViewController:UIViewController{
    
    static let identifier:String = String(describing: AnimalDetailViewController.self)
    
    @IBOutlet weak var timeSeenLabel:UILabel!
    @IBOutlet weak var coordinatesLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var animalImageView:UIImageView!
    
    var animalName:String?
    
    private lazy var viewModel = AnimalDetailViewModel()
    
    private lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalImageView.layer.cornerRadius = animalImageView.bounds.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let animalName = animalName else {
            return
        }
        viewModel.getAnimal(with: animalName) { [weak self] result in
            guard let self = self else{ return }
            
            switch result{
            case .successfulWithAnimal(let animal):
                self.updateViews(with: animal)
            case .successfulWithImage(let image):
                self.animalImageView.image = image
            case .failure(let message):
                let alert = UIAlertController(title: "Error",
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func updateViews(with animal:Animal){
        title = animal.name
        timeSeenLabel.text = dateFormatter.string(from: animal.timeSeen)
        coordinatesLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        descriptionLabel.text = animal.description
        
    }
}
