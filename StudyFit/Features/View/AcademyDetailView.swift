//
//  AcademyDetailView.swift
//  StudyFit
//

import SwiftUI

struct AcademyDetailView: View {
    let academy: Academy
    @Environment(\.dismiss) private var dismiss
    @StateObject private var recommendationService = RecommendationService()
    @State private var isBookmarked = false
    @State private var selectedImageIndex = 0
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 0){
                    // 상단 이미지 섹션
                    AcademyHeaderSection(
                        academy: academy,
                        selectedImageIndex: $selectedImageIndex
                    )
                    
                    VStack(spacing: 24){
                        // 기본 정보 섹션
                        AcademyInfoSection(academy: academy)
                        
                        // 연락처 및 위치 섹션
                        AcademyContactSection(academy: academy)
                        
                        // 전문 분야 섹션
                        AcademySpecialitiesSection(academy: academy)
                        
                        // 상세 설명 섹션
                        AcademyDescriptionSection(academy: academy)
                        
                        // 특징 섹션
                        AcademyFeaturesSection(academy: academy)
                        
                        // 적합한 성향 섹션
                        AcademySuitablePersonalitySection(academy: academy)
                        
                        // 근처 다른 학원 섹션
                        NearbyAcademiesSection(academy: academy)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("닫기"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        toggleBookmark()
                    }){
                        Image(systemName: isBookmarked ? "heart.fill" : "heart")
                            .foregroundColor(isBookmarked ? .red : .gray)
                    }
                }
            }
            .onAppear{
                isBookmarked = recommendationService.isBookmarked(academyId: academy.id)
            }
        }
    }
    
    private func toggleBookmark(){
        recommendationService.toggleBookmark(academyId: academy.id)
        isBookmarked.toggle()
    }
}

// MARK: - 상단 헤더 섹션
struct AcademyHeaderSection: View {
    let academy: Academy
    @Binding var selectedImageIndex: Int
    
    var body: some View {
        ZStack{
            // 배경 이미지 (임시로 그라데이션 사용)
            Rectangle()
                .fill(
                    LinearGradient(colors: [Color.green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(height: 200)
            
            VStack(spacing: 12){
                // 거리 배지
                if let distance = academy.distance{
                    Text(academy.distanceString)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                }
                
                // 학원명
                Text(academy.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                
                // 주소
                Text(academy.address)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - 기본 정보 섹션
struct AcademyInfoSection: View {
    let academy: Academy
    
    var body: some View {
        HStack{
            // 평점
            VStack(alignment: .leading, spacing: 4){
                Text("평점")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing:4){
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    
                    Text(String(format: "%.1f", academy.rating))
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("(\(academy.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                
                }
            }
            
            Spacer()
            
            // 과목 수
            VStack(alignment: .center, spacing: 4){
                Text("과목")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(academy.subjects.count)개")
                    .font(.headline)
                    .fontWeight(.bold)
            
            }
            
            Spacer()
            
            // 수강료
            VStack(alignment: .trailing, spacing: 4){
                Text("수강료")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(academy.priceRange)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}


// MARK: - 연락처 및 위치 섹션
struct AcademyContactSection: View {
    let academy: Academy
    
    var body: some View {
        VStack(spacing: 16){
            // 전화번호
            HStack{
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text("전화번호")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(academy.phoneNumber){
                    // 전화 걸기
                    if let phoneURL = URL(string: "tel:\(academy.phoneNumber.replacingOccurrences(of: "-", with: ""))"){
                        UIApplication.shared.open(phoneURL)
                    }
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            }
            
            // 운영시간
            HStack{
                Image(systemName: "clock.fill")
                    .foregroundColor(.green)
                    .frame(width: 20)
                
                Text("운영시간")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(academy.workingHours)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            }
            
            // 지도 보기 버튼
            Button(action:{
                openInMaps()
            }){
                HStack{
                    Image(systemName: "map.fill")
                    Text("지도에서 보기")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.05))
        )
    }
    
    private func openInMaps(){
        let urlString = "http://maps.apple.com/?q=\(academy.latitude), \(academy.longitude)"
        if let url = URL(string: urlString){
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 전문 분야 섹션
struct AcademySpecialitiesSection: View {
    let academy: Academy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("전문 분야")
                .font(.headline)
                .fontWeight(.semibold)
            
            // 과목별
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8){
                ForEach(academy.subjects, id: \.self){ subject in
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
                            .fill(Color.blue.opacity(0.1))
                    )
                }
            }
            
            // 전문 분야
            FlexibleView(data: academy.specialties, spacing: 8, alignment: .leading){ specialty in
                Text(specialty)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(16)
            }
        }
    }
}


// MARK: - 설명 섹션
struct AcademyDescriptionSection: View {
    let academy: Academy
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("학원 소개")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(academy.description)
                .font(.body)
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil: 3)
            
            Button(isExpanded ? "접기": "더보기"){
                withAnimation(.easeInOut){
                    isExpanded.toggle()
                }
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
    }
    
}

// MARK: - 특징 섹션
struct AcademyFeaturesSection: View {
    let academy: Academy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("학원 특징")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8){
                ForEach(academy.features, id: \.self){feature in
                    HStack{
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                        
                        Text(feature)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.1))
                    )
                }
            }
        }
    }
}

// MARK: - 적합한 성향 섹션
struct AcademySuitablePersonalitySection: View {
    let academy: Academy
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("이런 학습자에게 추천")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8){
                ForEach(academy.suitableFor, id: \.self){type in
                    HStack{
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

// MARK: - 근처 다른 학원 섹션
struct NearbyAcademiesSection: View {
    let academy: Academy
    
    var nearbyAcademies: [Academy] {
        Array(SampleData.academies.filter{
            $0.id != academy.id &&
            $0.subjects.contains(where: academy.subjects.contains)
        }.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("근처 다른 학원")
                .font(.headline)
                .fontWeight(.semibold)
            
            if nearbyAcademies.isEmpty{
                Text("근처에 다른 학원이 없습니다")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
            }else{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 12){
                        ForEach(Array(nearbyAcademies), id:\.id){nearbyAcademy in
                            NearbyAcademyCard(academy: nearbyAcademy)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


struct NearbyAcademyCard: View {
    let academy: Academy
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(academy.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text(academy.address)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack{
                HStack(spacing: 2){
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text(String(format: "%.1f", academy.rating))
                        .font(.caption2)
                }
                
                Spacer()
                
                if let distance = academy.distance{
                    Text(academy.distanceString)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
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
        .sheet(isPresented: $showingDetail){
            AcademyDetailView(academy: academy)
        }
    }
}


#Preview {
    AcademyDetailView(academy: SampleData.academies[0])
}


