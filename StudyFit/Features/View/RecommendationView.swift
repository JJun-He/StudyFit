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
                
                VStack{
                    // 검색 바(AdvancedSearchBar로 업그레이드)
                    AdvancedSearchBar(searchManager: viewModel.searchManager)
                        .padding(.horizontal)
                    
                    // 검색 중일 때 상태 표시
                    if viewModel.isSearching && !viewModel.searchManager.debouncedSearchText.isEmpty{
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                            Text("'\(viewModel.searchManager.debouncedSearchText)'검색 중...")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                    
                }
                .padding(.bottom)
                .background(Color(.systemBackground))
                .zIndex(1)
                
                // 필터 및 정렬 바
                FilterSortBar(viewModel: viewModel)
                
                // 세그먼트 컨트롤
                
            }
        }
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
