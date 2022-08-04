//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Eugene on 29.07.22.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temperature: Double
    
    // format temperature to be able to use it in Temperature Label
    var tempForLabel: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
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
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }
    
    
}
