//
//  RealmLikeListModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import Foundation
import RealmSwift


class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var folderName: String
    @Persisted var image: String
    @Persisted var imageColor: String
    
    @Persisted var likeLists: List<LikeList>
    
    convenience init(folderName: String, image: String, imageColor: String, likeLists: List<LikeList>) {
        self.init()
        self.folderName = folderName
        self.image = image
        self.imageColor = imageColor
        self.likeLists = likeLists
    }
}

class LikeList: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var link: String
    convenience init(productId: String, title: String, image: String, lprice: String, mallName: String, link: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.link = link
    }
}
//struct Item: Decodable {
//    let title: String
//    let link: String
//    let image: String
//    let lprice: String
//    let mallName: String
//    let productId: String
//}
