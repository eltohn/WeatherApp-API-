//
//  WeatherData.swift
//  Weather of your city (using API)
//
//  Created by Elbek Shaykulov on 8/7/20.
//  Copyright © 2020 Elbek Shaykulov. All rights reserved.
//

import Foundation

struct WeatherData :Codable
{
    var name : String
    var main : Main
    var weather: [Weather]
    
}
struct Main : Codable{
    var temp : Double
}

struct Weather: Codable {
    var id : Int
}
