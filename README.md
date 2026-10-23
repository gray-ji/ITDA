# 잇다

**분실물과 습득물을 연결하는 매칭 서비스**

분실물과 습득물 정보를 등록하고, 물건의 종류·장소·날짜·특징을 바탕으로 관련 게시글을 매칭해 분실물을 찾을 수 있도록 돕는 모바일 서비스입니다.

분실자와 습득자가 서로 소통하고, 실제 반환 과정을 관리할 수 있도록 지원합니다.

## 주요 기능

- **카카오 로그인:** 카카오 계정으로 사용자를 인증하고, 최초 로그인 시 서비스 계정을 생성
- **게시글 관리:** 분실물·습득물 게시글 등록·조회·수정·삭제
- **게시글 검색·필터링:** 게시글 유형, 상태, 카테고리, 키워드, 날짜, 장소를 기준으로 검색·필터링
- **규칙 기반 게시글 매칭:** 카테고리, 날짜, 장소, 특징의 유사도를 바탕으로 관련 게시글 추천
- **채팅방·메시지 관리:** 텍스트·이미지 메시지 전송 및 기존 대화 내역 조회
- **메시지 푸시 알림:** 새 채팅 메시지 도착 시 FCM 푸시 알림 전송 및 해당 채팅방으로 이동
- **반환 상태 관리:** 반환 완료 처리, 반환 기록 조회, 반환 기록 취소 및 관련 게시글 상태 복구
- **마이페이지:** 프로필, 내 게시글, 반환 기록 및 실제 반환 상대 정보 확인

매칭은 실제 소유자를 확정하는 기능이 아니라, 사용자가 확인해야 할 관련 게시글을 추천하는 기능입니다.

로그인을 제외한 모든 서비스 기능은 로그인 사용자만 이용할 수 있습니다.

## 기술 스택

| 구분 | 기술 | 용도 |
| --- | --- | --- |
| Frontend | Flutter, Dart | 모바일 애플리케이션 |
| Backend | Java 21, Spring Boot | REST API 및 서비스 로직 |
| Database | PostgreSQL | 사용자, 게시글, 채팅, 반환 기록 저장 |
| Image Storage | Cloudinary | 게시글 및 채팅 이미지 저장 |
| Push Notification | Firebase Cloud Messaging | 메시지 푸시 알림 |
| CI | GitHub Actions | 자동 빌드 및 테스트 |
| Deployment | Render | 백엔드 배포 및 데이터베이스 연동 |
| Version Control | Git, GitHub | 소스 코드 관리 및 협업 |

## 시스템 구성

![시스템 구조도](docs/images/sys-architecture.png)

- **Flutter:** 사용자 인터페이스와 사용자 입력을 처리하고 백엔드 REST API를 호출합니다.
- **Spring Boot:** 카카오 인증 검증, 접근 권한 확인, 게시글 관리, 검색, 매칭 추천, 채팅 및 반환 기록 관련 로직을 처리합니다.
- **PostgreSQL:** 사용자, 게시글, 채팅, 반환 기록 및 필요한 서비스 데이터를 저장합니다.
- **Cloudinary:** 게시글과 채팅에 첨부된 이미지를 저장합니다. PostgreSQL에는 Cloudinary의 이미지 식별자를 저장하며, 이미지 조회에 필요한 URL은 서버에서 접근 권한을 확인한 뒤 처리합니다.
- **Firebase Cloud Messaging:** 새 채팅 메시지가 도착하면 상대방에게 푸시 알림을 전송합니다. 푸시 전송은 메시지 저장과 분리해 처리합니다.
- **GitHub Actions:** 변경된 파일 경로를 기준으로 필요한 백엔드 빌드·테스트 또는 프론트엔드 정적 분석·테스트를 실행합니다.

백엔드와 데이터베이스는 Render 배포 환경에서 연동하며, 카카오 로그인부터 게시글 등록·검색, 매칭 후보 확인, 채팅 및 반환 처리까지 주요 흐름이 정상적으로 동작하는지 검증합니다.

## 프로젝트 구조

```text
ITDA/
├── .github/workflows/  # GitHub Actions CI
├── frontend/           # Flutter 모바일 앱
├── backend/            # Spring Boot 서버
├── docs/               # 프로젝트 문서
├── .env.example        # 환경 변수 예시
├── docker-compose.yml  # 로컬 개발 환경
└── README.md           # 프로젝트 소개 및 실행 안내
```

프론트엔드는 기능별로 코드를 분리하고 공통 기반 코드는 별도로 관리합니다. 상세한 디렉터리 구성과 개발 규칙은 [TEAM](docs/TEAM.md)을 참고합니다.

## 프로젝트 문서

| 문서 | 설명 |
|---|---|
| [PRD](docs/PRD.md) | 프로젝트 목적, 요구사항, MVP 범위 및 완료 기준 |
| [SCREEN](docs/SCREEN.md) | 화면 구성 및 사용자 이동 흐름 |
| [ERD](docs/ERD.md) | 데이터베이스 구조 및 테이블 관계 |
| [API](docs/api.yaml) | OpenAPI 기반 백엔드 API 명세 |
| [MATCHING](docs/MATCHING.md) | 매칭 기준 및 점수 산정 규칙 |
| [TEAM](docs/TEAM.md) | 팀 구성, 역할 및 협업 방식 |
| [FLUTTER SETUP](docs/FLUTTER_SETUP.md) | Windows 기준 Flutter 개발 환경 구성 및 Android 앱 실행 |

## 실행 방법

### 사전 준비

- Git
- Flutter SDK 및 Android SDK
- Java 21
- Docker Desktop
- Android 에뮬레이터 또는 실행 가능한 Android 기기

일부 기능을 실행하거나 테스트하려면 PostgreSQL, Cloudinary, Firebase 및 카카오 로그인 관련 추가 설정이 필요합니다.

### 1. 저장소 복제

```bash
git clone https://github.com/gray-ji/ITDA.git
cd ITDA
```

### 2. 프론트엔드 실행

Android 에뮬레이터 또는 Android 기기를 준비한 뒤 다음 명령어를 실행합니다.

```bash
cd frontend
flutter pub get
flutter run
```

백엔드 API 주소, 카카오 로그인 설정 및 필요한 환경 설정은 실행 환경에 맞게 구성해야 합니다.

Windows에서의 상세한 설치 및 설정 방법은 [FLUTTER SETUP](docs/FLUTTER_SETUP.md)을 참고합니다.

### 3. 백엔드 실행

#### 환경 변수 설정

프로젝트 루트에서 `.env.example` 파일을 복사하여 `.env` 파일을 생성합니다.

**Windows (PowerShell)**

```powershell
Copy-Item .env.example .env
```

**macOS / Linux**

```bash
cp .env.example .env
```

`.env` 파일에 로컬 개발 환경에 필요한 값을 설정합니다. 실제 환경 변수 이름과 필수 항목은 `.env.example` 및 백엔드 설정을 기준으로 확인합니다.

#### PostgreSQL 실행

프로젝트 루트에서 다음 명령어를 실행합니다.

```bash
docker compose up -d
```

컨테이너 상태를 확인합니다.

```bash
docker compose ps
```

#### Spring Boot 실행

백엔드 디렉터리로 이동합니다.

```bash
cd backend
```

**Windows (PowerShell)**

```powershell
.\gradlew.bat bootRun
```

**macOS / Linux**

```bash
./gradlew bootRun
```

## 테스트

GitHub Actions는 변경된 파일 경로를 기준으로 필요한 작업을 실행합니다.

- **Backend:** Gradle 빌드 및 테스트
- **Frontend:** Flutter 의존성 설치, 정적 분석 및 테스트

### Backend 테스트

```bash
cd backend
./gradlew test
```

Windows에서는 다음 명령어를 사용합니다.

```powershell
cd backend
.\gradlew.bat test
```

Testcontainers를 사용하는 백엔드 테스트는 Docker 실행 환경이 필요합니다.

### Frontend 테스트

```bash
cd frontend
flutter analyze
flutter test
```

프론트엔드 테스트는 정적 분석과 테스트 코드 실행을 통해 기본적인 코드 품질을 확인합니다.

## 배포

백엔드 및 데이터베이스는 Render를 이용해 배포하고, Flutter 앱과 배포된 API를 연동합니다.

배포 환경의 비밀값과 서비스별 설정은 환경 변수 등으로 관리하며, 민감한 인증 정보를 소스 코드에 포함하지 않습니다.