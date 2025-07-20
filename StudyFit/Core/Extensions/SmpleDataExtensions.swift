//
//  SmpleDataExtensions.swift
//  StudyFit
//

import Foundation

extension SampleData {
    
    // MARK: - 성향별 데이터 필터링
    static func getCourses(for personalityType: StudyPersonalityType) -> [Course]{
        return courses.filter{course in
            course.suitableFor.contains(personalityType)
        }.sorted{ lhs, rhs in
            // 평점과 리뷰 수를 종합한 점수로 정렬
            let lhsScore = lhs.rating * Double(lhs.reviewCount) * 0.001
            let rhsScore = rhs.rating * Double(rhs.reviewCount) * 0.001
            return lhsScore > rhsScore
        }
    }
    
    static func getAcademies(for personalityType: StudyPersonalityType) -> [Academy]{
        return academies.filter{academy in
            academy.suitableFor.contains(personalityType)
        }.sorted{ $0.rating > $1.rating }
    }
    
    // MARK: - 과목별 필터링
    static func getCourses(for subject: Subject) -> [Course]{
        return courses.filter{$0.subject == subject || $0.subject == .all}
    }
    
    // MARK: - 인기 강의
    static var popularCourses: [Course]{
        return courses.filter{$0.isPopular}.sorted{ $0.reviewCount > $1.reviewCount}
    }
    
    // MARK: - 무료 강의
    static var freeCourses: [Course]{
        return courses.filter{$0.price == 0}
    }
    
    // MARK: - 할인 강의
    static var discountedCourses: [Course]{
        return courses.filter{$0.discountPercentage != nil}.sorted{lhs, rhs in
            (lhs.discountPercentage ?? 0) > (rhs.discountPercentage ?? 0)
        }
    }
    
    // MARK: - 검색 기능
    static func searchCourses(keyword: String) -> [Course]{
        let lowercasedKeyword = keyword.lowercased()
        return courses.filter{ course in
            course.title.lowercased().contains(lowercasedKeyword) ||
            course.instructor.lowercased().contains(lowercasedKeyword) ||
            course.tags.contains{$0.lowercased().contains(lowercasedKeyword)}
        }
    }
    
    static func searchAcademies(keyword: String) -> [Academy]{
        let lowercasedKeyword = keyword.lowercased()
        return academies.filter{ academy in
            academy.name.lowercased().contains(lowercasedKeyword) ||
            academy.address.lowercased().contains(lowercasedKeyword) ||
            academy.specialties.contains{$0.lowercased().contains(lowercasedKeyword)}
        }
    }
    
    // MARK: - 통계 정보
    static var courseStatistics: (total: Int, subjects: [Subject: Int], platforms: [Platform: Int]){
        let total = courses.count
        
        var subjectCount: [Subject: Int] = [:]
        var platformCount: [Platform: Int] = [:]
        
        for course in courses{
            subjectCount[course.subject, default: 0] += 1
            platformCount[course.platform, default: 0] += 1
        }
        
        return (total, subjectCount, platformCount)
    }
    
}
