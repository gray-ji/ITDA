# 잇다 — Flutter 개발 환경 설정 (Windows 기준)

## 1. 개발 도구 설치

### 1.1 VS Code 및 Flutter 확장 프로그램

1. VS Code를 설치한다.
2. Extensions에서 `Flutter`를 검색한다.
3. Dart Code에서 제공하는 Flutter 확장 프로그램을 설치한다.
4. Flutter SDK를 설치하고 PATH를 설정한다.

공식 가이드: [Flutter 설치 — VS Code](https://docs.flutter.dev/install/with-vs-code)

### 1.2 Flutter SDK 확인

터미널에서 다음 명령어를 실행한다.

```bash
flutter --version
```

현재 개발 환경에서 확인한 버전:

- Flutter: `3.47.7`
- 채널: `stable`

위 버전은 현재 개발 환경의 확인 결과이며, 반드시 동일한 버전을 사용하라는 의미는 아니다.

## 2. Android 개발 환경 설정

### 2.1 Android Studio 및 Android SDK 설치

Android 앱 빌드와 에뮬레이터 실행을 위해 Android Studio와 Android SDK를 설치한다.

1. [Android Studio 공식 다운로드](https://developer.android.com/studio)에서 설치 파일을 내려받아 설치한다.
2. 초기 설정을 진행한다.
3. Android Studio의 `SDK Manager`를 연다.
4. `SDK Platforms` 탭에서 프로젝트 빌드에 필요한 Android SDK 플랫폼을 설치한다.
5. `SDK Tools` 탭에서 다음 항목을 확인하고 필요한 구성 요소를 설치한다.
   - Android SDK Command-line Tools (latest)
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - NDK (Side by side): 프로젝트의 빌드 요구사항에 따라 설치

NDK가 필요한 경우 Android Gradle 설정과 빌드 오류 메시지를 기준으로 버전을 확인한다. 프로젝트에서 특정 버전을 요구한다면 해당 버전을 설치한다.

공식 가이드: [Android SDK 도구 업데이트 및 설치](https://developer.android.com/studio/intro/update), [NDK 설치 및 설정](https://developer.android.com/studio/projects/install-ndk)

### 2.2 Android 라이선스 동의

터미널에서 다음 명령어를 실행한다.

```bash
flutter doctor --android-licenses
```

표시되는 라이선스 내용을 확인하고 동의한다.

### 2.3 설치 상태 확인

다음 명령어로 개발 환경을 점검한다.

```bash
flutter doctor
```

현재 개발 환경의 확인 결과:

- Flutter: 정상
- Windows: 정상
- Android toolchain: 정상
- Chrome: 정상
- Network resources: 정상
- Visual Studio: 경고

Visual Studio 관련 경고는 주로 Windows 데스크톱 앱 개발 도구와 관련된다. Android 앱 개발만 진행한다면 해당 경고를 우선 해결할 필요는 없다.

## 3. Flutter 프로젝트 생성

GitHub 저장소 루트에서 실행한다.

```bash
flutter create --org com.itda --project-name itda_app frontend
```

프로젝트 생성 후 주요 디렉터리는 다음과 같다.

```text
frontend/
├── android/        # Android 플랫폼 관련 설정
├── lib/
│   └── main.dart   # Flutter 앱 진입점
├── test/           # 테스트 코드
└── pubspec.yaml    # 패키지 의존성 및 에셋 설정
```

## 4. 의존성 설치 및 기기 확인

저장소 루트에서 Flutter 프로젝트 디렉터리로 이동한다.

```bash
cd frontend
flutter pub get
flutter devices
```

- `flutter pub get`: 프로젝트에 정의된 패키지 의존성을 설치한다.
- `flutter devices`: Flutter에서 사용할 수 있는 기기를 확인한다.

현재 개발 환경의 확인 결과:

- 패키지 의존성 설치 성공
- Windows 데스크톱 기기 인식
- Chrome 및 Edge 브라우저 인식
- Android 16 에뮬레이터 인식

기기 목록은 개발 PC의 설치 환경에 따라 달라질 수 있다.

## 5. Android 에뮬레이터에서 앱 실행

### 5.1 에뮬레이터 생성 및 실행

1. Android Studio에서 Device Manager를 연다.
2. 가상 기기를 생성한다.
3. 사용할 Android 시스템 이미지를 설치한다.
4. 생성한 에뮬레이터를 실행한다.

현재 개발 환경에서는 Android 16 에뮬레이터를 사용한다.

### 5.2 앱 실행

`frontend/` 디렉터리에서 실행한다.

```bash
flutter devices
flutter run
```

특정 에뮬레이터를 지정하려면 기기 목록에 표시된 ID를 사용한다.

```bash
flutter run -d emulator-5554
```

에뮬레이터에 기본 Flutter 앱이 표시되면 기본 실행 환경 구성이 완료된 것이다.

### 5.3 현재 확인 결과

- Flutter 프로젝트 생성 성공
- 패키지 의존성 설치 성공
- Android 에뮬레이터 인식 성공
- Android NDK 설치 및 빌드 오류 해결
- Android 에뮬레이터에서 Flutter 앱 실행 성공

위 항목은 현재 개발 환경에서 확인한 결과다.

## 6. 개발 환경 관리 원칙

- Flutter SDK와 Android SDK는 각 개발자의 로컬 환경에 설치한다.
- SDK 자체를 GitHub 저장소에 커밋하지 않는다.
- `android/local.properties`에는 개발자별 SDK 경로가 저장되므로 Git에 포함하지 않는다.
- 패키지 버전은 필요성을 확인한 후 변경한다.
- Android SDK 및 NDK 버전이 빌드에 영향을 줄 수 있으므로, 빌드 오류가 발생하면 오류 메시지와 `flutter doctor` 결과를 함께 확인한다.
- 특정 NDK 버전이 필요한 경우 프로젝트의 Android Gradle 설정을 기준으로 설치한다.
- Windows 데스크톱 앱을 개발하지 않는다면 Visual Studio 관련 경고는 우선순위가 낮다.