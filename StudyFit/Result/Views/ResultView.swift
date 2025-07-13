//
//  ResultView.swift
//  StudyFit
//
//  Created by 임뚱보 on 6/15/25.
//

import SwiftUI
struct ResultView: View {
    let result: StudyResult
    @Environment(\.dismiss) private var dismiss
    @State private var showingScoreDetails = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 24){
                    // 헤더 섹션
                    ResultHeaderSection(personalityType: result.personalityType)
                    
                    // 성향 설명 섹션
                    PersonalityDescriptionSection(personalityType: result.personalityType)
                    
                    // 점수 차트 섹션
                    ScoreChartSection(
                        scores: result.score,
                        personalityType: result.personalityType,
                        showingDetails: $showingScoreDetails
                    )
                    
                    // 추천 학습법 섹션
                    RecommendedStudyMethodsSection(
                        personalityType: result.personalityType
                    )
                    
                    // 추천 시간대 섹션
                    RecommendedTimeSection(personalityType: result.personalityType)
                    
                    // 액션 버튼들
                    ActionButtonsSection()
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("테스트 결과")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ResultHeaderSection: View {
    let personalityType: StudyPersonalityType
    
    var body: some View {
        VStack(spacing: 16){
            // 성향 아이콘
            Image(systemName: personalityTypeIcon(personalityType))
                .font(.system(size: 60))
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .fill(personalityTypeColor(personalityType))
                )
            
            Text("당신은")
                .font(.title2)
                .foregroundColor(.secondary)
                
            Text(personalityType.displayName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(personalityTypeColor(personalityType))
            
            Text("학습자입니다!")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(personalityTypeColor(personalityType).opacity(0.1))
        )
    }
}

struct PersonalityDescriptionSection: View {
    let personalityType: StudyPersonalityType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("성향 분석")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(personalityType.description)
                .font(.body)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ScoreChartSection: View {
    let scores: [String: Int]
    let personalityType: StudyPersonalityType
    @Binding var showingDetails: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("성향별 점수")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("자세히 보기") {
                    showingDetails = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // 점수 바 차트
            VStack(spacing: 12) {
                ForEach(StudyPersonalityType.allCases, id: \.self) { type in
                    ScoreBarView(
                        type: type,
                        score: scores[type.rawValue] ?? 0,
                        maxScore: scores.values.max() ?? 1,
                        isHighlighted: type == personalityType
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ScoreBarView: View {
    let type: StudyPersonalityType
    let score: Int
    let maxScore: Int
    let isHighlighted: Bool
    
    var body: some View {
        HStack{
            Text(type.displayName)
                .font(.subheadline)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundColor(isHighlighted ? personalityTypeColor(type) : .primary)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader{geometry in
                HStack(spacing: 0){
                    Rectangle()
                        .fill(personalityTypeColor(type))
                        .frame(width: geometry.size.width * (Double(score) / Double(maxScore)))
                        .animation(.easeInOut(duration: 0.8), value: score)
                    
                    Spacer()
                }
            }
            .frame(height: 8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(4)
            
            Text("\(score)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isHighlighted ? personalityTypeColor(type) : .secondary)
                .frame(width: 20, alignment: .trailing)
        }
    }
}

struct RecommendedStudyMethodsSection: View {
    let personalityType: StudyPersonalityType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("추천 학습법")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12){
                ForEach(Array(personalityType.studyMethods.enumerated()), id: \.offset){ index, method in
                    StudyMethodCard(method: method, index: index)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
}

struct StudyMethodCard: View {
    let method: String
    let index: Int
    
    var body: some View {
        HStack(spacing: 12){
            Text("\(index + 1)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.blue))
            
            Text(method)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.orange)
                .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
    }
}

struct RecommendedTimeSection: View {
    let personalityType: StudyPersonalityType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("추천 학습 시간")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(alignment: .center, spacing: 12){
                Image(systemName: "clock.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text(personalityType.recommendedStudyTime)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.1))
        )
    }
}

struct ActionButtonsSection: View {
    var body: some View {
        VStack(spacing: 12){
            Button(action:{
                // 추천 인강/ 학원 보기
            }){
                HStack{
                    Image(systemName: "book.fill")
                    Text("맞춤 인강/ 학원 보기")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            HStack(spacing: 12){
                Button(action: {
                    // 결과 공유하기
                }){
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                        Text("결과 공유")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
                
                Button(action:{
                    // 다시 테스트하기
                }){
                    HStack{
                        Image(systemName: "arrow.clockwise")
                        Text("다시 테스트")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }
            
        }
    }
}

// MARK: - 헬퍼 함수들
func personalityTypeColor(_ type: StudyPersonalityType) -> Color {
    switch type {
    case .examFocused: return .red
    case .conceptMaster: return .blue
    case .problemSolver: return .green
    case .steady: return .purple
    case .intensive: return .orange
    }
}

func personalityTypeIcon(_ type: StudyPersonalityType) -> String {
    switch type{
    case .examFocused: return "checkmark.seal.fill"
    case .conceptMaster: return "lightbulb.fill"
    case .problemSolver: return "wrench.and.screwdriver.fill"
    case .steady: return "calendar.badge.plus"
    case .intensive: return "flame.fill"
    }
}

#Preview {
    ResultView(result: StudyResult(
        personalityType: .conceptMaster,
        score: [
            "examFocused": 5,
            "conceptMaster": 12,
            "problemSolver": 8,
            "steady": 7,
            "intensive": 3
        ],
        recommendations: StudyPersonalityType.conceptMaster.studyMethods,
        timestamp: Date()
    )
 )
}
