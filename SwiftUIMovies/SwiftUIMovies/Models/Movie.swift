//
//  Movie.swift
//  SwiftUIMovies
//
//  Created by Canh Tran Wizeline on 7/30/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import SwiftUI

struct Movie: Codable, Identifiable {
    let id: Int
    
    let original_title: String
    let title: String
    
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let popularity: Float
    let vote_average: Float
    let vote_count: Int
    
    let release_date: String?
    let runtime: Int?
    let status: String?
    var character: String?
    var department: String?
}
