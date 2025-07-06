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
            loadLastTestResult()
        }
    }
    
    private func loadLastTestResult() {
        // User Defaults에서 마지막 테스트 결과 로드
        // 나중에 구현
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
                    
                    Text(DateFormatter.localizedString(from: result.timestamp, dateStyle: .medium, timeStyle: .none))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button("자세히 보기"){
                    // 결과 화면으로 이동
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.1))
        )
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
