//
//  AnimalsViewModel.swift
//  animal-mvvm
//
//  Created by Mdo on 11/05/2021.
//

import Foundation


final class AnimalsViewModel{
    
    enum GetAnimalsNamesResult {
        case success
        case failure(String)
    }
    var animalNames = [String]()
    
    var shouldPresentLoginViewController:Bool{
        APIController.bearer == nil
    }
    
    private let apiController:APIController
    
    init(apiController:APIController = APIController()) {
        self.apiController = apiController
    }
    
    func getAnimalNames(completion: @escaping(GetAnimalsNamesResult) -> Void){
        
        apiController.getAnimalNames { [weak self] result in
            guard let self = self else{ return }
            
            DispatchQueue.main.async {
                switch result{
                case .success(let animalNames):
                    self.animalNames = animalNames
                    completion(.success)
                case .failure(_):
                completion(.failure("Unable to fetch animal names."))
                }
            }
        }
    }
}
