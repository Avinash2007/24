//
//  DefaultManager.swift
//  24
//
//  Created by Nivedita Chauhan on 20/04/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation

enum Keys :String{
    case homeData
}

class DefaultManager{
    static let shared = DefaultManager.init()
    let standeredDefault = UserDefaults.standard
    
    func setHomeData(data:Data?) {
        standeredDefault.set(data, forKey: Keys.homeData.rawValue)
    }
    
    func getHomeData()->Data?{
        return standeredDefault.value(forKey: Keys.homeData.rawValue) as? Data
    }
    
}
