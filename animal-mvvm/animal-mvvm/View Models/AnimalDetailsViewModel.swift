//
//  AnimalDetailsViewModel.swift
//  animal-mvvm
//
//  Created by Mdo on 11/05/2021.
//

import Foundation
import UIKit
final class AnimalDetailViewModel{
    
    enum GetAnimalResult{
        case successfulWithAnimal(Animal)
        case successfulWithImage(UIImage)
        case failure(String)
    }
    
    private let apiController:APIController
    
    init(apiController:APIController = APIController()) {
        self.apiController = apiController
    }
    
    func getAnimal(with name: String, completion: @escaping (GetAnimalResult) -> Void){
        apiController.getAnimal(for: name) { (result) in
            
            DispatchQueue.main.async { [weak self] in
                
                do{
                    let animal = try result.get()
                    completion(.successfulWithAnimal(animal))
                    self?.getImage(for: animal, completion: completion)
                    
                }catch{
                    completion(.failure("Unable to fetch animal: \(name)"))
                }
                
            }
        }
    }
    
    private func getImage(for animal:Animal, completion: @escaping (GetAnimalResult) -> Void){
        apiController.getImage(at: animal.imageURL) { (result) in
            DispatchQueue.main.async {
                do{
                    let image = try result.get()
                    completion(.successfulWithImage(image))
                    
                }catch{
                    completion(.failure("Unable to fetch image for \(animal.name)"))
                }
            }
        }
    }
}
