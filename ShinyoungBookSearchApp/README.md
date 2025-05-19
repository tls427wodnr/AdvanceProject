# 📚 ShinyoungBookSearchApp

카카오 도서 검색 API를 이용하여 도서를 검색하고, 최근 본 책 및 즐겨찾기를 관리할 수 있는 iOS 앱입니다.  
사용자는 책 제목이나 키워드를 입력하여 책을 검색하고, 관심 있는 도서를 즐겨찾기에 저장하거나 최근 검색 내역을 확인할 수 있습니다.

## 🧩 주요 기능

- 🔍 **카카오 API 기반 도서 검색**: 키워드로 책 정보를 검색 (Kakao Books OpenAPI)
- ⭐️ **즐겨찾기 저장**: CoreData를 통한 로컬 저장
- 🕘 **최근 본 책 관리**: 최근 열람한 도서를 자동으로 기록
- 🧱 **MVVM 아키텍처 기반**의 구조로 테스트 및 유지보수가 용이
- 🧩 **DIContainer 기반 의존성 주입**

## 🧩 아키텍처 구성

### ✅ 의존성 분리 구조 (MVVM + UseCase + Repository)

### ✅ DIContainer 역할

- ViewModel 생성 시 → UseCase 주입
- UseCase 생성 시 → Repository 주입
- Repository 내부 → CoreDataService, NetworkService 구성

## ⚙️ 기술 스택

### 📱 iOS 개발
- **UIKit**: 사용자 인터페이스 구성
- **SnapKit**: 코드 기반 AutoLayout 제약 조건 설정

### 🔄 아키텍처 & 디자인 패턴
- **MVVM (Model-View-ViewModel)**: 뷰 로직과 비즈니스 로직 분리
- **DIContainer (의존성 주입)**: 유닛 테스트 가능성과 모듈화 향상

### 🧩 비동기 & 반응형 프로그래밍
- **RxSwift + RxCocoa**: 이벤트 스트림 관리, UI 바인딩

### 🗂 데이터 저장
- **CoreData**: 로컬 데이터(즐겨찾기, 최근 본 책 등) 영구 저장

### 🌐 네트워킹
- **URLSession**: HTTP 요청 수행
- **Kakao Books OpenAPI**: 도서 정보 검색 (REST API 방식)

### 🧪 테스트 및 유지보수
- **의존성 분리와 테스트 대상 분할 구조** (UseCase, Repository 기반 설계)
- **Swift Codable**: JSON 직렬화 / 역직렬화 처리

### 예시: BookSearch 흐름

1. 사용자 검색어 입력
2. `ViewController`에서 이벤트 발생
3. `ViewModel.searchBooks()` 호출
4. `SearchBookUseCase.execute()` 수행
5. `BookRepository.fetchBooks()` 호출
6. `NetworkService.fetch()`로 카카오 API 요청
7. 결과를 받아 `ViewModel`에 전달
8. `ViewModel`이 데이터를 가공하여 `View`에 바인딩

## 스크린샷
<table>
  <tr>
    <td><img width="300" src="https://github.com/user-attachments/assets/69a79321-7c41-4e99-b7c6-4cf61fae67b6" /></td>
    <td><img width="300" src="https://github.com/user-attachments/assets/c3db663c-a3d4-4d05-8e84-7f1701919306" /></td>
    <td><img width="300" src="https://github.com/user-attachments/assets/1e9525d5-769c-4fee-8da6-e7830c2dcb65" /></td>
  </tr>
  <tr>
    <td><img width="300" src="https://github.com/user-attachments/assets/321bc91f-d853-4faa-ae92-89983325fd4d" /></td>
    <td><img width="300" src="https://github.com/user-attachments/assets/8008651c-d48f-48b6-9512-3550a952c4ca" /></td>
    <td><img width="300" src="https://github.com/user-attachments/assets/25c7c22f-3c0d-47f1-9ce1-9a20912d9800" /></td>
  </tr>
</table>

