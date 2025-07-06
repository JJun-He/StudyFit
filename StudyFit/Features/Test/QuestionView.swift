//
//  QuestionView.swift
//  StudyFit
//
//
//


import SwiftUI

struct QuestionView: View{
    let question: Question
    @Binding var selectedAnswer: String?
    let onAnswerSelected: ((String) -> Void)? // 콜백 추가
    
    var body: some View{
        VStack(alignment: .leading, spacing: 24){
            // 질문 텍스트
            Text(question.text)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            
            // 답변 옵션들
            LazyVStack(spacing: 12){
                ForEach(question.options, id:\.self){option in
                    AnswerOptionView(
                        text: option,
                        isSelected: selectedAnswer == option,
                        action: {
                            selectedAnswer = option
                            onAnswerSelected?(option) // 콜백 호출
                        }
                    )
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
    }
}

struct AnswerOptionView: View{
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View{
        Button(action: action){
            HStack{
                Text(text)
                    .font(.body)
                    .foregroundColor(isSelected ? .white: .primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isSelected{
                    Image(systemName: "checkmark.cirle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue: Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue: Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuestionView(question: Question.sampleQuestions[0], selectedAnswer: .constant(nil),
                 onAnswerSelected: {answer in
        print("Preview에서 선택된 답변: \(answer)")
    }
 )
}
