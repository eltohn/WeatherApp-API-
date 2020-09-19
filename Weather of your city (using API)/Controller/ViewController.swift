//
//  ViewController.swift
//  Weather of your city (using API)
//
//  Created by Elbek Shaykulov on 8/5/20.
//  Copyright © 2020 Elbek Shaykulov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController   {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherCondition: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager  = WeatherManager()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
         
        
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    

}




//MARK: - Textfield

extension ViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""
        {
            
            return true
        }else{
            searchTextField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Final TextField.text
        
        if let city = searchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}



//MARK: - WeatherManagerDelegate


extension ViewController: WeatherManagerDelegate
{
    func didUpdateWeather(weatherManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async { // Correct
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.weatherCondition.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    func errorFound(error: Error) {
        print(error)
    }
}



extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude : lat , longtitude : lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
