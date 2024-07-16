//
//  FolderModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import Foundation

class FolderModel {
    var folderName: String
    var image: String
    var imageColor: String
    var likeList: LikeList
    init(folderName: String, image: String, imageColor: String, likeList: LikeList) {
        self.folderName = folderName
        self.image = image
        self.imageColor = imageColor
        self.likeList = likeList
    }
//    @Persisted(primaryKey: true) var productId: String
//    @Persisted var title: String
//    @Persisted var image: String
//    @Persisted var lprice: String
//    @Persisted var mallName: String
//    @Persisted var link: String
//
}
//class Folder: Object {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var folderName: String
//    @Persisted var image: String
//    @Persisted var imageColor: String
//    
//    @Persisted var likeLists: List<LikeList>
//}
