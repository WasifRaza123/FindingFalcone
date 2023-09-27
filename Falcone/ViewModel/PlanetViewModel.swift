//
//  PlanetViewModel.swift
//  Falcone
//
//  Created by Mohd Wasif Raza on 21/09/23.
//

import UIKit

class PlanetViewModel: NSObject {
    private var apiCaller: APICaller!
    private(set) var planetData: planets! {
        didSet {
            self.bindPlanetViewModelToController()
        }
    }
    
    private(set) var vehiclesData: vehicles! {
        didSet {
            self.bindVehicleViewModelToController()
        }
    }
    
    var token: String!
    
    // By assigning a closure or function to this variable,
    // you can define a block of code that can be executed when you invoke bindPlanetViewModelToController
    var bindPlanetViewModelToController: (()->()) = {}
    var bindVehicleViewModelToController: (()->()) = {}
    
    override init() {
        super.init()
        self.apiCaller = APICaller()
        
        fetchData()
        
    }
    
    
    func fetchData() {
        apiCaller.fetchPlanetData { [weak self] result in
            switch result {
            case .success(let data):
                self?.planetData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        apiCaller.fetchVehicleData { [weak self] result in
            switch result {
            case .success(let data):
                self?.vehiclesData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        apiCaller.fetchToken { [weak self] result in
            switch result {
            case .success(let data):
                self?.token = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchFinalResult(token: String, planetNames: [String], vehicleNames: [String]) {
        apiCaller.fetchResult(token: token, planetNames: planetNames, vehicleNames: vehicleNames)
        
    }

}
