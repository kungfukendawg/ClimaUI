//
//  WeatherData.swift
//  ClimaUI
//
//  Created by Kenneth Liou on 12/14/19.
//  Copyright © 2019 Kenneth Liou. All rights reserved.
//

import Foundation

//to parse the JSON code
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
