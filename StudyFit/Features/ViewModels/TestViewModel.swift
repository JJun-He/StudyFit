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
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        questions = Question.sampleQuestions
    }
    
    func selectAnswer(_ answer:String){
        guard let currentQuestion = currentQuestion else { return }
        answers[currentQuestion.id] = answer
    }
    
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
    
    private func completeTest() {
        let result = calculateTestResult()
        testResult = result
        isTestCompleted = true
    }
    
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
    
    func resetTest() {
        currentQuestionIndex = 0
        answers.removeAll()
        isTestCompleted = false
        testResult = nil
    }
}

