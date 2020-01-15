//
//  ContentView.swift
//  ClimaUI
//
//  Created by Kenneth Liou on 12/3/19.
//  Copyright © 2019 Kenneth Liou. All rights reserved.
//  API Key: c9fb8291c2f0489528d5a1025ec4795c

import SwiftUI

struct ContentView: View {
    
    //update change
    @State var updateVariable = 1

    @ObservedObject var weatherManager = WeatherManager()
    
    //variables to display on view
    @State var cityTextField = ""
    @State var weatherIcon = "sun.max"
    @State var tempDisplay = ""
    @State var cityDisplay = ""
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            //top row
            HStack {
                
                //location button
                Button(action: {
                    if let location = self.locationFetcher.lastKnownLocation {
                        let lat = location.latitude
                        let long = location.longitude
                        self.weatherManager.delegate = self
                        self.weatherManager.fetchWeather(latitude: lat, longitude: long)
                    } else {
                        print("Your location is unknown")
                    }
                    
                }) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .accentColor(.black)
                }
                .padding()
                
                //search field
                TextField("Search city", text: $cityTextField, onEditingChanged: {_ in
                    if self.cityTextField != "" {
                        self.weatherManager.delegate = self
                        self.weatherManager.fetchWeather(cityName: self.cityTextField)
                        self.cityTextField = ""
                    } 
                })
                    .padding()
                    .accentColor(.white)
                    .autocapitalization(.words)
                    .background(Color(.gray)
                        .opacity(0.3))
                    .cornerRadius(10.0)
                
                //search button
                Button(action: {
                    if self.cityTextField != "" {
                        self.weatherManager.delegate = self
                        self.weatherManager.fetchWeather(cityName: self.cityTextField)
                        self.cityTextField = ""
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .accentColor(.black)
                }
                .padding()
            }
            
            //display SF weather symbol to show weather condition
            Image(systemName: weatherIcon)
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFit()
                .accentColor(.black)
                .padding()
            
            //display temperature in degrees fahrenheit
            HStack{
                Text(tempDisplay)
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                Text("°F")
                    .font(.system(size: 60))
                    .padding(.trailing)
            }
            
            //display city where weather data is taken from
            Text(cityDisplay)
                .font(.system(size: 40))
                .padding()
            
            Spacer()
        }
        .background(
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill))
    }
    
}

//MARK: - WeatherManagerDelegate

//extension to update the view with new weather data
extension ContentView: WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async{
            self.tempDisplay = String(format: "%.0f", weather.temperature)
            self.weatherIcon = weather.conditionName
            self.cityDisplay = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

