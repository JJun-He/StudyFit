//
//  RecommendationViewModel.swift
//  StudyFit
//


import Foundation

class RecommendationViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var academies: [Academy] = []
    @Published var isLoading = false
    @Published var selectedSubject: Subject? = nil
    @Published var selectedDifficulty: Difficulty? = nil
    @Published var selectedPlatform: Platform? = nil
    @Published var searchText = ""
    @Published var showingFilter = false
    @Published var sortOption: SortOption = .rating
    
    private let recommendationService = RecommendationService()
    
    enum SortOption: String, CaseIterable {
        case rating = "평점 순"
        case reviewCount = "리뷰 순"
        case price = "가격 순"
        case popular = "인기 순"
        
        var systemImage: String{
            switch self {
            case .rating: return "star.fill"
            case .reviewCount: return "person.2.fill"
            case .price: return "wonsign.circle.fill"
            case .popular: return "flame.fill"
            }
        }
    }
    
    init(){
        loadRecommendations()
    }
    
    // MARK: - 데이터 로드
    func loadRecommendations(for personalityType: StudyPersonalityType? = nil) {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let type = personalityType {
                self.courses = SampleData.getCourses(for: type)
                self.academies = SampleData.getAcademies(for: type)
            }else{
                self.courses = SampleData.courses
                self.academies = SampleData.academies
            }
            
            self.applySortAndFilter()
            self.isLoading = false
            
            print("추천 데이터 로드 완료: 인강 \(self.courses.count)개, 학원\(self.academies.count)개")
        }
    }
    
    // MARK: - 필터링 및 정렬
    func applySortAndFilter() {
        var filteredCourses = courses
        var filteredAcademies = academies
        
        // 텍스트 검색
        if !searchText.isEmpty{
            filteredCourses = filteredCourses.filter{ course in
                course.title.localizedStandardContains(searchText) ||
                course.instructor.localizedCaseInsensitiveContains(searchText) ||
                course.tags.contains {$0.localizedCaseInsensitiveContains(searchText) }
            }
            
            filteredAcademies = filteredAcademies.filter { academy in
                academy.name.localizedCaseInsensitiveContains(searchText) ||
                academy.address.localizedCaseInsensitiveContains(searchText) ||
                academy.specialties.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // 과목 필터
        if let subject = selectedSubject{
            filteredCourses = filteredCourses.filter{$0.subject == subject || $0.subject == .all }
            filteredAcademies = filteredAcademies.filter{$0.subjects.contains(subject)}
        }
        
        // 난이도 필터
        if let difficulty = selectedDifficulty{
            filteredCourses = filteredCourses.filter{$0.difficulty == difficulty}
        }
        
        // 플랫폼 필터
        if let platform = selectedPlatform{
            filteredCourses = filteredCourses.filter{$0.platform == platform}
        }
        
        // 정렬
        filteredCourses = sortCourses(filteredCourses, by: sortOption)
        filteredAcademies = sortAcademies(filteredAcademies, by: sortOption)
        
        courses = filteredCourses
        academies = filteredAcademies
    }
    
    private func sortCourses(_ courses: [Course], by option: SortOption) -> [Course] {
        switch option {
        case .rating:
            return courses.sorted { $0.rating > $1.rating }
        case .reviewCount:
            return courses.sorted {$0.reviewCount > $1.reviewCount}
        case .price:
            return courses.sorted {$0.price < $1.price}
        case .popular:
            return courses.sorted{ lhs, rhs in
                if lhs.isPopular && !rhs.isPopular {return true}
                if !lhs.isPopular && rhs.isPopular {return false}
                return lhs.reviewCount > rhs.reviewCount
            }
        }
    }
    
    private func sortAcademies(_ academies: [Academy], by option: SortOption) -> [Academy] {
        switch option {
        case .rating, .popular:
            return academies.sorted { $0.rating > $1.rating }
        case .reviewCount:
            return academies.sorted {$0.reviewCount > $1.reviewCount}
        case .price:
            return academies // 학원은 가격 정렬이 복잡하므로 일단 기본 순서
        }
    }
    
    // MARK: - 북마크 기능
    func toggleBookmark(for course: Course) {
        recommendationService.toggleBookmark(courseId: course.id)
    }
    
    func toggleBookmark(for academy: Academy) {
        recommendationService.toggleBookmark(academyId: academy.id)
    }
    
    func isBookmarked(courseId: String) -> Bool {
        return recommendationService.isBookmarked(courseId: courseId)
    }
    
    func isBookmarked(academyId: String) -> Bool {
        return recommendationService.isBookmarked(academyId: academyId)
    }
    
    // MARK: - 필터 리셋
    func resetFilters() {
        selectedSubject = nil
        selectedDifficulty = nil
        selectedPlatform = nil
        searchText = ""
        sortOption = .rating
        applySortAndFilter()
    }
}

// MARK: - SampleData 확장
extension SampleData {
    static func getCourses(for personalityType: StudyPersonalityType) -> [Course]{
        return courses.filter{$0.suitableFor.contains(personalityType)}
    }
    
    static func getAcademies(for personalityType: StudyPersonalityType) -> [Academy]{
        return academies.filter{$0.suitableFor.contains(personalityType)}
    }
}
