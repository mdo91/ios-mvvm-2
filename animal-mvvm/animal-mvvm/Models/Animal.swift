//
//  Animal.swift
//  animal-mvvm
//
//  Created by Mdo on 10/05/2021.
//

import Foundation

struct Animal:Codable,Hashable {
    let id:Int
    let name:String
    let timeSeen:Date
    let latitude:Double
    let longitude:Double
    let description:String
    let imageURL:String
}
