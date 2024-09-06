//
//  ContentView.swift
//  Realm-Example
//
//  Created by ukseung.dev on 9/5/24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject private var viewModel = MemoViewModel()
    @State private var memoText: String = ""
    @State private var image: UIImage? = nil
    @State private var showingCustomAlert = false
    @State private var selectedMemo: MemoData?
    @State private var editedMemoText: String = ""

    var body: some View {
        VStack {
            TextField("메모를 입력하세요", text: $memoText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("메모 저장") {
                let imageData = image?.jpegData(compressionQuality: 0.8)
                viewModel.saveMemo(memoText: memoText, imageData: imageData)
            }
            .padding()

            List {
                ForEach(viewModel.memos, id: \.id) { memo in
                    VStack(alignment: .leading) {
                        Text(memo.memo)
                        if let imageData = memo.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                        Text("\(memo.date)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedMemo = memo
                        editedMemoText = memo.memo
                        showingCustomAlert = true
                    }
                }
                .onDelete(perform: viewModel.deleteMemo)
            }
        }
        .sheet(isPresented: $showingCustomAlert) {
            CustomAlertView(
                memoText: $editedMemoText,
                onSave: {
                    if let selectedMemo = selectedMemo {
                        viewModel.updateMemo(memo: selectedMemo, newMemoText: editedMemoText)
                    }
                    showingCustomAlert = false
                }
            )
        }
    }
}

struct CustomAlertView: View {
    @Binding var memoText: String
    var onSave: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Memo")
                .font(.headline)

            TextField("메모를 입력하세요", text: $memoText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Cancel") {
                    // Dismiss the alert
                    onSave()
                }
                .padding()

                Button("Save") {
                    // Save the updated memo text
                    onSave()
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}
