# ExchangeRateCalculation

### 키워드로 책을 검색하고, 본 책과 담은 책을 한눈에 관리할 수 있는 도서 탐색 앱입니다.


## 요구사항
<details><summary>레벨 1</summary>

- `UITabBarController` 을 사용하여 2개의 탭을 구현합니다.
- 책 검색 화면은 첫 번째 탭에 위치합니다.
- 책 상세 화면
    - 사용자는 **검색 결과의 리스트 아이템을 ‘탭’하여** 책 상세 화면에 진입할 수 있습니다.
    - 책 상세 화면은 `모달 방식`으로 등장합니다.
- 담은 책 리스트 화면은 두번째 탭에 위치합니다.
    - 사용자는 책 상세 화면에서 `담기` 를 한 책 리스트를 저장한 책 리스트 화면에서 볼 수 있습니다.

</details>  
<details><summary>레벨 2</summary>

- 사용자는 서치바를 이용해서 책을 검색합니다.
- 사용자는 검색 이후 검색 결과를 리스트를 통해 볼 수 있습니다.
- iOS 16.0과 호환 가능한 iPhone 모델(SE 2세대, 16 Pro Max 등)의 다양한 디바이스 지원과 Portrait 모드/ Landscape 모드를 대응하도록 합니다.
- 사용자는 서치바를 사용하여 책을 검색할 수 있습니다.
- 검색에는, 또한 카카오 책 검색 REST API 를 이용합니다.

</details>  
<details><summary>레벨 3</summary>
<aside>

- 책 상세 화면에서는 검색 결과 응답 내용을 자세하게 보여줍니다.
- Level 2와 마찬가지로 다양한 기기 대응 
- 담기 기능 구현
- 담은 책 목록 기능 구현
  - 앱을 종료하고 다시 시작해도 담은 책 목록은 남아있어야합니다.
  - 전체 삭제 버튼을 누르면 담았던 모든 책이 지워집니다.
  - 스와이프 등의 방식을 통하여 담은 책 개별삭제가 가능합니다.
  - 추가 버튼을 누르면 첫번째 탭(책 검색 화면)을 보여주고, 서치바를 활성화시킵니다.

</details>  
<details><summary>레벨 4</summary>

- 사용자가 책 상세보기 화면까지 살펴본 책이 있을 경우, 검색결과 리스트의 최상단에 최근 본 책 을 보여줍니다.
- 검색 결과 리스트는 이제 2개의 섹션을 사용합니다.
- 최근 본 책을 ‘탭’하면 책 상세화면이 등장합니다.

</aside>
</details>  
<details><summary>레벨 5</summary>
<aside>

- 검색 결과 리스트에 무한 스크롤을 구현합니다.

</details>  
<details><summary>레벨 6</summary>

- 클린아키텍처 추가

</details>  
<details><summary>레벨 7</summary>

- 메모리 누수 혹은 클로저 강한 참조로 인한 Retain Cycle 발생 여부 확인 및 해소

</details>  

## 시연영상
![Simulator Screen Recording - iPhone 13 Pro - 2025-05-15 at 15 51 27](https://github.com/user-attachments/assets/31c21882-3f1a-4581-82b5-47e5967ea46f)
![Simulator Screen Recording - iPhone 13 Pro - 2025-05-19 at 00 56 42](https://github.com/user-attachments/assets/b932f4c7-fedd-4582-8c76-35352f636acb)
![Simulator Screen Recording - iPhone 13 Pro - 2025-05-15 at 21 55 22](https://github.com/user-attachments/assets/630106e9-ba4e-439c-9f22-6f0d7fc280fe)


## PR

- [Lv 1, 2](https://github.com/Sparta-bootcamp-master-4team/AdvanceProject/pull/10)
- [Lv 3](https://github.com/Sparta-bootcamp-master-4team/AdvanceProject/pull/23)
- [Lv 4](https://github.com/Sparta-bootcamp-master-4team/AdvanceProject/pull/36)
- [Lv 5](https://github.com/Sparta-bootcamp-master-4team/AdvanceProject/pull/43)

## 트러블슈팅

[BookSearchApp 트러블슈팅 - 일부 배경색이 투명한 현상](https://subkyu-ios.tistory.com/47)

[BookSearchApp Lv 3 트러블슈팅 - Core Data 크래시](https://subkyu-ios.tistory.com/48)

