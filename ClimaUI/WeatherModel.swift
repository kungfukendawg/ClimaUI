//
//  WeatherModel.swift
//  ClimaUI
//
//  Created by Kenneth Liou on 12/14/19.
//  Copyright © 2019 Kenneth Liou. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    //weather data that is stored in WeatherModel
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //convert temperature as a double into a string
    var temperatureString: String {
        return String(temperature)
    }
    
    //different SF symbol depending on the case of the conditionID
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...803:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
