//
//  WeatherManager.swift
//  ClimaUI
//
//  Created by Kenneth Liou on 12/9/19.
//  Copyright © 2019 Kenneth Liou. All rights reserved.
//

import Foundation
//protocol for delegates of WeatherManager
protocol WeatherManagerDelegate {
    func updateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager: ObservableObject {
    //openweather api URL
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c9fb8291c2f0489528d5a1025ec4795c&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    //fetch weather based on city name
    func fetchWeather(cityName: String) {
        let formattedString = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(formattedString)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    //fetch weather based on location data
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //get data from url
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //parse JSON info
                    if let weather = self.parseJSON(safeData) {
                        //call the updateWeather function in delegates of WeatherManager
                        self.delegate?.updateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    //function to parse JSON info
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        //get data from WeatherData
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            //store parsed data in WeatherModel
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
            //if error...
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
