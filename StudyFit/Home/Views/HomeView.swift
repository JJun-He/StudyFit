//
//  HomeView.swift
//  StudyFit
//
//
//

import SwiftUI

struct HomeView: View {
    @State private var showingTest = false
    @State private var lastTestResult: StudyResult?
    @State private var testCount = 0
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 24){
                    // 헤더 섹션
                    HeaderSection()
                    
                    // 테스트 시작 섹션
                    TestStartSection(showingTest: $showingTest)
                    
                    // 이전 결과 섹션(있다면)
                    if let result = lastTestResult {
                        PreviousResultSection(result: result)
                    }
                    
                    // 앱 소개 섹션
                    AppIntroSection()
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("StudyFit")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingTest) {
            TestView()
        }
        .onAppear {
            loadUserData()
        }
        // 테스트 화면에서 돌아왔을 때 데이터 새로고침
        .refreshable {
            loadUserData()
        }
    }
    
    // 사용자 데이터 로드
    private func loadUserData() {
        lastTestResult = UserDefaultsManager.getLastTestResult()
        testCount = UserDefaultsManager.getTestCount()
        print("HomeView 데이터 로드: 마지막 결과 \(lastTestResult?.personalityType.displayName ?? "없음"), 총 \(testCount)회")
    }
}

// 통계 섹션
struct TestStatisticsSection: View{
    let testCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("나의 테스트 통계")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    Text("총 테스트 횟수")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(testCount)회")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button("기록 보기"){
                    // 나중에 구현: 전체 테스트 기록 보기
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.1))
        )
    }
}

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 16){
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("나만의 공부 스타일을 찾아보세요")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("15개의 간단한 질문으로 당신의 학습 성향으로 분석하고\n 맞춤형 공부법을 추천해드려요")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
}

struct TestStartSection: View {
    @Binding var showingTest: Bool
    
    var body: some View {
        VStack(spacing: 16){
            Text("성향 테스트 시작하기")
                .font(.headline)
                .fontWeight(.semibold)
            
            Button(action: {
                showingTest = true
            }){
                HStack{
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    
                    Text("테스트 시작")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            HStack{
                Label("약 3~5분 소요", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Label("15개 질문", systemImage: "questionmark.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct PreviousResultSection: View {
    let result: StudyResult
    @State private var showingResult = false
    @State private var showingRecommendations = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("이전 테스트 결과")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    Text("당신은 \(result.personalityType.displayName) 학습자")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(result.timeAgo) // 며칠 전인지 표시
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 8){
                    Button("자세히 보기"){
                        showingResult = true
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                    
                    Button("추천 보기"){
                        showingRecommendations = true
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.1))
        )
        .sheet(isPresented: $showingResult){
            ResultView(result: result)
        }
        .sheet(isPresented: $showingRecommendations){
            RecommendationView(personalityType: result.personalityType)
        }
    }
}

struct AppIntroSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Study Fit이 제공하는 서비스")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12){
                FeatureRow(icon: "person.fill.checkmark", title: "개인 맞춤 분석", description: "당신만의 학습 패턴을 정확히 파악")
                FeatureRow(icon: "lightbulb.fill", title: "학습법 추천", description: "성향에 맞는 효과적인 공부 방법 제시")
                FeatureRow(icon: "books.vertical.fill", title: "인강 추천", description: "맞춤형 강의 및 학원 정보 제공")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "학습 계획", description: "체계적인 학습 스케줄 가이드")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2){
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
}
#Preview {
    HomeView()
}
