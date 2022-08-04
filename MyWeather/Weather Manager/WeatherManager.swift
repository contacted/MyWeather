//
//  WeatherManager.swift
//  MyWeather
//
//  Created by Eugene on 28.07.22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didEndWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ac9e9b358f42310538904c8e3386e424&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // perform the networking to fetch live data from open weather map API
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didEndWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    // parse the weather into an actual object 
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            return weather
            
        } catch {
            delegate?.didEndWithError(error: error)
            return nil
        }
    }
    
    
}
