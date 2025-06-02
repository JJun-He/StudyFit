# 🧠 StudyFit - 공부 성향 추천 앱

개인의 학습 성향에 맞춘 공부법과 인강/학원 정보를 추천하는 iOS 기반 앱입니다.
당신에게 꼭 맞는 공부 스타일을 찾고, 더 효율적인 학습 방향을 제시합니다!

---

## 📌 주요 기능

| 기능 | 설명 |
|------|------|
| ✅ 성향 테스트 | 집중 시간대, 공부 방식 등 학습 성향 테스트 |
| ✅ 성향 분석 결과 | 실용형, 목표형, 체계형 등 성향 분류 |
| ✅ 맞춤 추천 | 성향에 맞는 공부법 + 인강/학원 추천 |
| ✅ 찜 기능 | 마음에 드는 강좌나 학원 저장 |
| ✅ 푸시 알림 | 공부 리마인더 및 신규 추천 알림 제공 |

---

## 🛠 기술 스택

| 파트 | 기술 |
|------|------|
| iOS 프론트 | SwiftUI + Combine |
| 백엔드 | FastAPI (Python) or Firebase Functions |
| DB | Firebase Firestore or Supabase |
| 성향 분석 | ChatGPT API or Rule-based logic |
| 위치 기반 추천 | Kakao Local API 활용 예정 |

---

## 📱 화면 구성

- 홈 화면: 성향 테스트 시작 버튼 + 추천 미리보기
- 테스트 화면: 학습 스타일 문항 10~15개
- 결과 화면: 성향 분석 + 추천 학습법/강좌
- 추천 상세: 강좌 정보, 찜 버튼
- 마이페이지: 이전 결과, 저장 목록 확인

---

🧩 향후 계획
Kakao Map API 연동으로 학원 실시간 검색

GPT API 도입으로 동적 성향 분석 고도화

인강 플랫폼 연동 자동화

앱스토어 출시

---

## 🚀 설치 및 실행

```bash
# iOS 프로젝트 클론
git clone https://github.com/username/studyfit.git

# Xcode에서 프로젝트 열기
open StudyFit.xcodeproj

