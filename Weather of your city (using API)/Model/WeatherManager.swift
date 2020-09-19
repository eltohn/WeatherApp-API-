//
//  WeatherManager.swift
//  Weather of your city (using API)
//
//  Created by Elbek Shaykulov on 8/6/20.
//  Copyright © 2020 Elbek Shaykulov. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager:WeatherManager , weather:WeatherModel)
    func errorFound(error:Error)
    }
 

struct WeatherManager
{
     
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5d305a27c41770a76931656224861e9c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String )
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        requestData(urlString:urlString)
        
    }
   func fetchWeather(latitude : CLLocationDegrees , longtitude : CLLocationDegrees)
    {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=5d305a27c41770a76931656224861e9c&units=metric&lat=\(latitude)&lon=\(longtitude)"
        requestData(urlString: urlString)
    }
    
    
    func requestData(urlString:String)
    {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    self.delegate?.errorFound(error: error!)
                    return
                }
                if let safeData = data
                {
                    if let weather = self.parseJSON(weatherData : safeData)
                    {
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData:Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temperature = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(temperature: temperature , cityName: name, conditionID: id)
            return weather
        }catch{
            delegate?.errorFound(error: error)
            return nil
        }
        
    }
    
    
}
