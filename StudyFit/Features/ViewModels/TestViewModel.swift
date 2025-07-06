//
//  TestViewModel.swift
//  StudyFit
//
//
//

import Foundation
import Combine

class TestViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex = 0
    @Published var answers: [Int: String] = [:] // 질문 ID: 선택한 답변
    @Published var isTestCompleted = false
    @Published var testResult: StudyResult?
    @Published var isLoading = false
    
    // 계산 속성들
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    var canGoNext: Bool {
        guard let currentQuestion = currentQuestion else { return false }
        return answers[currentQuestion.id] != nil
    }
    
    var canGoPrevious: Bool {
        return currentQuestionIndex > 0
    }
    
    var isFirstQuestion: Bool {
        return currentQuestionIndex == 0
    }
    
    var isLastQuestion: Bool {
        return currentQuestionIndex == questions.count - 1
    }
    
    init() {
        loadQuestions()
    }
    
    // MARK: - 질문 로드
    func loadQuestions() {
        isLoading = true
        // 실제로는 API나 로컬 파일에서 로드하겠지만, 지금은 샘플 데이터 사용
        questions = Question.sampleQuestions
        isLoading = false
    }
    
    // MARK: - 답변 선택
    func selectAnswer(_ answer:String){
        guard let currentQuestion = currentQuestion else { return }
        answers[currentQuestion.id] = answer
        
        // 답변 선택 후 약간의 지연 후 자동으로 다음 질문으로
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextQuestion()
        }
    }
    
    // MARK: -네비게이션
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }else{
            completeTest()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    // MARK: - 테스트 완료
    private func completeTest() {
        isLoading = true
        
        // 실제로는 서버에서 분석하겠지만, 지금은 로컬에서 계산
        let result = calculateTestResult()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.testResult = result
            self.isTestCompleted = true
            self.isLoading = false
        }
    }
    
    // MARK: -점수 계산 로직
    private func calculateTestResult() -> StudyResult {
        var scores: [String: Int] = [
            "examFocused": 0,
            "conceptMaster": 0,
            "problemSolver": 0,
            "steady": 0,
            "intensive": 0
        ]
        
        // 각 답변에 대한 점수 계산
        for(questionId, answer) in answers {
            if let question = questions.first(where: {$0.id == questionId}),
               let scoreMap = question.scoringMap[answer] {
                for(type, score) in scoreMap {
                    scores[type, default: 0] += score
                }
            }
        }
        
        let personalityType = StudyResult.calculatePersonalityType(from: scores)
        let recommendations = personalityType.studyMethods
        
        return StudyResult(personalityType: personalityType, score: scores, recommendations: recommendations, timestamp: Date()
        )
    }
    
    // MARK: - 테스트 리셋
    func resetTest() {
        currentQuestionIndex = 0
        answers.removeAll()
        isTestCompleted = false
        testResult = nil
        isLoading = false
    }
    
    // MARK: - 특정 질문으로 이동
    func goToQuestion(at index: Int) {
        guard index >= 0 && index < questions.count else { return }
        currentQuestionIndex = index
    }
    
    // MARK: - 답변 상태 체크
    func isAnswered(questionId: Int) -> Bool{
        return answers[questionId] != nil
    }
    
    func getAnswer(for questionId: Int) -> String? {
        return answers[questionId]
    }
}

