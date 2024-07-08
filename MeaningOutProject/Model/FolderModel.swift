//
//  FolderModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import Foundation

class FolderModel {
    private(set) var folderName: String
    private(set) var image: String
    private(set) var imageColor: String
    init(folderName: String, image: String, imageColor: String) {
        self.folderName = folderName
        self.image = image
        self.imageColor = imageColor
    }
    
}
//class Folder: Object {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var folderName: String
//    @Persisted var image: String
//    @Persisted var imageColor: String
//    
//    @Persisted var likeLists: List<LikeList>
//}
