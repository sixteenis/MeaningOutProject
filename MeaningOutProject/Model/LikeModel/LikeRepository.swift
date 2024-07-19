//
//  LikeRepository.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import Foundation
import RealmSwift

final class LikeRepository {
    private let realm = try! Realm()
    static let shard = LikeRepository()
    private init() {}
    func addFolder(_ folder: FolderModel) {
        let newFolder = Folder(folderName: folder.folderName, image: folder.image, imageColor: folder.imageColor, likeLists: List<LikeList>())
        print(realm.configuration.fileURL ?? "")
        do {
            try realm.write {
                realm.add(newFolder)
            }
        } catch {
            print("폴더 생성 error: \(error)")
        }
    }
    func getFolderList() -> [FolderModel] {
        var result = [FolderModel]()
        let allFolder = FolderModel(folderName: "전체", image: "bag.fill", imageColor: "blue", likeList: fetchAll())
        result.append(allFolder)
        let customFolder = fetchFolder()
        customFolder.forEach {
            let temp = FolderModel(folderName: $0.folderName, image: $0.image, imageColor: $0.imageColor, likeList: Array($0.likeLists))
            result.append(temp)
        }
        return result
    }
    
    func fetchFolder() -> [Folder] {
        let value = Array(realm.objects(Folder.self))
        return value
    }
    
    
    func getLikeList() -> [String] {
        let data = fetchAll()
        let result = data.map { $0.productId }
        return result
    }
    
    func fetchAll() -> [LikeList] {
        let data = Array(realm.objects(LikeList.self))
        return data
    }
    
    func toggleLike(_ item: LikeList, folder: Folder?) {
        let data = realm.objects(LikeList.self).where {
            $0.productId == item.productId
        }
        if data.isEmpty {
            if folder == nil{
                addItem(item, folder: nil)
            } else {
                addItem(item, folder: folder)
            }
        } else {
            deleteItem(item)
        }
    }
    
    
    // MARK: - 폴더로 변경해서 구현중인데 아직 구현 못함
    private func deleteItem(_ item: LikeList) {
            do {
                let removeItem = realm.objects(LikeList.self).where {
                    $0.productId == item.productId
                }
                try realm.write {
                    realm.delete(removeItem)
                }
            } catch {
                print("삭제 오류: \(error)")
            }
        }
    
    private func addItem(_ item: LikeList, folder: Folder?) {
        guard let folder = folder else {
            try! realm.write {
                realm.add(item)
            }
            return
        }
        do {
            try realm.write {
                //realm.add(item)
                folder.likeLists.append(item)
            }
        } catch {
            print("추가 오류: \(error)")
        }
    }
}
