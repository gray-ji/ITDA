# 잇다 — 데이터베이스 설계

## 1. ERD
![ERD 다이어그램](docs/images/erd.png)

## 2. 공통 설계 기준

- 모든 테이블의 기본 키는 UUID v7을 사용한다.
- 기본 키 컬럼명은 `id`로 통일한다.
- 사용자와 게시글은 논리 삭제를 지원하며, `deleted_at`에 삭제 시각을 기록한다.
- 회원 탈퇴 시 사용자와 해당 사용자의 게시글은 논리 삭제한다. 채팅방, 채팅 메시지 및 반환 기록은 보존한다.
- 논리 삭제 시 연관 데이터는 각 데이터의 삭제 정책에 따라 처리한다.
- 외래 키 삭제 정책은 기본적으로 `RESTRICT`를 적용한다.
- 날짜와 시각은 각각 `DATE`, `TIMESTAMP`로 저장한다.
- 이미지 파일은 Cloudinary에 저장하고, DB에는 Cloudinary의 이미지 식별자를 저장한다. 이미지 URL은 별도 컬럼에 저장하지 않는다.
- 최근 검색어는 프론트엔드에서 관리하며, 데이터베이스에 저장하지 않는다.
- 본 문서에 정의한 제약 조건은 실제 DB 스키마에도 반영한다.

## 3. 테이블 명세

### 3.1. users

카카오 로그인을 통해 가입한 사용자 정보를 관리한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `provider` | VARCHAR(10) | N | 로그인 제공자. 현재 `KAKAO`만 지원 |
| `provider_id` | VARCHAR(100) | N | 로그인 제공자가 발급한 사용자 식별자 |
| `nickname` | VARCHAR(30) | N | 사용자 닉네임 |
| `deleted_at` | TIMESTAMP | Y | 논리 삭제 시각. NULL이면 활성 사용자 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 사용자 식별자 |
| CHECK | `provider` | `KAKAO`만 허용 |
| UNIQUE | (`provider`, `provider_id`) | 동일한 로그인 제공자 계정의 중복 가입 방지 |

### 3.2. device_tokens

사용자의 푸시 알림 전송에 사용하는 기기 토큰을 관리한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `user_id` | UUID | N | 토큰을 등록한 사용자 ID |
| `token` | TEXT | N | FCM 푸시 알림 전송에 사용하는 기기 토큰 |
| `platform` | VARCHAR(10) | N | 기기 플랫폼. `ANDROID`, `IOS` |
| `created_at` | TIMESTAMP | N | 등록 시각 |
| `updated_at` | TIMESTAMP | N | 마지막 수정 시각 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 기기 토큰 식별자 |
| FK | `user_id` | `users.id` 참조 |
| CHECK | `platform` | `ANDROID`, `IOS`만 허용 |
| UNIQUE | `token` | 동일한 기기 토큰의 중복 등록 방지 |

#### 인덱스

| 대상 | 목적 |
|---|---|
| `user_id` | 사용자별 기기 토큰 조회 |

### 3.3. posts

사용자가 등록한 분실물 및 습득물 게시글을 관리한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `user_id` | UUID | N | 게시글 작성자 ID |
| `type` | VARCHAR(10) | N | 게시글 유형. `LOST`, `FOUND` |
| `category` | VARCHAR(30) | N | 물건 카테고리. `4. 물건 카테고리 코드값 정의` 참조 |
| `title` | VARCHAR(100) | N | 게시글 제목. 물건명과 동일 |
| `feature` | TEXT | Y | 물건 특징 |
| `status` | VARCHAR(20) | N | 게시글 상태. `LOOKING`, `STORED`, `RETURNED` |
| `occurred_from` | DATE | Y | 분실·습득 발생일 또는 추정 기간의 시작일 |
| `occurred_to` | DATE | Y | 분실·습득 추정 기간의 종료일. NULL이면 종료일이 별도로 필요하지 않음을 의미 |
| `location` | VARCHAR(100) | N | 분실·습득 장소 |
| `created_at` | TIMESTAMP | N | 게시글 작성 시각 및 기본 정렬 기준 |
| `updated_at` | TIMESTAMP | N | 마지막 수정 시각 |
| `deleted_at` | TIMESTAMP | Y | 논리 삭제 시각. NULL이면 삭제되지 않은 게시글 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 게시글 식별자 |
| FK | `user_id` | `users.id` 참조 |
| CHECK | `type` | `LOST`, `FOUND`만 허용 |
| CHECK | `category` | 정의된 카테고리 저장값만 허용 |
| CHECK | `status` | `LOOKING`, `STORED`, `RETURNED`만 허용 |
| CHECK | (`occurred_from`, `occurred_to`) | 종료일이 지정된 경우 시작일도 필수이며, 종료일은 시작일보다 빠를 수 없음 |

#### 이미지 관리 기준

- 이미지가 없는 게시글도 등록할 수 있다.
- 게시글 이미지는 최대 5장까지 등록할 수 있다.
- 이미지 표시 순서는 `post_images.sort_order`로 관리하며 첫 번째 이미지를 대표 이미지로 사용한다.
- 이미지 개수 제한은 여러 행에 걸친 검증이므로 애플리케이션 서비스 계층에서 검증한다.

#### 인덱스

| 대상 | 목적 |
|---|---|
| (`user_id`, `id DESC`) | 작성자별 게시글 조회 |

### 3.4. post_images

게시글에 첨부한 이미지를 관리한다. 이미지 파일 자체는 Cloudinary에 저장하고, `public_id`로 해당 이미지를 식별한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `post_id` | UUID | N | 이미지가 속한 게시글 ID |
| `public_id` | VARCHAR(100) | N | Cloudinary 이미지 식별자. `itda/posts/{UUID}` 형식 |
| `sort_order` | SMALLINT | N | 게시글 내 이미지 표시 순서. 첫 번째 이미지가 대표 이미지 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 이미지 레코드 식별자 |
| FK | `post_id` | `posts.id` 참조 |
| CHECK | `sort_order` | 이미지 표시 순서는 1부터 5까지의 정수만 허용 |
| UNIQUE | `public_id` | Cloudinary 이미지 식별자의 중복 등록 방지 |
| 복합 UNIQUE | (`post_id`, `sort_order`) | 동일 게시글 내 이미지 순서 중복 방지 |

### 3.5. image_deletion_tasks

이미지 삭제 작업을 관리한다. DB에서 이미지 정보가 삭제되더라도 Cloudinary 삭제에 실패한 작업을 보존하고 재시도할 수 있도록 한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `public_id` | VARCHAR(100) | N | 삭제할 Cloudinary 이미지 식별자 |
| `status` | VARCHAR(20) | N | 삭제 상태. `PENDING`, `COMPLETED`, `FAILED` |
| `retry_count` | INTEGER | N | 삭제 재시도 횟수. 기본값 0 |
| `created_at` | TIMESTAMP | N | 삭제 작업 생성 시각 |
| `updated_at` | TIMESTAMP | N | 작업 상태 변경 시각 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 삭제 작업 식별자 |
| CHECK | `status` | `PENDING`, `COMPLETED`, `FAILED`만 허용 |
| CHECK | `retry_count` | 0 이상 |

#### 인덱스

| 대상 | 목적 |
|---|---|
| (`status`, `id`) | 대기 작업을 생성 순서대로 조회 |

#### 처리 규칙

- 이미지 삭제와 삭제 작업 기록은 동일한 DB 트랜잭션에서 처리한다.
- 커밋 이후 서버가 `PENDING` 작업을 조회해 Cloudinary 이미지 삭제를 요청한다.
- 최초 시도를 포함해 최대 3회까지 삭제를 시도한다. 모든 시도가 실패하면 `FAILED`로 변경한다.
- `FAILED` 작업은 운영자가 확인하고 재처리할 수 있어야 한다.
- Cloudinary에서 이미 삭제된 이미지를 다시 삭제하려는 경우에도 성공으로 처리할 수 있도록 한다.

### 3.6. chats

분실자와 습득자 간의 1:1 채팅방을 관리한다. 채팅방은 첫 메시지를 전송할 때 생성하며, 채팅방 생성과 첫 메시지 저장은 하나의 트랜잭션으로 처리한다. 따라서 메시지가 없는 채팅방은 존재하지 않으며, `last_message_at`은 항상 마지막 메시지 시각을 나타낸다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `lost_user_id` | UUID | N | 분실자 역할을 맡은 사용자 ID |
| `found_user_id` | UUID | N | 습득자 역할을 맡은 사용자 ID |
| `lost_post_id` | UUID | Y | 관련 분실물 게시글 ID. 분실물 게시글 없이 대화를 시작하면 NULL |
| `found_post_id` | UUID | Y | 관련 습득물 게시글 ID. 습득물 게시글 없이 대화를 시작하면 NULL |
| `last_message_at` | TIMESTAMP | N | 마지막 메시지 시각 및 채팅방 정렬 기준 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 채팅방 식별자 |
| FK | `lost_user_id` | `users.id` 참조 |
| FK | `found_user_id` | `users.id` 참조 |
| FK | `lost_post_id` | `posts.id` 참조 |
| FK | `found_post_id` | `posts.id` 참조 |
| CHECK | (`lost_user_id`, `found_user_id`) | 두 참여자는 서로 다른 사용자여야 함 |
| CHECK | (`lost_post_id`, `found_post_id`) | 두 게시글 ID가 모두 NULL인 채팅방은 허용하지 않음 |

#### 유니크 인덱스

게시글 ID는 NULL일 수 있으므로, 일반적인 복합 UNIQUE 제약 조건만으로는 한쪽 게시글만 연결된 채팅방의 중복 생성을 모두 방지할 수 없다. 다음과 같이 조건별 부분 유니크 인덱스를 적용한다.

| 대상 | 조건 | 목적 |
|---|---|---|
| (`lost_user_id`, `found_user_id`, `lost_post_id`, `found_post_id`) | 두 게시글 ID가 모두 NOT NULL | 동일한 참여자 쌍과 게시글 조합의 중복 방지 |
| (`lost_user_id`, `found_user_id`, `lost_post_id`) | `lost_post_id`는 NOT NULL, `found_post_id`는 NULL | 분실물 게시글만 연결된 채팅방의 중복 방지 |
| (`lost_user_id`, `found_user_id`, `found_post_id`) | `lost_post_id`는 NULL, `found_post_id`는 NOT NULL | 습득물 게시글만 연결된 채팅방의 중복 방지 |

#### 인덱스

| 대상 | 목적 |
|---|---|
| `last_message_at` | 최근 메시지 순 채팅방 조회 |
| (`lost_user_id`, `last_message_at DESC, id`) | 분실자 역할의 채팅방 목록 조회 |
| (`found_user_id`, `last_message_at DESC, id`) | 습득자 역할의 채팅방 목록 조회 |

### 3.7. chat_messages

채팅방에서 주고받은 텍스트 메시지와 이미지 메시지를 관리한다. 메시지 저장·조회와 FCM 푸시 알림 전송은 별도로 처리한다. 푸시 전송 실패가 메시지 저장 실패를 의미하지는 않는다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `chat_id` | UUID | N | 메시지가 속한 채팅방 ID |
| `sender_id` | UUID | N | 메시지를 보낸 사용자 ID |
| `content` | VARCHAR(1000) | Y | 텍스트 메시지 내용. 이미지 메시지에서는 NULL |
| `public_id` | VARCHAR(100) | Y | Cloudinary 이미지 식별자. `itda/chats/{UUID}` 형식. 텍스트 메시지에서는 NULL |
| `created_at` | TIMESTAMP | N | 메시지 작성 시각 및 채팅 메시지 정렬 기준 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 메시지 식별자 |
| FK | `chat_id` | `chats.id` 참조 |
| FK | `sender_id` | `users.id` 참조 |
| UNIQUE | `public_id` | 이미지 식별자의 중복 등록 방지. NULL은 여러 건 허용 가능 |
| CHECK | (`content`, `public_id`) | 텍스트 메시지와 이미지 메시지는 상호 배타적이며, 둘 중 정확히 하나만 값이 존재해야 함 |

#### 인덱스

| 대상 | 목적 |
|---|---|
| (`chat_id`, `id`) | 채팅방별 메시지 조회 및 시간순 정렬 |

### 3.8. return_records

분실물과 습득물의 반환 완료 및 취소 이력을 관리한다. 취소된 반환 기록도 삭제하지 않고 이력으로 보존한다.

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `lost_user_id` | UUID | N | 실제 분실자 사용자 ID |
| `found_user_id` | UUID | N | 실제 습득자 사용자 ID |
| `lost_post_id` | UUID | Y | 관련 분실물 게시글 ID. 해당 게시글이 없으면 NULL |
| `found_post_id` | UUID | Y | 관련 습득물 게시글 ID. 해당 게시글이 없으면 NULL |
| `status` | VARCHAR(10) | N | 반환 상태. `COMPLETED`, `CANCELED` |
| `created_at` | TIMESTAMP | N | 반환 기록 생성 시각. 반환 완료 처리 시각과 동일 |
| `updated_at` | TIMESTAMP | N | 마지막 수정 시각 |
| `canceled_at` | TIMESTAMP | Y | 반환 기록 취소 시각. 취소 전에는 NULL |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 반환 기록 식별자 |
| FK | `lost_user_id` | `users.id` 참조 |
| FK | `found_user_id` | `users.id` 참조 |
| FK | `lost_post_id` | `posts.id` 참조 |
| FK | `found_post_id` | `posts.id` 참조 |
| CHECK | (`lost_user_id`, `found_user_id`) | 분실자와 습득자는 서로 다른 사용자여야 함 |
| CHECK | (`lost_post_id`, `found_post_id`) | 두 게시글 ID가 모두 NULL인 반환 기록은 허용하지 않음 |
| CHECK | `status` | `COMPLETED`, `CANCELED`만 허용 |

#### 데이터 관리 기준

- 실제 반환 당사자의 사용자 정보를 기록하며, 존재하는 게시글만 반환 기록에 연결한다.
- 취소된 반환 기록도 삭제하지 않고 이력으로 보존한다.
- 같은 당사자가 다시 반환을 진행하면 기존 기록을 재사용하지 않고 새로운 반환 기록을 생성한다.

### 3.9. notifications

알림 목록 조회에 사용할 알림 데이터를 저장한다. FCM 푸시 전송 내역과 payload는 저장하지 않는다.

#### 컬럼 명세

| 컬럼 | 타입 | NULL | 설명 |
|---|---|---|---|
| `id` | UUID | N | PK, UUID v7 |
| `user_id` | UUID | N | 알림 수신 사용자 ID |
| `chat_room_id` | UUID | N | 관련 채팅방 ID |
| `message_id` | UUID | N | 알림과 관련된 채팅 메시지 ID |
| `return_record_id` | UUID | N | 관련 반환 기록 ID |
| `type` | VARCHAR(20) | N | 알림 목록 항목 유형. `RETURN_COMPLETED`, `RETURN_CANCELED` |
| `content` | VARCHAR(120) | N | 사용자에게 표시할 알림 내용 |
| `is_read` | BOOLEAN | N | 읽음 여부. 기본값 `FALSE` |
| `created_at` | TIMESTAMP | N | 알림 생성 시각 |

#### 제약 조건

| 유형 | 대상 | 설명 |
|---|---|---|
| PK | `id` | 알림 식별자 |
| FK | `user_id` | `users.id` 참조 |
| FK | `chat_room_id` | `chats.id` 참조 |
| FK | `message_id` | `chat_messages.id` 참조 |
| FK | `return_record_id` | `return_records.id` 참조 |
| CHECK | `type` | `RETURN_COMPLETED`, `RETURN_CANCELED`만 허용 |

#### 인덱스

| 대상 | 목적 |
|---|---|
| (`user_id`, `is_read`, `id`) | 사용자별 읽지 않은 알림 및 최신순 조회 |

## 4. 물건 카테고리 코드값 정의

분실물과 습득물 게시글은 동일한 카테고리 목록을 사용한다.

| 카테고리명 | 예시 |
|---|---|
| `ELECTRONICS` | 휴대전화, 태블릿, 노트북, 이어폰, 충전기 |
| `WALLET_MONEY_ID` | 지갑, 현금, 신분증, 신용카드, 체크카드, 교통카드 |
| `FASHION` | 체육복, 외투, 모자, 가방, 신발, 안경 |
| `DAILY_GOODS` | 우산, 텀블러, 물병, 화장품, 열쇠 |
| `STATIONERY_BOOKS` | 필기구, 필통, 책, 노트 |
| `SPORTS_LEISURE` | 공, 라켓, 운동 장비, 캠핑용품 |
| `BABY_GOODS` | 젖병, 유아용 가방, 유아용품 |
| `PET_SUPPLIES` | 목줄, 하네스, 반려동물 장난감 |
| `FOOD` | 도시락, 간식, 과자, 음료 |
| `OTHER` | 위 분류에 해당하지 않는 물건 |