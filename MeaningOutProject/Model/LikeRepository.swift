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
    func addDefaultFolderIfNeeded() {
        let folder = realm.objects(Folder.self)
        if folder.isEmpty {
            let folder = FolderModel(folderName: "전체", image: "figure", imageColor: "냠냠")
            self.addFolder(folder)
        }
    }
    
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
            if folder == self.fetchFolder().first {
                addItem(item, folder: folder)
            } else {
                let totalfolder = self.fetchFolder().first!
                addItem(item, folder: totalfolder)
                addItem(item, folder: folder)
            }
        } else {
            deleteItem(item)
        }
    }
    
    func deleteItem(_ item: LikeList) {
            guard let realm = item.realm else {
                print("삭제 오류: Item does not belong to any realm instance.")
                return
            }
            
            do {
                try realm.write {
                    // 모든 폴더에서 likeLists 리스트에서 해당 객체 제거
                    for folder in fetchFolder() {
                        if let index = folder.likeLists.firstIndex(where: { $0.productId == item.productId }) {
                            folder.likeLists.remove(at: index)
                        }
                    }
                    
                    // Realm 데이터베이스에서 객체 삭제
                    realm.delete(item)
                }
            } catch {
                print("삭제 오류: \(error)")
            }
        }
    
    private func addItem(_ item: LikeList, folder: Folder?) {
        guard let folder = folder else {return}
        do {
            try realm.write {
                realm.add(item)
                folder.likeLists.append(item)
            }
        } catch {
            print("추가 오류: \(error)")
        }
    }
}
