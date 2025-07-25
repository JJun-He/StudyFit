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
                FilterSortBar(viewModel: viewModel)
                
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
            
            if !text.isEmpty {
                Button("취소"){
                    text = ""
                }
                .font(.caption)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// MARK: - 필터 및 정렬 바
struct FilterSortBar: View {
    @ObservedObject var viewModel: RecommendationViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 12){
                // 정렬 옵션
                ForEach(RecommendationViewModel.SortOption.allCases, id: \.self){ option in
                    Button(action: {
                        viewModel.sortOption = option
                        viewModel.applySortAndFilter()
                    }){
                        HStack(spacing: 4){
                            Image(systemName: option.systemImage)
                                .font(.caption)
                            Text(option.rawValue)
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.sortOption == option ? Color.blue: Color.gray.opacity(0.2))
                        )
                        .foregroundColor(viewModel.sortOption == option ? .white: .primary)
                    }
                }
                
                // 필터 표시
                if viewModel.selectedSubject != nil ||
                    viewModel.selectedDifficulty != nil ||
                    viewModel.selectedPlatform != nil{
                    Button("필터 해제 ❌"){
                        viewModel.resetFilters()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    RecommendationView(personalityType: .conceptMaster)
}
