//
//  ShoppingModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import Foundation

struct ShoppingModel: Decodable {
    let total: Int?
    let start: Int?
    let items: [Item]?
}

struct Item: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
