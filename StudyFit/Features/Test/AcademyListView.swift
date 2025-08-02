//
//  AcademyListView.swift
//  StudyFit
//


import SwiftUI

struct AcademyListView: View {
    let academies: [Academy]
    @ObservedObject var viewModel: RecommendationViewModel
    
    var body: some View {
        if academies.isEmpty {
            EmptyStateView(icon: "building.2", title: "검색 결과 없습니다", message: "다른 검색이나 필터를 사용해보세요"
            )
        }else{
            ScrollView{
                LazyVStack(spacing: 16){
                    ForEach(academies){ academy in
                        AcademyCard(
                            academy: academy,
                            isBookmarked: viewModel.isBookmarked(academyId: academy.id),
                            onBookmarkTap: {
                                viewModel.toggleBookmark(for: academy)
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct AcademyCard: View {
    let academy: Academy
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            // 상단: 학원명과 북마크
            HStack{
                Text(academy.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: onBookmarkTap){
                    Image(systemName: isBookmarked ? "heart.fill" : "heart")
                        .foregroundColor(isBookmarked ? .red : .gray)
                        .font(.title2)
                }
            }
            
            // 주소
            HStack{
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(academy.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if let distance = academy.distance {
                    Spacer()
                    Text(academy.distanceString)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            // 전문 분야
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 6){
                    ForEach(academy.specialties.prefix(3), id: \.self){ speciality in
                        Text(speciality)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
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
                    Text(String(format: "%.1f", academy.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Text("(\(academy.reviewCount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(academy.priceRange)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail){
            AcademyDetailView(academy: academy)
        }
    }
}

#Preview {
    AcademyListView(academies: SampleData.academies, viewModel: RecommendationViewModel())
}
