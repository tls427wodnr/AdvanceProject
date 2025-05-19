# 📚 책 검색하고 저장하는 앱  
3-3 앱개발 심화 주차 과제 - Advance

**책 검색하고 저장하는 앱**은 Kakao Book API를 기반으로 원하는 책을 검색하고, 마음에 드는 책을 로컬에 저장할 수 있는 **iOS 북마크 앱**입니다.  
검색, 저장, 삭제, 스와이프 UI 등 **사용자 편의 기능**이 포함되어 있으며,  
**UIKit + MVVM-C + RxSwift + CoreData + Clean Architecture** 기반으로 설계되었습니다.

---

## 🗓 프로젝트 기간  
2025년 5월 07일 ~ 2025년 5월 19일 (총 13일간 진행)

---

## 🎯 프로젝트 목표

- Kakao Book API 연동을 통한 책 검색 기능 구현
- 사용자가 선택한 책을 CoreData에 저장
- 저장된 책 목록을 확인하고 삭제 가능
- 검색 결과 및 저장 목록 UI를 분리하여 관리
- 스크롤에 따른 페이징 및 UISearchBar 활용
- RxSwift를 활용한 입력/출력 바인딩 구조 설계
- 클린 아키텍처 기반 계층 분리

---

## 📱 주요 기능

| 기능 구분 | 설명 |
|----------|------|
| 책 검색 | 카카오 책 검색 API 연동, 실시간 필터링 |
| 무한 스크롤 | 검색 결과를 스크롤에 따라 추가 요청 |
| 책 담기 | 선택한 책을 CoreData에 저장 |
| 담은 책 확인 | 저장된 책 목록을 별도 탭에서 조회 |
| 책 삭제 | 스와이프를 통한 개별 삭제 기능 |

---

## ✅ 구현 기능 체크리스트

- [x] **책 검색 기능**
  - [x] Kakao Book API 연동
  - [x] Rx 기반 검색 처리 및 페이징
  - [x] UISearchBar 연동

- [x] **저장 기능**
  - [x] CoreData 저장 구조 설계
  - [x] 중복 저장 방지
  - [x] 개별 삭제 및 전체 삭제 기능

- [x] **UI 구성**
  - [x] Compositional Layout을 활용한 섹션 구성
  - [x] BookCell 커스터마이징
  - [x] 스와이프 삭제 구현

---

## 🧩 기술 스택

- **언어:** Swift  
- **프레임워크:** UIKit  
- **레이아웃:** SnapKit  
- **아키텍처:** MVVM-C, Clean Architecture  
- **비동기 처리:** RxSwift, RxCocoa  
- **저장소:** CoreData  

---

## 📸 주요 화면
- 📖 책 검색 화면
  
- 📌 저장된 책 목록 화면

- 🔍 검색 시 페이징 UI

- 🧹 스와이프 삭제 화면

---

## 📋 요구사항 기반

- REST API 기반 검색 기능
- CoreData를 통한 로컬 저장 및 삭제
- MVVM 구조 분리 및 Coordinator 화면 관리
- SnapKit 기반의 유연한 UI 구성
- Rx 바인딩을 통한 반응형 흐름 구성

---

## 🔎 협업 규칙

- Git Flow 전략에 맞춘 브랜치 관리
- 기능 단위 브랜치 생성 후 PR
- 커밋 메시지 컨벤션 준수
- 명확한 네이밍과 주석을 통한 협업 용이성 확보

---

## ✏️ 코딩 컨벤션

- [Swift 스타일 가이드](https://github.com/StyleShare/swift-style-guide) 기반
- 함수/변수명은 역할이 명확히 드러나게 작성
- ViewModel과 ViewController의 책임 분리 철저

---

## 📍 커밋 컨벤션

- `feat`: 기능 추가  
- `fix`: 버그 수정  
- `refactor`: 리팩토링  
- `docs`: 문서 수정  
- `test`: 테스트 코드  
- `style`: 코드 포맷 변경  
- `build`: 빌드 관련  
- `chore`: 기타 잡일

---

## 💡 브랜치 전략

- `main` : 배포용  
- `dev` : 통합 개발 브랜치  
- `feat/*` : 기능 브랜치  
- `fix/*` : 버그 수정 브랜치  

---

## 🚀 실행 방법

1. 프로젝트 클론
```bash
https://github.com/Sparta-bootcamp-master-4team/AdvanceProject/tree/feat/sheep1sik

+ KAKAO API KEY가 필요합니다.

---

## 📝 메모리 누수 혹은 클로저 강한 참조로 인한 Retain Cycle 발생 여부 분석

https://sheep1sik.tistory.com/175
