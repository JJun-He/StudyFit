import SwiftUI

// MARK: - 북마크된 인강 카드
struct BookmarkedCourseCard: View {
    let course: Course
    let onRemove: () -> Void
    @State private var showingDetail = false
    @State private var showingRemoveConfirmation = false
    
    var body: some View {
        HStack(spacing: 12) {
            // 썸네일 (임시)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: "play.rectangle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                )
            
            // 콘텐츠
            VStack(alignment: .leading, spacing: 4) {
                // 플랫폼
                Text(course.platform.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                // 제목
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                // 강사
                Text(course.instructor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 평점과 가격
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
            
            // 액션 버튼들
            VStack(spacing: 8) {
                Button(action: {
                    showingRemoveConfirmation = true
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                
                Button(action: {
                    showingDetail = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .sheet(isPresented: $showingDetail) {
            CourseDetailView(course: course)
        }
        .alert("찜 해제", isPresented: $showingRemoveConfirmation) {
            Button("취소", role: .cancel) { }
            Button("해제", role: .destructive) {
                withAnimation(.easeInOut) {
                    onRemove()
                }
            }
        } message: {
            Text("이 인강을 찜 목록에서 제거하시겠습니까?")
        }
    }
}

// MARK: - 북마크된 학원 카드
struct BookmarkedAcademyCard: View {
    let academy: Academy
    let onRemove: () -> Void
    @State private var showingDetail = false
    @State private var showingRemoveConfirmation = false
    
    var body: some View {
        HStack(spacing: 12) {
            // 썸네일 (임시)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.2))
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                )
            
            // 콘텐츠
            VStack(alignment: .leading, spacing: 4) {
                // 학원명
                Text(academy.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                // 주소
                Text(academy.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // 전문 분야
                HStack {
                    ForEach(academy.specialties.prefix(2), id: \.self) { specialty in
                        Text(specialty)
                            .font(.caption2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(3)
                    }
                    
                    if academy.specialties.count > 2 {
                        Text("+\(academy.specialties.count - 2)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // 평점과 거리
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption2)
                        Text(String(format: "%.1f", academy.rating))
                            .font(.caption2)
                    }
                    
                    Spacer()
                    
                    if let distance = academy.distance {
                        Text(academy.distanceString)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // 액션 버튼들
            VStack(spacing: 8) {
                Button(action: {
                    showingRemoveConfirmation = true
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                
                Button(action: {
                    showingDetail = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .sheet(isPresented: $showingDetail) {
            AcademyDetailView(academy: academy)
        }
        .alert("찜 해제", isPresented: $showingRemoveConfirmation) {
            Button("취소", role: .cancel) { }
            Button("해제", role: .destructive) {
                withAnimation(.easeInOut) {
                    onRemove()
                }
            }
        } message: {
            Text("이 학원을 찜 목록에서 제거하시겠습니까?")
        }
    }
}

#Preview {
    VStack {
        BookmarkedCourseCard(
            course: SampleData.courses[0],
            onRemove: { print("Remove course") }
        )
        
        BookmarkedAcademyCard(
            academy: SampleData.academies[0],
            onRemove: { print("Remove academy") }
        )
    }
    .padding()
}
