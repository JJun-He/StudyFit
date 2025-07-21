//
//  CourseListView.swift
//  StudyFit
//


import SwiftUI

struct CourseListView: View {
    let courses: [Course]
    @ObservedObject var viewModel: RecommendationViewModel
    
    var body: some View {
        if courses.isEmpty{
            EmptyStateView(
                icon: "book.closed",
                title: "검색 결과가 없습니다",
                message: "다른 검색어나 필터를 사용해보세요"
            )
        }else{
            ScrollView{
                LazyVStack(spacing: 16){
                    ForEach(courses){ course in
                        CourseCard(
                            course: course,
                            isBookmarked: viewModel.isBookmarked(courseId: course.id),
                            onBookmarkTap: {
                                viewModel.toggleBookmark(for: course)
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct CourseCard: View {
    let course: Course
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            // 상단: 플랫폼과 북마크
            HStack{
                Text(course.platform.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                
                Spacer()
                
                Button(action: onBookmarkTap){
                    Image(systemName: isBookmarked ? "heart.fill": "heart")
                        .foregroundColor(isBookmarked ? .red : .gray)
                        .font(.title2)
                }
            }
            
            // 제목과 강사
            VStack(alignment: .leading, spacing: 4){
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(course.instructor)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // 태그들
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 6){
                    ForEach(course.tags.prefix(4), id: \.self){ tag in
                        Text("#\(tag)")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            
            // 평점과 리뷰
            HStack{
                HStack(spacing: 2){
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text(String(format: "%.1f", course.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Text("(\(course.reviewCount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(course.duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text(course.difficulty.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .cornerRadius(4)
            }
            
            // 가격
            HStack{
                if let originalPrice = course.originalPrice, originalPrice > course.price {
                    Text("\(originalPrice.formatted())원")
                        .font(.caption)
                        .strikethrough()
                        .foregroundColor(.secondary)
                    
                    Text("\(course.discountPercentage ?? 0)% 할인")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Text(course.priceString)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(course.price ==  0 ? .green : .primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 2, x:0, y:1)
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail){
            // CourseDetailView(course: course)
        }
    }
    

}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16){
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}


#Preview {
    CourseListView(
        courses: SampleData.courses, viewModel: RecommendationViewModel()
    )
}
