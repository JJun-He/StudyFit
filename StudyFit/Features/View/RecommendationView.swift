//
//  RecommendationView.swift
//  StudyFit
//


import SwiftUI

struct RecommendationView: View {
    let personalityType: StudyPersonalityType?
    @StateObject private var viewModel = RecommendationViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                // 검색 바
                SearchBar(text: $viewModel.searchText)
                    .onSubmit{
                        viewModel.applySortAndFilter()
                    }
                
                // 필터 및 정렬 바
                
                
                // 세그먼트 컨트롤
                
            }
        }
    }
}

// MARK: - 검색 바
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("인강이나 학원을 검색하세요", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
        }
    }
}

#Preview {
    RecommendationView(personalityType: .conceptMaster)
}
