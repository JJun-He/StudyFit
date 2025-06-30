//
//  TestProgressView.swift
//  StudyFit
//
//
//

import SwiftUI

struct TestProgressView: View {
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 8){
            HStack{
                Text("질문\(currentQuestion + 1)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(totalQuestions)개 중")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // 진행률 바
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x:1, y:2, anchor: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    TestProgressView(progress: 0.4, currentQuestion: 5, totalQuestions: 15)
}
