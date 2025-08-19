//
//  AdvancedSearchBar.swift
//  StudyFit
//

import SwiftUI

struct AdvancedSearchBar: View {
    @ObservedObject var searchManager: SearchManager
    @State private var isEditing = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // 검색바
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("인강이나 학원을 검색해보세요", text: $searchManager.searchText)
                        .focused($isSearchFocused)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isEditing = true
                                searchManager.showHistory()
                            }
                        }
                        .onChange(of: isSearchFocused) { focused in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if focused {
                                    isEditing = true
                                    searchManager.showHistory()
                                } else if searchManager.searchText.isEmpty {
                                    searchManager.hideHistory()
                                }
                            }
                        }
                    
                    if !searchManager.searchText.isEmpty {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                searchManager.clearSearch()
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                if isEditing {
                    Button("취소") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            searchManager.clearSearch()
                            isEditing = false
                            isSearchFocused = false
                        }
                        hideKeyboard()
                    }
                    .foregroundColor(.blue)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isEditing)
            
            // 검색 기록 드롭다운
            if searchManager.isShowingHistory && (isEditing || isSearchFocused) {
                SearchHistoryDropdown(searchManager: searchManager)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: searchManager.isShowingHistory)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    VStack {
        AdvancedSearchBar(searchManager: SearchManager())
        Spacer()
    }
    .padding()
}
