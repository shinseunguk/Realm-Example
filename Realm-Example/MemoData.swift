//
//  MemoData.swift
//  Realm-Example
//
//  Created by ukseung.dev on 9/5/24.
//

import Foundation
import RealmSwift

final class MemoData: Object {
    
    @objc dynamic var id = "" // 기본키
    @objc dynamic var date = Date()
    @objc dynamic var image: Data? = nil
    @objc dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
