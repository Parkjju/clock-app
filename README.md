# 시계 앱 클론

swift UIKit을 활용하여 아이폰 기본 앱인 시계 앱을 클론코딩 하였습니다.

## 아키텍쳐

MVC로 구성하였습니다.

1. Model: 코어데이터 관리모델 / CRUD 로직 매니저 클래스 정의
2. View: 스토리보드 기반 UI
3. Controller: 탭별 커스텀클래스 (세계시간, 알람, 타이머, 스톱워치)

![스크린샷 2023-03-27 오전 9 57 20](https://user-images.githubusercontent.com/75518683/227816805-c474848b-aa00-4daf-bffa-b4f48b7d3481.png)

## 1. 세계 시계

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

## 2. 알람

https://user-images.githubusercontent.com/75518683/232666942-1a219255-50eb-475c-9814-e3aef0892eef.mov

https://user-images.githubusercontent.com/75518683/232667225-b67acf8d-5731-4501-b8d2-0360775f25b8.mov

알람 기능입니다. `UNUserNotificationCenter.current()` 인스턴스를 저장속성으로 갖는 커스텀 클래스를 생성하여 싱글톤 패턴으로 푸시 알람을 관리하였습니다.
`requestAlarmNotification` 함수를 정의하여 알람 요청을 받도록 구현하였습니다. [소스코드 링크](https://github.com/Parkjju/clock-app/blob/7bf521149639861051e0df8d82b3e0be7787d53e/clock-app/NotificationService.swift#L45-L79)

### 2-1. 트리거

[소스코드 링크](https://github.com/Parkjju/clock-app/blob/7bf521149639861051e0df8d82b3e0be7787d53e/clock-app/NotificationService.swift#L81-L126)

푸시알람 발동을 위한 트리거는 `getTrigger()` 함수를 통해 관리하였습니다. 알람의 경우 특정 시간에 맞춰 푸시알람이 동작해야하고, 타이머의 경우 설정해둔 시간이 흐른 뒤에 동작해야 합니다.

함수 리턴타입은 `UNNotificationTrigger`로 하여 `UNCalendarNotificationTrigger` 또는 `UNTimeIntervalNotificationTrigger` 두 타입을 리턴 후 활용하는 뷰 컨트롤러에 따라 타입캐스팅 하여 구현하였습니다. 알람 뷰컨트롤러에서는 `UNCalendarNotificationTrigger`, 타이머 뷰컨트롤러에서는 `UNTimeIntervalNotificationTrigger`로 타입캐스팅 하였습니다.

설정한 시간이 현시각 기준으로 더 앞시간이라면 다음날에 대한 알람을 맞춘 것이므로, `getTrigger` 함수 내에서 코어데이터에 저장된 데이터를 불러와 AlarmData 인스턴스의 time속성을 수정해야 합니다. 기존에 설정되어 있던 알람은 삭제해줘야 하므로 `getTrigger` 함수에 전달되었던 `notificationId` 값을 타겟으로 하여 `UNCurrentCenter.removePendingNotificaitonRequest` 함수 호출과 함께 알람을 삭제해줍니다.

### 2-2. 테이블뷰 재정렬

`getTrigger`에서 현 시각 기준으로 앞선 알람데이터에 대해 하루를 더하는 로직이 실행되었다면 알람 탭의 루트 뷰 컨트롤러에서 테이블뷰 셀의 정렬이 원하는 형태로 이루어지지 않습니다. [코어데이터 Alarm 모델을 관리하는 로직 코드를 보면](https://github.com/Parkjju/clock-app/blob/92a217b371df040ff62f502f76d20aa210b0cdd1/clock-app/Models/Alarm/AlarmManager.swift#L24-L49) `sortDescriptor`가 time의 오름차순으로 되어 있는데, Date객체는 시-분-초의 값들로만 오름차순 정렬을 하는 것이 아닌 월-일을 가지고도 오름차순 정렬을 하게 됩니다.

알람 탭의 테이블뷰 셀에는 월-일에 대한 날짜정보를 표기하고 있지 않기 때문에 **3:30분**이라고 표기되어 있는 시간이 **2:30분**보다 먼저 표기됩니다. 이에 따라 `cellForRowAt` 테이블뷰에 알람 리스트를 전달하기 전 재정렬을 해주는 메서드를 정의해야 합니다. 이는 [다음 소스코드에](https://github.com/Parkjju/clock-app/blob/92a217b371df040ff62f502f76d20aa210b0cdd1/clock-app/Controllers/Alarm/AlarmViewController.swift#L65-L99) 정의해두었습니다.

### 2-3. willPresent

또한 푸시알람이 작동한 이후 해당 시간의 알람 뷰 컨트롤러 테이블뷰 셀마다 있는 토글버튼에 대해 `isOn` 속성을 `false`로 설정해줘야 합니다. 푸시알람이 울리는 시점은 `UNUserNotificationCenterDelegate` 프로토콜의 `func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)` 함수에서 관리할 수 있습니다.

인스턴스의 `isOn`속성 변경을 위해서는 수정 대상 인스턴스를 불러와야 하는데, 이를 위해 `requestAlarmNotification` 메서드의 파라미터에 타겟 인스턴스의 아이디로 관리되는 `notificationId`를 추가하였습니다. **푸시알람과 테이블뷰에 표기될 AlarmData 인스턴스는 1대1 대응 되므로** 해당 푸시알람 객체에만 대응되도록 알람데이터의 Id값을 전달해야 했는데, 이를 위해 `UNMutableNotificationContent()` 인스턴스의 `userInfo` 속성을 활용하였습니다. [(소스코드 링크)](https://github.com/Parkjju/clock-app/blob/120585cf943f6ad32a76691d51e49d2d3511946d/clock-app/NotificationService.swift#L61), [(willPresent 함수 소스코드)](https://github.com/Parkjju/clock-app/blob/120585cf943f6ad32a76691d51e49d2d3511946d/clock-app/NotificationService.swift#L155-L174)

또한 리로드가 필요한 알람 탭의 루트뷰 컨트롤러의 `tableView`를 `requestAlarmNotification` 파라미터에 담아 전달한 뒤 `willPresent` 메서드에서 리로드하도록 구현하였습니다.

### 2-4. 알람사운드 커스텀

## 스톱워치

## 타이머
