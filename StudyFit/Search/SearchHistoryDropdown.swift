//
//  SearchHistoryDropdown.swift
//  StudyFit
//


import SwiftUI

// MARK: - 검색 기록 드롭다운
struct SearchHistoryDropdown: View {
    
    @ObservedObject var searchManager: SearchManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !searchManager.historyManager.searchHistory.isEmpty{
                // 최근 검색어 섹션
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text("최근 검색어")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("전체 삭제"){
                            searchManager.historyManager.clearAllHistory()
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // 최근 검색어 최대 5개 표시
                    ForEach(Array(searchManager.historyManager.searchHistory.prefix(5).enumerated()), id: \.element.id){index, item in
                        SearchHistoryRow(
                            item: item,
                            onTap: {
                                searchManager.selectHisotryItem(item.term)
                            },
                            onDelete: {
                                searchManager.historyManager.removeSearchTerm(at: index)
                            }
                        )
                    }
                }
                
                // 인기 검색어 섹션
                let popularTerms = searchManager.historyManager.getPopularSearchTerms()
                if !popularTerms.isEmpty{
                    Divider()
                        .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("인기 검색어")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8){
                            ForEach(popularTerms, id: \.self){ term in
                                PopularSearchChip(term: term){
                                    searchManager.selectHisotryItem(term)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }else{
                // 검색 기록이 없을 때
                EmptyHistoryView()
            }
        }
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}


// MARK: - 검색 기록 행
struct SearchHistoryRow: View {
    let item: SearchHistoryItem
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack{
            Button(action: onTap){
                HStack(spacing: 8){
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text(item.term)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(item.timeAgo)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onDelete){
                Image(systemName: "xmark")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(4)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
        )
    }
}

// MARK: - 인기 검색어 칩
struct PopularSearchChip: View {
    let term : String
    let onTap: () -> Void
    
    var body: some View{
        Button(action: onTap){
            HStack(spacing: 4){
                Image(systemName: "flame.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                
                Text(term)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.1))
            .foregroundColor(.orange)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 빈 검색 기록 화면
struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 12){
            Image(systemName: "clock.arrow.circlepath")
                .font(.title2)
                .foregroundColor(.gray)
            
            VStack(spacing: 4){
                Text("최근 검색어가 없습니다")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("검색을 시작해보세요!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
    }
}
