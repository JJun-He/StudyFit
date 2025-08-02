//
//  BookmarkViewModel.swift
//  StudyFit
//


import Foundation

class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedCourses: [Course] = []
    @Published var bookmarkedAcademies: [Academy] = []
    @Published var isLoading = false
    @Published var selectedCategory: BookmarkCategory = .all
    
    private let recommendationService = RecommendationService()
    
    enum BookmarkCategory: String, CaseIterable{
        case all = "전체"
        case courses = "인강"
        case academies = "학원"
        
        var icon: String{
            switch self{
            case .all: return "heart.fill"
            case .courses: return "play.rectangle.fill"
            case .academies: return "building2.fill"
            }
        }
    }
    
    init(){
        loadBookmarks()
    }
    
    // MARK: - 북마크 로드
    func loadBookmarks(){
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.fetchBookmarkedItems()
            self.isLoading = false
        }
    }
    
    private func fetchBookmarkedItems(){
        let bookmarkedItems = recommendationService.bookmarkedItems
        
        // 북마크된 인강들 찾기
        let courseIds = bookmarkedItems.compactMap{$0.type == .course ? $0.courseId: nil}
        bookmarkedCourses = SampleData.courses.filter{courseIds.contains($0.id)}
        
        // 북마크된 학원들 찾기
        let academyIds = bookmarkedItems.compactMap{$0.type == .academy ? $0.academyId: nil}
        bookmarkedAcademies = SampleData.academies.filter{academyIds.contains($0.id)}
        
        print("북마크 로드 완료.")
        print("- 인강: \(bookmarkedCourses.count)개")
        print("- 학원: \(bookmarkedAcademies.count)개")
    }
    
    // MARK: - 북마크 제거
    func removeBookmark(courseId: String){
        recommendationService.toggleBookmark(courseId: courseId)
        bookmarkedCourses.removeAll{$0.id == courseId}
    }
    
    func removeBookmark(academyId: String){
        recommendationService.toggleBookmark(academyId: academyId)
        bookmarkedAcademies.removeAll{$0.id == academyId}
    }
    
    // MARK: - 전체 북마크 삭제
    func clearAllBookmarks(){
        // 모든 인강 북마크 제거
        for course in bookmarkedCourses{
            recommendationService.toggleBookmark(courseId: course.id)
        }
        
        // 모든 학원 북마크 제거
        for academy in bookmarkedAcademies{
            recommendationService.toggleBookmark(academyId: academy.id)
        }
        
        bookmarkedCourses.removeAll()
        bookmarkedAcademies.removeAll()
        
        print("모든 북마크가 삭제되었습니다.")
    }
    
    
    // MARK: - 통계
    var totalBookmarkedCount: Int{
        return bookmarkedCourses.count + bookmarkedAcademies.count
    }
    
    var hasBookmarks: Bool{
        return totalBookmarkedCount > 0
    }
    
    
}

