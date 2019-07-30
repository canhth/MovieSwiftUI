//
//  PaginatedResponse.swift
//  SwiftUIMovies
//
//  Created by Canh Tran Wizeline on 7/30/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let page: Int?
    let total_result: Int?
    let total_pages: Int
    let results: [T]
}
