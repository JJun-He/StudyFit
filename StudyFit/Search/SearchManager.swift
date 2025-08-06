//
//  SearchManager.swift
//  StudyFit
//


import Foundation
import Combine

class SearchManager: ObservableObject{
    @Published var searchText = ""
    @Published var debouncedSearchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceTime: TimeInterval
    
    init(debounceTime: TimeInterval = 0.3){
        self.debounceTime = debounceTime
        setupDebouncing()
    }
    
    private func setupDebouncing(){
        $searchText
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .sink{[weak self] value in
                self?.debouncedSearchText = value
            }
            .store(in: &cancellables)
    }
    
    func clearSearch(){
        searchText = ""
        debouncedSearchText = ""
    }
}
