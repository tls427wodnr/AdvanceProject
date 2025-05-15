# 책 검색 & 즐겨찾기 앱

> CoreData와 HTTP 통신을 기반으로, **책 검색부터 즐겨찾기 관리**까지 가능한 iOS 앱  
> 복잡한 레이아웃 구성과 비동기 데이터 흐름을 **RxSwift**, **Clean Architecture**, **MVVM**, **Coordinator** 패턴으로 설계한 개인 과제입니다.

## 소개

이 프로젝트는 iOS UIKit 환경에서 **RxSwift**와 **클린 아키텍처**, **I/O 패턴**, **Coordinator 패턴**을 바탕으로 구현된 책 검색 및 저장 앱입니다.  
실제 서비스 개발에 필요한 구성 요소들을 학습하고 적용하는 데 집중했으며, 다음과 같은 목적을 갖고 진행되었습니다:

- ✅ 복잡한 **UI 컴포넌트 구성**과 AutoLayout 디버깅 경험
- ✅ **RxSwift** 기반의 선언형 데이터 바인딩
- ✅ 네트워크 통신과 **CoreData**, **UserDefaults** 저장소 연동
- ✅ **MVVM → 클린 아키텍처로 리팩토링**
- ✅ **메모리 누수 분석 및 관리**
- ✅ **Coordinator Pattern**을 통한 화면 전환 및 흐름 관리

## 주요 기능

- 도서 검색 기능 (검색어 기반 네이버 책 API 연동)
- 도서 상세 페이지 (도서 정보, 표지, 설명 등 표시)
- 최근 본 도서 목록 관리 (UserDefaults 기반) 
- 도서 담기 기능 (Core Data 기반)
- 도서 리스트 페이지(도서 삭제, 전체 삭제, 도서 검색 페이지로 이동)

## 프로젝트 구조
```
AdvanceProject0509/
├── App/
│   ├── Common/
│   │   └── SearchFocusEvent.swift
│   ├── Configuration/
│   │   ├── API.xcconfig
│   │   └── AppConfig.swift
│   ├── Coordinator/
│   │   ├── AppCoordinator.swift
│   │   ├── BookListCoordinator.swift
│   │   └── SearchCoordinator.swift
│   ├── DI/
│   │   ├── AppDIContainer.swift
│   │   ├── BookDetailDIContainer.swift
│   │   ├── BookListDIContainer.swift
│   │   ├── RecentBookDIContainer.swift
│   │   └── SearchDIContainer.swift
│   ├── Root/
│   │   └── MainTabBarController.swift
│   ├── Section/
│   │   └── BookSection.swift
│   └── Support/
│       ├── AppDelegate.swift
│       ├── SceneDelegate.swift
│       └── Assets.xcassets/
│           └── AppIcon.appiconset/
│
├── Data/
│   ├── Network/
│   │   └── NetworkService.swift
│   ├── PersistentStorages/
│   │   └── CoreData/
│   │       ├── Entity+CoreDataClass.swift
│   │       ├── Entity+CoreDataProperties.swift
│   │       └── Model.xcdatamodeld
│   └── Repositories/
│       ├── BookRepository.swift
│       ├── LocalBookRepository.swift
│       └── LocalRecentBookRepository.swift
│
├── Domain/
│   ├── Entity/
│   │   └── Book.swift
│   ├── Interfaces/
│   │   ├── Repositories/
│   │   │   ├── BookRepositoryProtocol.swift
│   │   │   ├── LocalBookRepositoryProtocol.swift
│   │   │   └── LocalRecentBookRepositoryProtocol.swift
│   │   └── UseCases/
│   │       ├── FetchBooksUseCaseProtocol.swift
│   │       ├── LocalBookUseCaseProtocol.swift
│   │       └── LocalRecentBookUseCaseProtocol.swift
│   └── UseCases/
│       ├── FetchBooksUseCase.swift
│       ├── LocalBookUseCase.swift
│       └── LocalRecentBookUseCase.swift
│
├── Presentation/
│   ├── Search/
│   │   ├── View/
│   │   │   ├── SearchCollectionViewCell.swift
│   │   │   ├── SearchViewController.swift
│   │   │   └── SectionHeaderView.swift
│   │   └── ViewModel/
│   │       ├── SearchViewModel.swift
│   │       ├── SearchViewModelIO.swift
│   │       └── SearchViewModelProtocol.swift
│   ├── BookDetail/
│   │   ├── View/
│   │   │   └── BookDetailBottomSheetViewController.swift
│   │   └── ViewModel/
│   │       ├── BookDetailBottomSheetViewModel.swift
│   │       ├── BookDetailBottomSheetViewModelIO.swift
│   │       └── BookDetailBottomSheetViewModelProtocol.swift
│   ├── BookList/
│   │   ├── View/
│   │   │   ├── BookListTableViewCell.swift
│   │   │   └── BookListViewController.swift
│   │   └── ViewModel/
│   │       ├── BookListViewModel.swift
│   │       ├── BookListViewModelIO.swift
│   │       └── BookListViewModelProtocol.swift
│   └── RecentBook/
│       ├── View/
│       │   └── RecentBookCollectionViewCell.swift
│       └── ViewModel/
│           ├── RecentBookListViewModel.swift
│           ├── RecentBookListViewModelIO.swift
│           └── RecentBookListViewModelProtocol.swift
│
├── Info.plist
└── README.md
```

## 시연 영상
