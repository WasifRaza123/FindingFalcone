//
//  APICaller.swift
//  Falcone
//
//  Created by Mohd Wasif Raza on 21/09/23.
//

import Foundation

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    func fetchPlanetData(completion: @escaping (Result<planets,Error>) -> Void) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/planets") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(planets.self, from: data)
                print(results.count)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    
    func fetchVehicleData(completion: @escaping (Result<vehicles,Error>) -> Void) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/vehicles") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(vehicles.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    
    func fetchToken(completion: @escaping (Result<String,Error>) -> Void){
        guard let url = URL(string: "https://findfalcone.geektrust.com/token") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print(httpResponse)
                if let data = data {
                    do{
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            completion(.success(token))
                        }
                    }
                    catch {
                        completion(.failure(APIError.failedTogetData))
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchResult(token: String, planetNames: [String], vehicleNames: [String]) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/find") else { return }
        let requestBody = ["token": token,
                           "planet_names": planetNames,
                           "vehicle_names": vehicleNames] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let data = data else {return}
                do {
                    let results = try JSONDecoder().decode(ResultData.self, from: data)
                    print(results.planet_name)
                    print(results.status)
                }
                catch {
                    print("planet not found")
                }
            }
            task.resume()
        }
        catch {
            print(error.localizedDescription)
            
        }
        
    }
}
