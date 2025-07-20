//
//  Course.swift
//  StudyFit
//

import Foundation

// MARK: - 인강 모델
struct Course: Identifiable, Codable, Hashable{
    let id: String
    let title: String
    let instructor: String
    let platform: Platform
    let subject: Subject
    let price: Int
    let originalPrice: Int?
    let rating: Double
    let reviewCount: Int
    let duration: String // "30시간", "15주" 등
    let difficulty: Difficulty
    let description: String
    let thumbnailURL: String
    let videoURL: String?
    let suitableFor: [StudyPersonalityType]
    let tags: [String]
    let isPopular: Bool
    let createdAt: Date
    
    // 할인율 계산
    var discountPercentage: Int?{
        guard let originalPrice = originalPrice, originalPrice > price else { return nil }
        return Int((Double(originalPrice - price) /  Double(originalPrice)) * 100)
    }
    
    // 가격 표시용 문자열
    var priceString: String{
        if price == 0{
            return "무료"
        }else{
            return "\(price.formatted())원"
        }
    }
}

// MARK: - 학원 모델
struct Academy: Identifiable, Codable, Hashable{
    let id: String
    let name: String
    let address: String
    let phoneNumber: String
    let latitude: Double
    let longitude: Double
    let rating : Double
    let reviewCount: Int
    let subjects: [Subject]
    let specialties: [String]
    let priceRange: String
    let description: String
    let imageURLs: [String]
    let workingHours: String
    let suitableFor: [StudyPersonalityType]
    let features: [String] // "소규모", "1:1 과외", "자율학습실"
    let distance: Double?
    
    // 거리 표시용 문자열
    var distanceString: String{
        guard let distance = distance else { return "거리 정보 없음" }
        if distance < 1{
            return String(format: "%.0fm", distance * 1000)
        }else{
            return String(format: "%.1fkm", distance)
        }
    }
}

// MARK: - 공통 열거형들
enum Platform: String, Codable, CaseIterable{
    case megastudy = "megastudy"
    case ebsi = "EBS"
    case etoos = "이투스"
    case daesung = "대성마이맥"
    case chunjae = "천재교육"
    case mathflat = "매스플랫"
    case other = "기타"
    
    var color: String{
        switch self {
        case .megastudy: return "#FF6B35"
        case .ebsi: return "#1E88E5"
        case .etoos: return "#43A047"
        case .daesung: return "#8E24AA"
        case .chunjae: return "#FB8C00"
        case .mathflat: return "#E91E63"
        case .other: return "#757575"
        }
    }
}

enum Subject: String, CaseIterable, Codable{
    case korean = "국어"
    case math = "수학"
    case english = "영어"
    case science = "과학"
    case socialStudies = "사회"
    case history = "한국사"
    case secondLanguage = "제2외국어"
    case art = "예체능"
    case all = "전과목"
    
    var icon: String{
        switch self{
        case .korean: return "textformat"
        case .math: return "function"
        case .english: return "globe"
        case .science: return "flask"
        case .socialStudies: return "building.columns"
        case .history: return "clock"
        case .secondLanguage: return "globe.asia.australia"
        case .art: return "paintbrush"
        case .all: return "books.vertical"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "기초"
    case intermediate = "중급"
    case advanced = "고급"
    case expert = "심화"
    
    var color: String {
        switch self {
        case .beginner: return "#4CAF50"
        case .intermediate: return "#FF9800"
        case .advanced: return "#F44336"
        case .expert: return "#9C27B0"
        }
    }
}

// MARK: - 찜하기 모델
struct BookmarkItem: Identifiable, Codable {
    let id: String
    let type: BookmarkType
    let courseId: String?
    let academyId: String?
    let createdAt: Date
}

enum BookmarkType: String, CaseIterable, Codable {
    case course = "course"
    case academy = "academy"
}
