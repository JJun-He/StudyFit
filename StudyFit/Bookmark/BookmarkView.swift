//
//  BookmarkView.swift
//  StudyFit
//

import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                if viewModel.isLoading {
                    // 로딩 상태
                    LoadingBookmarkView()
                }else if !viewModel.hasBookmarks{
                    // 빈 상태
                    EmptyBookmarkView()
                }else{
                    // 북마크 컨텐츠
                    BookmarkCategorySelector(viewModel: viewModel)
                    
                    // 통계 정보
                    BookmarkStatsView(viewModel: viewModel)
                    
                    // 북마크 리스트
                    BookmarkContentView(viewModel: viewModel)
                }
            }
        }
        .navigationTitle("찜한 목록")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Menu{
                    Button("새로고침"){
                        viewModel.loadBookmarks()
                    }
                    
                    if viewModel.hasBookmarks{
                        Divider()
                        
                        Button("전체 삭제", role: .destructive){
                            showingClearConfirmation = true
                        }
                    }
                }label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .refreshable{
            viewModel.loadBookmarks()
        }
        .alert("모든 북마크 삭제", isPresented: $showingClearConfirmation){
            Button("취소", role: .cancel){}
            Button("삭제", role: .destructive){
                viewModel.clearAllBookmarks()
            }
        }message: {
            Text("찜한 모든 인강과 학원이 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
        }
        .onAppear{
            viewModel.loadBookmarks()
        }
    }
}

// MARK: - 로딩 뷰
struct LoadingBookmarkView: View {
    var body: some View{
        VStack(spacing: 16){
            ProgressView()
                .scaleEffect(1.2)
            
            Text("찜한 목록을 불러오는 중...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 빈 상태 뷰
struct EmptyBookmarkView: View {
    var body: some View{
        VStack(spacing: 24){
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8){
                Text("아직 찜한 항목이 없어요")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("마음에 드는 인강이나 학원을\n버튼을 눌러 저장해보세요")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            NavigationLink("추천 강의 둘러보기"){
                RecommendationView(personalityType: nil)
            }
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 카테고리 선택기
struct BookmarkCategorySelector: View {
    @ObservedObject var viewModel: BookmarkViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 12){
                ForEach(BookmarkViewModel.BookmarkCategory.allCases, id: \.self){ category in
                    CategoryChip(
                        category: category,
                        isSelected: viewModel.selectedCategory == category,
                        count: getCategoryCount(category),
                        onTap: {
                            viewModel.selectedCategory = category
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private func getCategoryCount(_ category: BookmarkViewModel.BookmarkCategory) -> Int {
        switch category{
        case .all:
            return viewModel.totalBookmarkedCount
        case .courses:
            return viewModel.bookmarkedCourses.count
        case .academies:
            return viewModel.bookmarkedAcademies.count
        }
    }
}


struct CategoryChip: View{
    let category: BookmarkViewModel.BookmarkCategory
    let isSelected: Bool
    let count: Int
    let onTap: () -> Void
    
    var body: some View{
        Button(action: onTap){
            HStack(spacing: 6){
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("(\(count))")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.15))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 통계 뷰
struct BookmarkStatsView: View{
    @ObservedObject var viewModel: BookmarkViewModel
    
    var body: some View{
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text("총\(viewModel.totalBookmarkedCount)개의 항목을 찜했어요")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("인강\(viewModel.bookmarkedCourses.count)개, 학원\(viewModel.bookmarkedAcademies.count)개")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .padding(.vertical, 12)
    }
}

// MARK: - 북마크 컨텐츠 뷰
struct BookmarkContentView: View{
    @ObservedObject var viewModel: BookmarkViewModel
    
    var body: some View{
        ScrollView{
            LazyVStack(spacing: 16){
                switch viewModel.selectedCategory {
                case .all:
                    // 인강 섹션
                    if !viewModel.bookmarkedCourses.isEmpty{
                        BookmarkSectionHeader(title: "찜한 인강", count : viewModel.bookmarkedCourses.count)
                        
                        ForEach(viewModel.bookmarkedCourses){course in
                            BookmarkedCourseCard(
                                course : course,
                                onRemove: {
                                    viewModel.removeBookmark(courseId: course.id)
                                }
                            )
                        }
                    }
                    
                    // 학원 섹션
                    if !viewModel.bookmarkedAcademies.isEmpty{
                        BookmarkSectionHeader(title: "찜한 학원", count : viewModel.bookmarkedAcademies.count)
                        
                        ForEach(viewModel.bookmarkedAcademies){academy in
                            BookmarkedAcademyCard(
                                academy: academy,
                                onRemove: {
                                    viewModel.removeBookmark(academyId: academy.id)
                                }
                            )
                        }
                    }
                case .courses:
                    ForEach(viewModel.bookmarkedCourses){course in
                        BookmarkedCourseCard(
                            course: course,
                            onRemove: {
                                viewModel.removeBookmark(courseId: course.id)
                            }
                        )
                    }
                case .academies:
                    ForEach(viewModel.bookmarkedAcademies){academy in
                        BookmarkedAcademyCard(
                            academy: academy,
                            onRemove: {
                                viewModel.removeBookmark(academyId: academy.id)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
    }
}

struct BookmarkSectionHeader: View{
    let title: String
    let count: Int
    
    var body: some View{
        HStack{
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("(\(count))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.top, 8)
    }
}

#Preview {
    BookmarkView()
}
