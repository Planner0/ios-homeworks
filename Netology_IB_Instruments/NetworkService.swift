//
//  NetworkService.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 13.07.2022.
//

import Foundation
import UIKit

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        switch configuration {
        case .first(let uRL):
            dataTask(uRL: uRL)
        case .second(let uRL):
            dataTask(uRL: uRL)
        case .third(let uRL):
            dataTask(uRL: uRL)
        }
    }
}
enum AppConfiguration {
    case first (URL)
    case second (URL)
    case third (URL)
}
func dataTask(uRL: URL){
    let task = URLSession.shared.dataTask(with: uRL) { data, response, error in
        if let data = data {
            //print("🍏 \(data) \(String(data: data, encoding: .nextstep))")
        }
        if let response = response as? HTTPURLResponse {
            //print("🍎 \(response.statusCode), \(response.allHeaderFields)")
        }
        if let error = error {
           // print("🍋 \(error.localizedDescription)")
        }
    }
    task.resume()
}
func dataTaskTwo(titleLabel: UILabel) {
    
    // Создаем объект URL с помощью строки
    if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/120") {
        
        // Вызываем URLSession.shared, создаем для сессии DataTask
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let unwrappedData = data {
                do {
                    let serializedDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                    //print(serializedDictionary)
                    
                    // Приводим serializedDictionary к [String: Any]
                    if let dict = serializedDictionary as? [String: Any],
                       // Приводим поле title к типу String
                       let title = dict["title"] as? String {
                        DispatchQueue.main.async {
                            titleLabel.text = title
                            print(titleLabel.text ?? "")
                        }
                    }
                }
                catch let error {
                    //print(error.localizedDescription)
                }
            }
            // Печатаем ответ
            //   print("Server's response is: \(data)")
        }
        
        // начинаем выполнение
        task.resume()
        
    } else {
        print("Cannot create URL")
    }
}

struct Planet: Decodable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents, films: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}
func dataTask3(UILabel: UILabel) {

    // Создаем объект URL с помощью строки
    if let url = URL(string: "https://swapi.dev/api/planets/1") {
        
        // Вызываем URLSession.shared, создаем для сессии DataTask
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let unwrappedData = data {
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: unwrappedData)
                    DispatchQueue.main.async {
                        UILabel.text = planet.orbitalPeriod
                    }
                    print(planet.name)
                }
                catch let error {
                    //print(error.localizedDescription)
                }
            }
        }
        // начинаем выполнение
        task.resume()
    } else {
        print("Cannot create URL")
    }
}
