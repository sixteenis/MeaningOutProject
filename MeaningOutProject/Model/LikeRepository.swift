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
    func addDefaultFolderIfNeeded() {
        let folder = realm.objects(Folder.self)
        if folder.isEmpty{
            let folder = FolderModel(folderName: "전체", image: "냠냠이", imageColor: "냠냠")
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
        }catch {
            print("폴더 생성 error")
        }
    }
    func fetchFolder() -> [Folder] {
        let value = realm.objects(Folder.self)
        return Array(value)
    }
    
    
    
    
    func fetchAll() -> [LikeList] {
        let data = realm.objects(LikeList.self)
        
        return Array(data)
    }
    
    func toggleLike(_ item: LikeList, folder: Folder) {
        let data = realm.objects(LikeList.self).where {
            $0.productId == item.productId
        }
        print(data)
        if data.isEmpty {
            addItem(item, folder: folder)
        }else{
            deleteItem(item, folder: folder)
        }
    }
    func deleteItem(_ item: LikeList, folder: Folder) {
        print("삭제부분")
        print("삭제부분")
           do {
               try realm.write {
                   if let index = folder.likeLists.firstIndex(where: { $0.productId == item.productId }) {
                       let itemToDelete = folder.likeLists[index]
                       folder.likeLists.remove(at: index)
                       realm.delete(itemToDelete)
                   }
               }
           } catch {
               print("삭제 오류: \(error)")
           }
    }
    func addItem(_ item: LikeList, folder: Folder) {
        do {
            try realm.write {
                realm.add(item)
                folder.likeLists.append(item)
            }
        }catch {
            print("추가 오류")
        }
    }
    
}
