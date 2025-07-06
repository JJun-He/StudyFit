//
//  TestView.swift
//  StudyFit
//
//
//

import SwiftUI

struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                if viewModel.isLoading {
                    ProgressView("로딩 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }else if viewModel.isTestCompleted {
                    // 테스트 완료 화면
                    TestCompletedView(result: viewModel.testResult)
                }else if let currentQuestion = viewModel.currentQuestion {
                    // 테스트 진행 화면
                    TestProgressView(progress: viewModel.progress, currentQuestion: viewModel.currentQuestionIndex, totalQuestions: viewModel.questions.count).padding(.top)
                    
                    QuestionView(question: currentQuestion, selectedAnswer: .constant(viewModel.getAnswer(for: currentQuestion.id))
                    ){
                        answer in viewModel.selectAnswer(answer)
                    }
                    
                    Spacer()
                    
                    // 네비게이션 버튼들
                    HStack{
                        if viewModel.canGoPrevious {
                            Button("이전"){
                                viewModel.previousQuestion()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Spacer()
                        
                        if viewModel.canGoNext {
                            Button("다음"){
                                viewModel.nextQuestion()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("성향 테스트")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("닫기"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TestCompletedView: View {
    let result: StudyResult?
    
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("테스트가 완료!")
                .font(.title)
                .fontWeight(.bold)
            
            if let result = result {
                Text("당신은 \(result.personalityType.displayName) 학습자입니다")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Text(result.personalityType.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button("결과 자세히 보기"){
                // 결과 화면으로 이동
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        
    }
}

#Preview {
    TestView()
}
