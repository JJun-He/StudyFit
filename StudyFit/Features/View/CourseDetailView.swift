
import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @Environment(\.dismiss) private var dismiss
    @StateObject private var recommendationService = RecommendationService()
    @State private var showingVideoPlayer = false
    @State private var isBookmarked = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 상단 이미지/비디오 섹션
                    CourseHeaderSection(
                        course: course,
                        showingVideoPlayer: $showingVideoPlayer
                    )
                    
                    VStack(spacing: 24) {
                        // 기본 정보 섹션
                        CourseInfoSection(course: course)
                        
                        // 가격 정보 섹션
                        CoursePriceSection(course: course)
                        
                        // 태그 섹션
                        CourseTagsSection(course: course)
                        
                        // 상세 설명 섹션
                        CourseDescriptionSection(course: course)
                        
                        // 강사 정보 섹션
                        InstructorInfoSection(course: course)
                        
                        // 적합한 성향 섹션
                        SuitablePersonalitySection(course: course)
                        
                        // 관련 강의 섹션
                        RelatedCoursesSection(course: course)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(systemName: isBookmarked ? "heart.fill" : "heart")
                            .foregroundColor(isBookmarked ? .red : .gray)
                    }
                }
            }
            .onAppear {
                isBookmarked = recommendationService.isBookmarked(courseId: course.id)
            }
        }
        .sheet(isPresented: $showingVideoPlayer) {
            VideoPlayerView(videoURL: course.videoURL)
        }
    }
    
    private func toggleBookmark() {
        recommendationService.toggleBookmark(courseId: course.id)
        isBookmarked.toggle()
    }
}

// MARK: - 상단 헤더 섹션
struct CourseHeaderSection: View {
    let course: Course
    @Binding var showingVideoPlayer: Bool
    
    var body: some View {
        ZStack {
            // 배경 이미지
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            VStack(spacing: 12) {
                // 플랫폼 배지
                Text(course.platform.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                
                // 제목
                Text(course.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 강사명
                Text(course.instructor)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                // 재생 버튼 (비디오가 있을 경우)
                if course.videoURL != nil {
                    Button(action: {
                        showingVideoPlayer = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("미리보기")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

// MARK: - 기본 정보 섹션
struct CourseInfoSection: View {
    let course: Course
    
    var body: some View {
        HStack {
            // 평점
            VStack(alignment: .leading, spacing: 4) {
                Text("평점")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    
                    Text(String(format: "%.1f", course.rating))
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("(\(course.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // 수강 시간
            VStack(alignment: .center, spacing: 4) {
                Text("수강시간")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(course.duration)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // 난이도
            VStack(alignment: .trailing, spacing: 4) {
                Text("난이도")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(course.difficulty.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(6)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// MARK: - 가격 정보 섹션
struct CoursePriceSection: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("수강료")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                if let originalPrice = course.originalPrice, originalPrice > course.price {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(originalPrice.formatted())원")
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(course.priceString)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(course.price == 0 ? .green : .primary)
                            
                            Text("\(course.discountPercentage ?? 0)% 할인")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(4)
                        }
                    }
                } else {
                    Text(course.priceString)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(course.price == 0 ? .green : .primary)
                }
                
                Spacer()
                
                Button("수강신청") {
                    // 수강신청 기능 (나중에 구현)
                    print("🎓 \(course.title) 수강신청")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.05))
        )
    }
}

// MARK: - 태그 섹션
struct CourseTagsSection: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("강의 특징")
                .font(.headline)
                .fontWeight(.semibold)
            
            FlexibleView(
                data: course.tags,
                spacing: 8,
                alignment: .leading
            ) { tag in
                Text("#\(tag)")
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
            }
        }
    }
}

// MARK: - 설명 섹션
struct CourseDescriptionSection: View {
    let course: Course
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("강의 소개")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(course.description)
                .font(.body)
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil : 3)
            
            Button(isExpanded ? "접기" : "더보기") {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
    }
}

// MARK: - 강사 정보 섹션
struct InstructorInfoSection: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("강사 정보")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                // 강사 프로필 이미지 (임시)
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(course.instructor.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.instructor)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("\(course.subject.rawValue) 전문 강사")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

// MARK: - 적합한 성향 섹션
struct SuitablePersonalitySection: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("이런 학습자에게 추천")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(course.suitableFor, id: \.self) { type in
                    HStack {
                        Image(systemName: personalityTypeIcon(type))
                            .foregroundColor(personalityTypeColor(type))
                            .font(.title3)
                        
                        Text(type.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(personalityTypeColor(type).opacity(0.1))
                    )
                }
            }
        }
    }
}

// MARK: - 관련 강의 섹션
struct RelatedCoursesSection: View {
    let course: Course
    
    var relatedCourses: [Course] {
        Array(SampleData.courses.filter { $0.subject == course.subject && $0.id != course.id }.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("관련 강의")
                .font(.headline)
                .fontWeight(.semibold)
            
            if relatedCourses.isEmpty {
                Text("관련 강의가 없습니다")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(relatedCourses), id: \.id) { relatedCourse in
                            RelatedCourseCard(course: relatedCourse)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct RelatedCourseCard: View {
    let course: Course
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text(course.instructor)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.caption2)
                    Text(String(format: "%.1f", course.rating))
                        .font(.caption2)
                }
                
                Spacer()
                
                Text(course.priceString)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(width: 150)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            CourseDetailView(course: course)
        }
    }
}

// MARK: - 유연한 태그 레이아웃
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0

    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }

            FlexibleViewContent(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct FlexibleViewContent<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }

    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }

            remainingWidth -= (elementSize.width + spacing)
        }

        return rows
    }
}

// MARK: - 사이즈 읽기 도우미
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - 비디오 플레이어 (임시)
struct VideoPlayerView: View {
    let videoURL: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("비디오 플레이어")
                    .font(.title)
                
                Text("미리보기 영상")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("미리보기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CourseDetailView(course: SampleData.courses[0])
}
