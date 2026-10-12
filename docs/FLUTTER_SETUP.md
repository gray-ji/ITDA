# 잇다 — Flutter 개발 환경 설정 (Windows 기준)

## 1. 개발 도구 설치

### 1.1 VS Code 및 Flutter 확장 프로그램

1. VS Code를 설치한다.
2. Extensions에서 `Flutter`를 검색한다.
3. Dart Code에서 제공하는 Flutter 확장 프로그램을 설치한다.
4. Flutter SDK를 설치하고 PATH를 설정한다.

🔗 공식 가이드: https://docs.flutter.dev/install/with-vs-code

### 1.2 Flutter SDK 확인

터미널에서 다음 명령어를 실행한다.

```bash
flutter --version
```

현재 확인 버전: Flutter 3.47.7 (stable)

### 2.3 Android Studio 및 Android SDK

Android 앱 빌드와 실행을 위해 Android Studio와 Android SDK를 설치한다.

1. Android Studio를 설치하고 초기 설정을 진행한다.
2. SDK Manager에서 필요한 Android SDK 플랫폼을 설치한다.
3. SDK Tools 탭에서 다음 항목을 설치한다.
   - Android SDK Command-line Tools (latest)
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - NDK (Side by side)

4. NDK 버전은 프로젝트의 Android Gradle 설정 및 빌드 요구사항을 기준으로 선택한다.

🔗 공식 다운로드: https://developer.android.com/studio

### 2.4 Android 라이선스 동의

터미널에서 다음 명령어를 실행한다.

```bash
flutter doctor --android-licenses
```

라이선스 내용을 확인하고 동의한다.

### 2.5 설치 상태 확인

```bash
flutter doctor
```

현재 확인 결과:

- Flutter: 정상
- Windows: 정상
- Android toolchain: 정상
- Chrome: 정상
- Network resources: 정상
- Visual Studio: 경고

Visual Studio 경고는 주로 Windows 데스크톱 앱 개발과 관련된 항목이다. Android 앱 개발만 진행한다면 현재 필수 사항은 아니다.

## 3. 프로젝트 생성

GitHub 저장소 루트에서 실행한다.

```bash
flutter create --org com.itda --project-name itda_app frontend
```

프로젝트 구조:

```text
ITDA/
├── frontend/
│   ├── android/
│   ├── lib/
│   │   └── main.dart
│   ├── test/
│   └── pubspec.yaml
├── backend/
├── docs/
└── README.md
```

주요 파일 및 디렉터리:

- `frontend/lib/main.dart`: Flutter 앱 진입점
- `frontend/pubspec.yaml`: 패키지 의존성 및 에셋 설정
- `frontend/android/`: Android 플랫폼 관련 설정
- `frontend/test/`: 테스트 코드
- `backend/`: Spring Boot 백엔드
- `docs/`: 프로젝트 및 개발 관련 문서

## 4. 의존성 설치 및 기기 확인

저장소 루트에서 Flutter 프로젝트 폴더로 이동한다.

```bash
cd frontend
flutter pub get
flutter devices
```

- `flutter pub get`: 프로젝트에 정의된 패키지 의존성을 설치한다.
- `flutter devices`: Flutter에서 사용할 수 있는 기기를 확인한다.

현재 확인 결과:

- 패키지 의존성 설치 성공
- Windows 데스크톱 기기 인식
- Chrome 및 Edge 브라우저 인식
- Android 16 에뮬레이터 인식

## 5. Android 에뮬레이터에서 앱 실행

### 5.1 에뮬레이터 생성 및 실행

1. Android Studio에서 Device Manager를 연다.
2. 가상 기기를 생성한다.
3. Android 시스템 이미지를 설치한다.
4. 에뮬레이터를 실행한다.

현재 개발 환경에서는 Android 16 에뮬레이터를 사용한다.

### 5.2 앱 실행

`frontend/` 디렉터리에서 실행한다.

```bash
flutter devices
flutter run
```

특정 에뮬레이터를 지정하려면 다음과 같이 실행할 수 있다.

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

## 6. 참고 사항

- Flutter SDK와 Android SDK는 개발자별 로컬 환경에 설치한다.
- SDK 자체를 GitHub 저장소에 커밋하지 않는다.
- `android/local.properties`에는 개발자별 SDK 경로가 저장되므로 Git에 포함하지 않는다.
- 패키지 버전 업데이트는 필요성을 확인한 후 진행한다.
- Android SDK 및 NDK 버전이 빌드에 영향을 줄 수 있으므로, 빌드 오류가 발생하면 오류 메시지와 `flutter doctor` 결과를 함께 확인한다.
- Windows 데스크톱 앱을 개발하지 않는다면 Visual Studio 관련 경고는 우선순위가 낮다.

## 7. 다음 작업

1. 초기 Flutter 프로젝트를 GitHub에 커밋 및 Push한다.
2. `frontend/lib/main.dart`를 확인하고 앱 기본 구조를 정리한다.
3. 화면 설계 문서를 참고해 화면별 위젯과 이동 구조를 구현한다.
4. 백엔드 API 연동을 준비한다.