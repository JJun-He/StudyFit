//
//  RecommendationTestView.swift
//  StudyFit
//


import SwiftUI

struct RecommendationTestView: View {
    @StateObject private var recommendationService = RecommendationService()
    
    
    var body: some View {
        
        NavigationView{
            List{
                Section("성향별 테스트"){
                    ForEach(StudyPersonalityType.allCases){type in
                        Button(type.displayName){
                            recommendationService.loadRecommendations(for: type)
                        }
                    }
                }
                
                Section("추천 인강 (\(recommendationService.recommendedCourses.count)개"){
                    ForEach(recommendationService.recommendedCourses){course in
                        VStack(alignment: .leading){
                            Text(course.title)
                                .font(.headline)
                            Text("\(course.instructor) * \(course.platform.rawValue)")
                                .font(.caption)
                            Text(course.priceString)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section("추천 학원 (\(recommendationService.recommendedAcademies.count)개"){
                    ForEach(recommendationService.recommendedAcademies){academy in
                        VStack(alignment: .leading){
                            Text(academy.name)
                                .font(.headline)
                            Text(academy.address)
                                .font(.caption)
                            Text(academy.priceRange)
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("추천 시스템 테스트")
        }
    }
}

#Preview {
    RecommendationTestView()
}

