//
//  DataModel.swift
//  Falcone
//
//  Created by Mohd Wasif Raza on 21/09/23.
//

import Foundation

struct Planet: Codable {
    let name: String
    let distance: Int
}

typealias planets = [Planet]

struct Vehicle: Codable {
    let name: String
    let total_no: Int
    let max_distance: Int
    let speed: Int
}

typealias vehicles = [Vehicle]

struct ResultData: Codable {
    let planet_name: String
    let status: String
}
