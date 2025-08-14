//
//  SearchHistoryManager.swift
//  StudyFit
//

import Foundation

class SearchHistoryManager: ObservableObject{
    @Published var searchHistory: [SearchHistoryItem] = []
    
    private let userDefaults = UserDefaults.standard
    private let historyKey = "SearchHistory"
    private let maxHistoryCount = 10
    
    init(){
        loadSearchHistory()
    }
    
    // MARK: - 검색 기록 저장/로드
    func addSearchTerm(_ term: String){
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 빈 문자열이면 저장하지 않음
        guard !trimmedTerm.isEmpty else { return }
        
        // 중복 제거 (기존에 있으면 맨 위로 이동)
        searchHistory.removeAll{$0.term.lowercased() == trimmedTerm.lowercased()}
        
        // 새 검색어를 맨 앞에 추가
        let newItem = SearchHistoryItem(term: trimmedTerm, searchDate: Date())
        searchHistory.insert(newItem, at: 0)
        
        // 최대 개수 제한
        if searchHistory.count > maxHistoryCount{
            searchHistory = Array(searchHistory.prefix(maxHistoryCount))
        }
        
        saveSearchHistory()
    }
    
    func removeSearchTerm(at index: Int){
        guard index < searchHistory.count else { return }
        searchHistory.remove(at: index)
        saveSearchHistory()
    }
    
    func removeSearchTerm(_ term: String){
        searchHistory.removeAll{$0.term == term}
        saveSearchHistory()
    }
    
    func clearAllHistory(){
        searchHistory.removeAll()
        saveSearchHistory()
    }
    
    private func saveSearchHistory(){
        do{
            let data = try JSONEncoder().encode(searchHistory)
            userDefaults.set(data, forKey: historyKey)
        }catch{
            print("검색 기록 저장 실패: \(error)")
        }
    }
    
    private func loadSearchHistory(){
        guard let data = userDefaults.data(forKey: historyKey) else { return }
        
        do{
            searchHistory = try JSONDecoder().decode([SearchHistoryItem].self, from: data)
        }catch{
            print("검색 기록 로드 실패: \(error)")
            searchHistory = []
        }
    }
    
    // MARK: - 인기 검색어(가장 만힝 검색된 순)
    func getPopularSearchTerms() -> [String]{
        let termCounts = Dictionary(grouping: searchHistory){$0.term}
            .mapValues{$0.count}
        
        return termCounts.sorted{$0.value > $1.value}
            .prefix(5)
            .map{$0.key}
    }
}

// MARK: - 검색 기록 아이템
struct SearchHistoryItem: Codable, Identifiable{
    let id = UUID()
    let term: String
    let searchDate: Date
    
    var timeAgo: String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: searchDate, relativeTo: Date())
    }
}
