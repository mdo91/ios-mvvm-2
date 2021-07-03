//
//  LoginViewModel.swift
//  animal-mvvm
//
//  Created by Mdo on 11/05/2021.
//

import Foundation
enum LoginType: String{
    case signUp = "Sign up"
    case signIn = "Sign In"
}

final class LoginViewModel{
    
    enum LoginResult:String {
        case signUpSuccess = "Sign up successful. Now please log in."
        case signInSucess
        case signUpError =  "Error occured during sign up."
        case signInError = "Error occured during sign in."
    }
    
    private let apiController:APIController
    
    init(apiController: APIController = APIController()){
        self.apiController = apiController
    }
    func submit(with user:User, forLoginType loginType: LoginType,
                completion: @escaping (LoginResult) -> Void){
        
        switch loginType {
        case .signUp:
            signUp(with: user, completion: completion)
        case .signIn:
            signIn(with: user, completion: completion)
        
            
        }
        
    }
    
    private func signUp(with user:User, completion: @escaping(LoginResult) -> Void ){
        apiController.signUp(with: user) { (result) in
            switch result{
            case .success(_):
                completion(.signUpSuccess)
            case .failure(_):
                completion(.signUpError)
            }
        }
    }
    
    private func signIn(with user: User, completion: @escaping (LoginResult) -> Void){
        apiController.signIn(with: user) { (result) in
            switch result{
            case .success(_):
                completion(.signInSucess)
            case .failure(_):
                completion(.signInError)
            }
            
        }
    }
    
}
