//
//  FilterView.swift
//  StudyFit
//


import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RecommendationViewModel
    @Environment(\.dismiss) private var dismiss
    
    // 임시 상태 (적용 버튼을 눌러야 실제 적용)
    @State private var tempSelectedSubject: Subject?
    @State private var tempSelectedDifficulty: Difficulty?
    @State private var tempSelectedPlatform: Platform?
    @State private var tempSortOption: RecommendationViewModel.SortOption
    
    init(viewModel: RecommendationViewModel){
        self.viewModel = viewModel
        self._tempSelectedSubject = State(initialValue: viewModel.selectedSubject)
        self._tempSelectedDifficulty = State(initialValue: viewModel.selectedDifficulty)
        self._tempSelectedPlatform = State(initialValue: viewModel.selectedPlatform)
        self._tempSortOption = State(initialValue: viewModel.sortOption)
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 24){
                    // 정렬 섹션
                    SortSection(selectedOption: $tempSortOption)
                    
                    // 과목 필터 섹션
                    SubjectFilterSection(selectedSubject: $tempSelectedSubject)
                    
                    // 난이도 필터 섹션
                    DifficultyFilterSection(selectedDifficulty: $tempSelectedDifficulty)
                    
                    // 플랫폼 필터 섹션
                    PlatformFilterSection(selectedPlatform: $tempSelectedPlatform)
                    
                    // 필터 요약
                    FilterSummarySection(
                        subject: tempSelectedSubject,
                        difficulty: tempSelectedDifficulty,
                        platform: tempSelectedPlatform,
                        sortOption: tempSortOption
                    )
                }
                .padding()
            }
            .navigationTitle("필터 및 정렬")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("취소"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("적용"){
                        applyFilters()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    Button("전체 초기화"){
                        resetAllFilters()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func applyFilters(){
        viewModel.selectedSubject = tempSelectedSubject
        viewModel.selectedDifficulty = tempSelectedDifficulty
        viewModel.selectedPlatform = tempSelectedPlatform
        viewModel.sortOption = tempSortOption
        viewModel.applySortAndFilter()
        
        print("필터 적용됨.")
        print("-  과목: \(tempSelectedSubject?.rawValue ?? "전체")")
        print("- 난이도: \(tempSelectedDifficulty?.rawValue ?? "전체")")
        print("- 플랫폼: \(tempSelectedPlatform?.rawValue ?? "전체")")
        print("- 정렬: \(tempSortOption.rawValue)")
    }
    
    private func resetAllFilters(){
        tempSelectedSubject = nil
        tempSelectedDifficulty = nil
        tempSelectedPlatform = nil
        tempSortOption = .rating
    }
    
}

// MARK: - 정렬 섹션
struct SortSection: View{
    @Binding var selectedOption: RecommendationViewModel.SortOption
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            Text("정렬 방식")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12){
                ForEach(RecommendationViewModel.SortOption.allCases, id: \.self){ option in
                    SortOptionCard(
                        option: option,
                        isSelected: selectedOption == option,
                        onTap: {
                            selectedOption = option
                        }
                    )
                }
            }
        }
    }
}

struct SortOptionCard: View {
    let option: RecommendationViewModel.SortOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            HStack{
                Image(systemName: option.systemImage)
                    .font(.title2)
                
                Text(option.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if isSelected{
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .foregroundColor(isSelected ? .blue : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 과목 필터 섹션
struct SubjectFilterSection: View {
    @Binding var selectedSubject: Subject?
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            HStack{
                Text("과목")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if selectedSubject != nil{
                    Button("해제"){
                        selectedSubject = nil
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8){
                ForEach(Subject.allCases, id: \.self){ subject in
                    SubjectChip(
                        subject: subject,
                        isSelected: selectedSubject == subject,
                        onTap: {
                            selectedSubject = selectedSubject == subject ? nil : subject
                        }
                    )
                }
            }
        }
    }
}

struct SubjectChip: View {
    let subject: Subject
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            VStack(spacing: 4){
                Image(systemName: subject.icon)
                    .font(.title2)
                
                Text(subject.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue :  Color.clear, lineWidth: 2)
            )
            .foregroundColor(isSelected ? .blue: .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 난이도 필터 섹션
struct DifficultyFilterSection: View {
    @Binding var selectedDifficulty: Difficulty?
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            HStack{
                Text("난이도")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if selectedDifficulty != nil{
                    Button("해제"){
                        selectedDifficulty = nil
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            HStack(spacing: 12){
                ForEach(Difficulty.allCases, id: \.self){ difficulty in
                    DifficultyChip(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty,
                        onTap: {
                            selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                        }
                    )
                }
            }
        }
    }
}

struct DifficultyChip: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            Text(difficulty.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.orange.opacity(0.2): Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.orange: Color.clear, lineWidth: 2)
                )
                .foregroundColor(isSelected ? .orange : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 플랫폼 필터 섹션
struct PlatformFilterSection: View {
    @Binding var selectedPlatform: Platform?
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            HStack{
                Text("플랫폼")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if selectedPlatform != nil{
                    Button("해제"){
                        selectedPlatform = nil
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8){
                ForEach(Platform.allCases, id: \.self){platform in
                    PlatformChip(
                        platform: platform,
                        isSelected: selectedPlatform == platform,
                        onTap: {
                            selectedPlatform = selectedPlatform == platform ? nil : platform
                        }
                    )
                }
            }
        }
    }
}


struct PlatformChip: View {
    let platform: Platform
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            Text(platform.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.green.opacity(0.1): Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                )
                .foregroundColor(isSelected ? .green : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 필터 요약 섹션
struct FilterSummarySection: View {
    let subject: Subject?
    let difficulty: Difficulty?
    let platform: Platform?
    let sortOption: RecommendationViewModel.SortOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("적용될 필터")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8){
                FilterSummaryRow(
                    title: "정렬",
                    value: sortOption.rawValue,
                    icon: sortOption.systemImage
                )
                
                FilterSummaryRow(
                    title: "과목",
                    value: subject?.rawValue ?? "전체",
                    icon: subject?.icon ?? "books.vertical"
                )
                
                FilterSummaryRow(
                    title: "난이도",
                    value: difficulty?.rawValue ?? "전체",
                    icon: "chart.bar.fill"
                )
                
                FilterSummaryRow(title: "플랫폼", value: platform?.rawValue ?? "전체", icon: "tv.fill"
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.05))
            )
        }
    }
}

struct FilterSummaryRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack{
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview{
    FilterView(viewModel: RecommendationViewModel())
}
