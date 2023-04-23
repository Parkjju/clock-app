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

### 2-4. 알람사운드 커스텀 및 배너스타일 변경

알람 기능인 만큼 푸시알람이 동작할 경우 기본 사운드가 아닌 커스텀 사운드를 들려주고자 하였습니다. 지인에게 데모 음원을 받아 각각 30초정도의 분량으로 쪼개어 4개의 벨소리를 제작하여 번들 목록에 포함시켰습니다.

먼저 `AVAudioPlayer`인스턴스를 전역범위에 생성합니다. 이후 [playSound](https://github.com/Parkjju/clock-app/blob/a89c19092f2f44ba578f6443510aebae4d9da815/clock-app/Util/playSound.swift#L8-L37)라는 커스텀 함수를 정의하였습니다.

`playSound` 함수는 번들에 등록된 음원파일명을 `fileName`이라는 파라미터로 받습니다. 뷰 컨트롤러 종료시에는 소멸자 `deinit` 내에서 `audioPlayer?.stop()` 메서드를 호출해줘야 음원재생도 종료되게 됩니다.

푸시알람에서 재생되는 사운드 커스텀에 앞서, 스위프트에서는 사용자 UX를 위해 푸시알람의 노출 시간을 약 5초정도로 제한해두었습니다. 원래 iOS14 버전까지는 푸시알람 생성시 옵션을 `.alert`로 지정하면 중요한 알람임을 인지하고 노출 시간을 길게 설정해둘 수 있다고 하는데, 이제는 이러한 옵션을 개발 단에서 정하는게 아닌 사용자 단에서 설정하도록 바뀌었습니다.

알람사운드 전체 재생을 위해서는 5초가량의 짧은 시간동안만 알람이 노출되면 안되고, 음원이 모두 재생되기까지 알람이 유지되어야 합니다.

<img width="354" alt="스크린샷 2023-04-19 오전 8 07 41" src="https://user-images.githubusercontent.com/75518683/232923907-1bdef106-6912-436b-a511-ef8534270245.png">

사용자 단에서 이러한 설정을 해줘야하는데, 앱에서 해당 설정의 위치를 안내해주는 것이 좋다고 생각하였습니다. 해당 값은 `UNCurrentCenter` 인스턴스의 푸시알람 설정 관련 값들을 통해 알아낼 수 있습니다.

[소스코드](https://github.com/Parkjju/clock-app/blob/98a9faf7d02a61795c779965e064109c6a30f032/clock-app/Controllers/WorldClock/WorldClockViewController.swift#L22-L31)를 보면 `UNCurrentCenter` 싱글톤 객체에 접근 후 `getNotificationSettings` 클로저를 통해 각 설정값에 접근하는 것을 볼 수 있습니다.

만약 배너 스타일이 일시적 표시라면 `열거형 rawValue값이 1`, 지속적 표시라면 `열거형 rawValue값이 2`가 됩니다. 이에 따른 분기처리를 통해 설정 앱으로 링크를 연결하도록 기능을 추가할 예정입니다.

푸시알람이 지속적 표시로 변경되었다면 푸시알람 생성시 `UNMutableNotificationContent` 인스턴스의 `sound`속성에 접근, `UNNotificationSound` 인스턴스 생성 뒤 저장하면 됩니다. [(소스코드 링크)](https://github.com/Parkjju/clock-app/blob/98a9faf7d02a61795c779965e064109c6a30f032/clock-app/NotificationService.swift#L52-L53)

## 3. 스톱워치

https://user-images.githubusercontent.com/75518683/232926576-d180b823-cc90-4af0-bfba-b7e8f7a9067c.mov

기본 시계 앱의 스톱워치와 완전히 동일한 로직은 아니지만, 테이블 뷰 셀의 동적 추가와 컴포넌트간 통신, 테이블뷰 셀과 특정 UI를 연결하여 타이머와 함께 동작시키는 방법 등에 대해 공부할 수 있었습니다.

### 3-1. UI 통신

버튼의 동작 로직은 `isStarted`라는 저장속성에 의해 관리됩니다. 시작버튼이 클릭된 경우와 그렇지 못한 경우를 나누어 분기처리를 했습니다. [(소스코드 링크)](https://github.com/Parkjju/clock-app/blob/2e3156a50f2fcf17fceaa589970645d276583ae2/clock-app/Controllers/StopWatch/StopWatchViewController.swift#L69-L92)

스톱워치 뷰 컨트롤러에서 관리되는 `Timer` 객체를 저장속성에 저장해두고 위와 같은 로직이 호출될때마다 `timer.invalidate()` 메서드를 호출해주었습니다.

### 3-2. 테이블뷰 셀 시간초 연동

실시간으로 진행시간이 변화되는 모습을 `UILabel`과 테이블뷰 셀에 담기 위해 [다음 소스코드 링크와 같이](https://github.com/Parkjju/clock-app/blob/2e3156a50f2fcf17fceaa589970645d276583ae2/clock-app/Controllers/StopWatch/StopWatchViewController.swift#L102-L118) 로직을 구현했습니다.

시작버튼 클릭시 [createTimer](https://github.com/Parkjju/clock-app/blob/2e3156a50f2fcf17fceaa589970645d276583ae2/clock-app/Controllers/StopWatch/StopWatchViewController.swift#L95-L100)함수를 호출하여 타이머 객체를 생성하고 `updateTime`이라는 메서드를 간격에 맞추어 호출하게 됩니다.

스톱워치 뷰 컨트롤러에는 `elapsed~`로 시작하는 저장속성이 세 가지 있습니다. 밀리초, 초, 분 세 가지 저장속성에 대해 `elapsed`라는 접두어를 붙여 관리하게 되는데 이들은 `UILabel` 표현을 위해 사용됩니다.

`updateTime` 메서드가 `elapsedMiliSecond`에 타이머 실행 주기인 `timeInterval`값을 더합니다. 이때 밀리세컨드 총 합이 100을 넘어가게 되면 1초를 더하고, `elapsedSecond`가 60초가 넘어가면 `elapsedMinute`값을 1 증가시켰습니다.

업데이트된 `elapsed`값들을 레이블의 `attributedText` 속성에 저장해주었습니다. `attributedText`를 사용한 이유는 `kern` 속성값을 통해 자간을 설정하기 위해서 입니다. [(소스코드 링크)](https://github.com/Parkjju/clock-app/blob/2e3156a50f2fcf17fceaa589970645d276583ae2/clock-app/Controllers/StopWatch/StopWatchViewController.swift#L116)

타이머 실행 주기에 맞춰 매번 테이블뷰의 `reloadData` 메서드도 호출되기 때문에 `cellForRowAt` 파라미터를 갖는 테이블뷰 델리게이트 메서드에 [(다음 소스코드를 작성해두었습니다)](https://github.com/Parkjju/clock-app/blob/2e3156a50f2fcf17fceaa589970645d276583ae2/clock-app/Controllers/StopWatch/StopWatchViewController.swift#L163-L169) 테이블뷰 리로드때마다 셀 마지막 요소의 텍스트값을 `elapsed` 값들과 연동해주었습니다.

## 4. 타이머

https://user-images.githubusercontent.com/75518683/232950937-236b0381-a6f5-4ff7-84d0-6f1663bfc573.mov

### 4-1. 뷰 구성

뷰 구성에서 중점적으로 고려했던 점은 크게 두가지였습니다.

1. `UIPickerView` 컬럼 커스텀하기
2. 원 그리기

#### 4-1-1. 컬럼 커스텀

일반적으로 타이머 기능을 구현할때 `UIDatePicker`에서 `.datePickerMode` 속성의 열거형 케이스 중 `.countDownTimer`로 지정하게 되면 카운트다운 전용 피커뷰를 사용할 수 있습니다. 하지만 이는 분-초 단위만 제공을 하기 때문에, 기본 시계앱에서 사용하는 시간-분-초 세 가지 컬럼을 갖도록 구현하기에는 적합하지 않았습니다.

원하는대로 컬럼을 커스텀하기 위해서는 `UIPickerViewDataSource`와 `UIPickerViewDelegate` 프로토콜 메서드를 구현해야합니다.

먼저, 활용할 데이터를 정의합니다. 저는 24시간 - 60분 - 60초를 배열로 갖도록 계산속성을 추가하였습니다.[(소스코드 1)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L66-L70), [(소스코드 2)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L84-L97)

이후 `UIPickerViewDataSource` 프로토콜의 메서드를 구현해줍니다. [(소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L327-L335)

1. `func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int`: 피커뷰 컴포넌트별 row의 수를 결정
2. `func numberOfComponents(in pickerView: UIPickerView) -> Int`: 피커뷰 컴포넌트 수를 결정

`UIPickerView`에서 컴포넌트는 쉽게말해 각 컬럼들을 의미하고, row는 컴포넌트별 행 요소를 가리킵니다. 2차원 형태의 배열 데이터를 표현하기 쉽습니다.

이후 `UIPickerViewDelegate` 프로토콜 메서드를 통해 각 row를 조회하며 어떤 데이터를 표현할지 컴포넌트에 따른 데이터 리턴 형태를 정의합니다. [(소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L311-L325)

위 프로토콜 함수까지 구현하였으면 구현된 상태는 시-분-초 단위 없이 숫자만 표기됩니다. 이때 각 컴포넌트 별 레이블을 삽입하고싶은데, 관련된 메서드를 `UIPickerView`에서는 제공하지 않습니다. 원한다면 `UIPickerViewDelegate` 프로토콜에서 리턴값 뒤에 컴포넌트별로 단위를 직접 삽입하면 되지만, **모든 row에 대해 동일한 컬럼이 중복되어 나타난다는 문제점이 있습니다.**

이에 따라 [medium 참고 문서](https://medium.com/@luisfmachado/uipickerview-fixed-labels-66f947ded0a8)에 따라 `fixed label`을 포지션에 맞추어 구현하였습니다. 기기별 대응에는 한계가 있겠지만 UIPickerView 컴포넌트별 레이블 커스텀이 가능하다는 점을 배울 수 있었습니다. [(setPickerLabels 소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L337-L367)

직접 정의한 `setPickerLabels` 함수는 다음과 같이 동작합니다.

1. `labels`파라미터: 컴포넌트별 레이블명을 딕셔너리 형태로 지정합니다.(시간, 분, 초)
2. `containedView`: 화면 프레임사이즈를 얻기 위해 수퍼뷰를 전달합니다.

컴포넌트의 row당 갖는 글자수를 기준으로 레이블을 오른쪽으로 몇 포인트 더 밀어낼지에 대한 로직이 추가적으로 구현되어 있습니다.

#### 4-1-2. 원 그리기

원을 그리는데에는 뷰 두개를 겹쳐놓은 뒤 서브뷰를 검정바탕으로, 수퍼뷰를 `systemOrange` 바탕색으로 해두었습니다. 기본 시계 앱에서는 오렌지색 원의 지름이 시간에 따라 검정색으로 칠해지는 애니메이션도 구현되어 있지만 이 부분은 구현하지 못하였습니다.

`UIView.animate` 클로저에서 원을 감싸는 `timerView`, `timerInnerView`와 `timePicker`사이의 `alpha`값 조절을 통해 두 컴포넌트 사이의 자연스러운 교체 효과를 부여하였습니다. [(소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L243-L272)

timerView 내에서 서브 레이블을 하나 더 두어 타이머가 실제로 울리게 될 시간도 추가로 표기하였습니다.

### 4-2. 기능

타이머 뷰 컨트롤러에서 사용되는 기능은 타이머 종료에 따른 푸시알람, 오디오 플레이가 있습니다. 큰 틀은 알람 뷰 컨트롤러에서와 동일합니다.

타이머 뷰 컨트롤러의 경우, 한 뷰 컨트롤러에서 여러개의 푸시알람을 동시에 관리해야할 필요가 없기 때문에 푸시알람의 아이디값이 중복되는 경우가 존재하지 않습니다. 따라서 푸시알람 pending 리스트의 관리가 더 수월했습니다. 아이디값은 timeInterval값을 문자열 보간법으로 감싸 활용하였습니다. [(소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L196-L202)

타이머 인스턴스의 경우 시작과 동시에 타이머의 셀렉터 메서드가 바로 동작해야 하므로 `timer.fire()` 메서드를 호출했습니다.

타이머 동작에 따라 남은 시간을 나타내는 레이블은 `updateTimeLabel`메서드에서 관리하였습니다. [(소스코드)](https://github.com/Parkjju/clock-app/blob/98d8e7fd459a3750ab11223341132b15449cfd9a/clock-app/Controllers/Timer/TimerViewController.swift#L204-L241)

`updateTimeLabel` 메서드에서는 피커뷰의 레이블 로우를 `selectedRow`로 선택하여 남은 시간을 체크하였고, 1초 지날때마다 초에 해당하는 피커뷰 컴포넌트의 row값을 1씩 감소시켜 다시 피커뷰를 `select` 하였습니다. `selectRow`와 `selectedRow`는 로우값을 set하느냐 get하느냐에 따른 차이가 있습니다. 0초에서 -1초가 select되면 분을 감소시키고, 0분 0초에서 -1초가 select되면 시간을 감소시키며 최종적으로 0시간 0분 0초에서 -1초가 select되면 타이머를 종료하고 푸시알람을 동작시키도록 구현하였습니다.

푸시알람의 동작은 `requestAlarmNotification` 메서드에서 구현되었고 `getTrigger` 메서드에서 `UNTimeIntervalNotificationTrigger`를 리턴하도록 하였습니다.

오디오 선택은 알람 뷰 컨트롤러와 동일하게 커스텀 델리게이트 패턴 형태로 타이머 루트 뷰 컨트롤러의 레이블 요소를 업데이트 하도록 하였습니다.

## 2023/04/23 추가 리팩토링

`NotificationService` 싱글톤 객체의 `requestAlarmNotification`함수를 오버로딩 하여 불필요한 코드의 중복을 제거하였습니다. 타이머 뷰 컨트롤러와 알람 뷰 컨트롤러에서 모두 푸시알람을 생성하도록 디바이스에 요청하는 `requestAlarmNotification` 함수를 호출하는데, 기존 코드에서는 두 뷰 컨트롤러에 대한 모든 정보를 하나의 함수에 `nil`값으로 받아 내부적인 분기처리를 해야 했습니다.

`type`파라미터를 받아 `switch`문을 통해 알람 뷰컨트롤러에서 온 푸시알람 생성 요청인지, 타이머 뷰컨트롤러에서 온 생성요청인지 분기처리를 하다 보니 함수는 하나로 묶일 수 있었지만 불필요하게 `nil`값으로 아규먼트를 전달해야 하는 경우가 있었습니다.

[(소스코드 링크)](https://github.com/Parkjju/clock-app/commit/9a62eb92dcfbdfcaa9ac384de7cc53793dfc3b0e)를 보면 현재 뷰 컨트롤러에 맞지 않는 성격의 파라미터는 굳이 전달하지 않아도 되도록 코드가 훨씬 보기 좋아졌습니다.

[(소스코드 링크)](https://github.com/Parkjju/clock-app/commit/aafe5d7b2b75707bccd8fc9afdbf7afd3434d7cc)는 `NotificationService` 싱글톤 객체 내에 정의된 `requestAlarmNotification` 메서드인데, 함수 오버로딩 적용 이후 이 함수의 파라미터가 눈에 띄게 줄었을 뿐만 아니라 오버로딩에 따라 함수가 하는 일이 명확해짐을 볼 수 있습니다.

예를 들어 타이머 뷰 컨트롤러에서는 불필요한 date값 등을 받을 필요 없이 TimeInterval값만 받으면 되므로, 함수 파라미터 형태만 보고도 타이머 뷰 컨트롤러로부터 요청이 들어온다는 것을 알 수 있기에 기존에 받았던 `type`이라는 파라미터를 통한 switch 분기처리 코드가 삭제될 수 있었습니다.

`requestAlarmNotifcation` 내에서 호출하는 `getTrigger`함수의 리턴 타입 역시 기존에는 어떤 타입이 리턴될지 몰랐기 때문에 삼항연산자로 복잡한 코드가 작성되었지만, 현재는 코드 흐름상 `UNCalendarNotificationTrigger`타입인지 `UNTimeIntervalNotificationTrigger` 타입인지 명확히 구분 가능하게 되어 코드가 짧아질 수 있었습니다.
