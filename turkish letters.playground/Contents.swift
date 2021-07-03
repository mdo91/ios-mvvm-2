import UIKit


func convert(string: String) -> String{

    let letters = ["ş":"s","ı":"i","ö":"o","ç":"c","ğ":"g","ü":"u","i̇":"i"]
    
    let result = string.lowercased().compactMap { letter in
        if let value = letters["\(letter)"]{
            return value
        }else{
            return "\(letter)"
        }
    } as [String]
    return result.joined()
    }

print(convert(string: "Çorum"))

