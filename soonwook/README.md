# 책 정보 검색
<!--배지-->
![MIT License][license-shield] ![Repository Size][repository-size-shield] ![Issue Closed][issue-closed-shield]

<!--목차-->
# Table of Contents
- [[1] About the Project](#1-about-the-project)
  - [Features](#features)
  - [Technologies](#technologies)
- [[2] Getting Started](#2-getting-started)
  - [Installation](#installation)
- [[3] Usage](#3-usage)
- [[4] Contribution](#4-contribution)
- [[5] Acknowledgement](#5-acknowledgement)
- [[6] Troubleshooting](#6-troubleshooting)
- [[7] Contact](#7-contact)
- [[8] License](#8-license)

# [1] About the Project
- 책 검색하고 저장하는 앱
>

![Simulator Screen Recording - iPhone 16 Pro - 2025-05-19 at 09 52 13](https://github.com/user-attachments/assets/a1ddcb65-0d2f-4969-ac2b-dd52f0943e20)
![Simulator Screen Recording - iPhone 16 Pro - 2025-05-19 at 09 53 04](https://github.com/user-attachments/assets/b9ff8200-5838-4c32-93eb-d950cb055637)
![Simulator Screen Recording - iPhone 16 Pro - 2025-05-19 at 09 54 24](https://github.com/user-attachments/assets/2d55151c-7543-4cc7-ad3f-29ba94622e48)


## Features
- *1. Kakao API로 책 정보를 검색*
- *2. 원하는 책을 장바구니에 담거나 삭제*
- *3. 최근 본 책 리스트 조회*
- *4. 장바구니나 최근 본 책은 데이터를 앱에 저장*

## Technologies
- [Swift](https://www.swift.org) 5.0
- URL Session, Core Data, MVVM pattern, RxSwift, RxCocoa

# [2] Getting Started

## Installation
- Repository 클론(soonwook 폴더)
```bash
git clone https://github.com/Sparta-bootcamp-master-4team/AdvanceProject
```

# [3] Usage
- 책 정보 조회: 키워드를 검색하면 카카오 API 검색 결과를 노출. 무한 스크롤 가능.
- 장바구니: 원하는 책을 장바구니에 담거나 삭제 가능. 일괄 삭제 기능과 검색 화면으로 이동기능도 제공.
- 최근 본 책: 최근 본 책 이미지를 검색 화면 상단에 노출.

# [4] Contribution
4팀(퉁퉁퉁퉁퉁퉁퉁퉁퉁4후르)

# [5] Acknowledgement
- https://github.com/ReactiveX/RxSwift
- https://developer.apple.com/documentation/uikit/uicollectionview

# [6] Troubleshooting
- https://wittie.tistory.com/53
>

## Level 7 메모리 이슈 디버깅
1. deinit 이용
- 책 정보 상세 화면 뷰가 이슈 발생 가능성이 있다고 생각되어(여러 경로에서 탭할 때마다 인스턴스가 새로 생성되므로) deinit을 넣고 확인 -> 이상 없음

2. Debug Memory Graph 검토
- 불필요한 ViewController나 View Model,  또는 View가 메모리에 존재하는지 확인 -> 이상 없음
- Table View Cell와 Collection View Cell의 총 갯수가 화면에 보이는 숫자 이상으로 존재하는지 확인 -> 이상 없음
- 그래프 상 순환 참조 등이 보이는지 확인 -> 이상 없음

# [7] Contact
- 📋 https://github.com/witt1e

# [8] License
MIT 라이센스
라이센스에 대한 정보는 [`LICENSE`][license-url]에 있습니다.

<!--Url for Badges-->
[license-shield]: https://img.shields.io/github/license/dev-ujin/readme-template?labelColor=D8D8D8&color=04B4AE
[repository-size-shield]: https://img.shields.io/github/repo-size/dev-ujin/readme-template?labelColor=D8D8D8&color=BE81F7
[issue-closed-shield]: https://img.shields.io/github/issues-closed/dev-ujin/readme-template?labelColor=D8D8D8&color=FE9A2E

<!--URLS-->
[license-url]: LICENSE.md
