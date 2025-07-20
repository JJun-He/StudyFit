//
//  RecommendationService.swift
//  StudyFit
//


import Foundation

class RecommendationService: ObeservableObject {
    @Published var recommendedCourses: [Course] = []
    @Published var recommendedAcademies: [Academy] = []
    @Published var bookmarkedItems: [BookmarkItem] = []
    @Published var isLoading = false
    
    private let bookmarksKey = "bookmarked_items"
    
    init() {
        loadBookmarks()
    }
    
    // MARK: - 추천 로직
    func getRecommendedCourses(for personalityType: StudyPersonalityType, subject: Subject? = nil) -> [Course] {
        var courses = SampleData.courses
        
        // 1. 성향에 맞는 강의 필터링
        courses = courses.filter { course in
            course.suitableFor.contains(personalityType)
        }
        
        // 2. 과목 필터(선택사항)
        if let subject = subject {
            courses = courses.filter {$0.subject == subject || $0.subject == .all}
        }
        
        // 3. 성향별 정렬 우선순위
        courses = courses.sorted{ lhs, rhs in
            let lhsScore = caculateCourseScore(lhs, for: personalityType)
            let rhsScore = caculateCourseScore(rhs, for: personalityType)
            return lhsScore > rhsScore
        }
        
        return Array(courses.prefix(20)) // 상위 20개만
    }
    
    func getRecommendedAcademies(for personalityType: StudyPersonalityType) -> [Academy] {
        var academies = SampleData.academies
        
        // 성향에 맞는 학원 필터링 및 정렬
        academies = academies.filter { academy in
            academy.suitableFor.contains(personalityType)
        }
        
        return academies.sorted { $0.rating > $1.rating }
    }
    
    private func caculateCourseScore(_ course: Course, for personalityType: StudyPersonalityType) -> Double {
        var score: Double = 0
        
        // 기본 점수
        score += course.rating * 20
        score += Double(course.reviewCount) * 0.1
        
        // 성향별 가중치
        if course.suitableFor.contains(personalityType) {
            score += 50
        }
        
        // 인기도 보너스
        if course.isPopular {
            score += 30
        }
        
        // 성향별 특별 가중치
        switch personalityType {
        case .examFocused:
            if course.tags.contains("기출문제"){score += 20}
            if course.tags.contains("실전"){score += 15}
        case .conceptMaster:
            if course.tags.contains("개념완성"){score += 20}
            if course.tags.contains("체계적"){score += 15}
        case .problemSolver:
            if course.tags.contains("문제풀이") { score += 20 }
            if course.tags.contains("실전연습") { score += 15 }
        case .steady:
            if course.tags.contains("꾸준학습") { score += 20 }
            if course.tags.contains("단계별") { score += 15 }
        case .intensive:
            if course.tags.contains("단기완성") { score += 20 }
            if course.tags.contains("집중") { score += 15 }
        }
        
        return score
    }
    
    // MARK: - 북마크 기능
    func toggleBookmark(courseId: String){
        if isBookmarked(courseId: courseId){
            removeBookmark(courseId: courseId)
        }else{
            addBookmark(courseId: courseId)
        }
    }
    
    func toggleBookmark(academyId: String){
        if isBookmarked(academyId: academyId){
            removeBookmark(academyId: academyId)
        }else{
            addBookmark(academyId: academyId)
        }
    }
    
    private func addBookmark(courseId: String){
        let bookmark = BookmarkItem(
            id: UUID().uuidString,
            type: .course,
            courseId: courseId,
            academyId: nil,
            createdAt: Date()
        )
        bookmarkedItems.append(bookmark)
        saveBookmarks()
    }
    
    private func addBookmark(academyId: String){
        let bookmark = BookmarkItem(
            id: UUID().uuidString,
            type: .academy,
            courseId: nil,
            academyId: academyId,
            createdAt: Date()
        )
        bookmarkedItems.append(bookmark)
        saveBookmarks()
    }
    
    private func removeBookmark(courseId: String){
        bookmarkedItems.removeAll{$0.courseId == courseId}
        saveBookmarks()
    }
    
    private func removeBookmark(academyId: String){
        bookmarkedItems.removeAll{$0.academyId == academyId}
        saveBookmarks()
    }
    
    func isBookmarked(courseId: String)->Bool{
        return bookmarkedItems.contains{
            $0.courseId == courseId
        }
    }
    
    func isBookmarked(academyId: String)->Bool{
        return bookmarkedItems.contains{
            $0.academyId == academyId
        }
    }
    
    // MARK: - 데이터 저장/불러오기
    private func saveBookmarks(){
        if let data = try? JSONEncoder().encode(bookmarkedItems){
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }
    
    private func loadBookmarks(){
        guard let data = UserDefaults.standard.data(forKey: bookmarksKey),
              let items = try? JSONDecoder().decode([BookmarkItem].self, from: data)else{return}
        bookmarkedItems = items
    }
}

