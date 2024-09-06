//
//  ContentViewModel.swift
//  Realm-Example
//
//  Created by ukseung.dev on 9/5/24.
//

import Foundation
import RealmSwift

class MemoViewModel: ObservableObject {
    private var realm: Realm?
    @Published var memos: [MemoData] = []

    init() {
        // Realm 인스턴스 생성
        do {
            realm = try Realm()
            fetchMemos()
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }

    // 메모 저장
    func saveMemo(memoText: String, imageData: Data?) {
        guard let realm = realm else { return }  // realm이 nil인지 확인
        let memo = MemoData()
        memo.id = memoText
        memo.memo = memoText
        memo.image = imageData
        memo.date = Date()

        do {
            try realm.write {
                realm.add(memo)
                fetchMemos() // 저장 후 데이터 업데이트
            }
        } catch {
            print("Error saving memo: \(error)")
        }
    }
    
    // 메모 삭제
    func deleteMemo(at offsets: IndexSet) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                let objectsToDelete = offsets.map { memos[$0] }
                realm.delete(objectsToDelete)
                fetchMemos() // 삭제 후 데이터 업데이트
            }
        } catch {
            print("Error deleting memo: \(error)")
        }
    }
    
    // 메모 수정
    func updateMemo(memo: MemoData, newMemoText: String) {
        guard let realm = realm else { return }
        try! realm.write {
            memo.memo = newMemoText
            memo.date = Date() // Update the date to the current time when modified
        }
        fetchMemos() // Refresh the list of memos
    }

    // 저장된 메모 불러오기
    func fetchMemos() {
        guard let realm = realm else { return }  // realm이 nil인지 확인
        let results = realm.objects(MemoData.self)
        memos = Array(results)
    }
}
