//
//  SearchManager.swift
//  StudyFit
//


import Foundation
import Combine

class SearchManager: ObservableObject{
    @Published var searchText = ""
    @Published var debouncedSearchText = ""
    @Published var isShowingHistory = false
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceTime: TimeInterval
    
    // 검색 기록 관리자
    let historyManager = SearchHistoryManager()
    
    init(debounceTime: TimeInterval = 0.3){
        self.debounceTime = debounceTime
        setupDebouncing()
    }
    
    private func setupDebouncing(){
        $searchText
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .sink{[weak self] value in
                self?.debouncedSearchText = value
                
                // 검색어가 비어있지 않고 디바운싱이 완료되면 검색 기록에 추가
                if !value.isEmpty{
                    self?.historyManager.addSearchTerm(value)
                }
            }
            .store(in: &cancellables)
    }
    
    func clearSearch(){
        searchText = ""
        debouncedSearchText = ""
        isShowingHistory = false
    }
    
    func selectHisotryItem(_ term: String){
        searchText = term
        isShowingHistory = false
        
        // 선택된 검색어로 즉시 검색 수행
        debouncedSearchText = term
    }
    
    func showHistory(){
        isShowingHistory = true
    }
    
    func hideHistory(){
        isShowingHistory = false
    }
}
