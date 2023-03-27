# 시계 앱 클론

swift UIKit을 활용하여 아이폰 기본 앱인 시계 앱을 클론코딩 하였습니다.

## 아키텍쳐
MVC로 구성하였습니다. 

1. Model: 코어데이터 관리모델 / CRUD 로직 매니저 클래스 정의
2. View: 스토리보드 기반 UI
3. Controller: 탭별 커스텀클래스 (세계시간, 알람, 타이머, 스톱워치)

![스크린샷 2023-03-27 오전 9 57 20](https://user-images.githubusercontent.com/75518683/227816805-c474848b-aa00-4daf-bffa-b4f48b7d3481.png)

## 세계 시계
https://user-images.githubusercontent.com/75518683/227817058-07d886c0-2fbb-47cf-b7a5-6b5f9166cc16.mov

데이터의 저장은 코어데이터를 기반으로 하였습니다.

1. 스위프트 TimeZone을 활용하여 세계시간을 알아내고 저장하는 로직을 구현하였습니다.
2. 각 배열 요소에 order속성을 부여하여 순서에 대한 정보를 갖게 하고 테이블 뷰의 reorder control을 적용하였습니다.
3. 테이블뷰 editing 모드를 적용하였습니다.
4. 서치바를 추가하여 나라를 검색할 수 있도록 하였습니다. 
5. 나라 검색페이지에 테이블뷰 인덱싱 기능을 추가하며 한글 자모-초성간 유니코드 관계를 정리하였습니다.
6. UI 관련 디테일들을 기본 앱과 최대한 동일하게 적용하려고 하였습니다.
    - 편집버튼 클릭시 시간 UILabel을 숨기기 - isHidden 속성을 사용하면 빈 공간을 차지하여, widthAnchor값을 0으로 부여한 뒤 editing모드 Boolean값에 따라 제약조건 isActive속성을 조절하였습니다.
    - 네비게이션 컨트롤러 Appearance 속성을 커스텀하여 scrollEdge에 따른 배경색과 스크롤중인 배경색을 다르게 표현하였습니다.
    - 테이블뷰 셀을 스와이프로 삭제할 수 있도록 UITableViewDataSource의 `func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool` 메서드를 활용하였습니다.
    - `func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?` 메서드를 활용하여 삭제 버튼 텍스트를 변경하였습니다. 
   
세계 시계 기능을 구현하며 블로그에 정리한 내용들입니다.
1. [타임존을 활용하여 전 세계 시간 알아내기](https://parkjju.github.io/vue-TIL/trash/230209-timezone.html)
2. [네비게이션 바 커스텀](https://parkjju.github.io/vue-TIL/trash/230213-navigationBar.html)
3. [네비게이션 뷰 컨트롤러와 모달 노출에 대한 관계정리](https://parkjju.github.io/vue-TIL/trash/230215-12.html)
4. [dismiss 후 테이블뷰 리로딩하기](https://parkjju.github.io/vue-TIL/trash/230215-13.html)
5. [테이블뷰 순서 재배치](https://parkjju.github.io/vue-TIL/trash/230217-14.html)
6. [테이블뷰 인덱싱과 한글 초성-자모 유니코드 사이 관계 정리](https://parkjju.github.io/vue-TIL/trash/230319-19.html#%E1%84%90%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%87%E1%85%B3%E1%86%AF%E1%84%87%E1%85%B2-%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%83%E1%85%A6%E1%86%A8%E1%84%89%E1%85%B5%E1%86%BC)
7. [테이블뷰와 서치바](https://parkjju.github.io/vue-TIL/trash/230326-20.html#uisearchbar)
8. [코어데이터 기본개념 정리](https://parkjju.github.io/vue-TIL/swift/230201-core.html)


## 알람


## 스톱워치

## 타이머
