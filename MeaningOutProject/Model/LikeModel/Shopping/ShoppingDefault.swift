//
//  ShoppingDefault.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/19/24.
//

import Foundation

@propertyWrapper
struct ShoppingDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue}
        set { self.storage.set(newValue, forKey: self.key)}
    }
}
