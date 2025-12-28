# Feature/Sacheon 브랜치 작업 내용

## 개요
이 브랜치에서는 여러 프린터 동시 제어 및 NGPCL 프로토콜 지원을 위한 확장 가능한 아키텍처를 구현했습니다.

## 주요 변경 사항

### 1. 프로토콜 타입 추상화 ✅

#### `lib/core/enums/printer_protocol.dart`
- `PrinterProtocol` enum 추가 (zipher, ngpcl)
- 모델명으로부터 프로토콜 타입을 자동 추론하는 확장 메서드 구현

#### `lib/core/factories/printer_socket_factory.dart`
- 팩토리 패턴으로 프로토콜 타입에 따라 적절한 소켓 구현체 생성
- `create(PrinterProtocol)`: 프로토콜 타입으로 생성
- `createFromModel(String)`: 모델명으로부터 자동 생성

### 2. ManagedPrinter 프로토콜 독립화 ✅

#### `lib/domain/entities/managed_printer.dart`
- `ZipherSocket` 직접 의존 제거
- `PrinterSocket` 인터페이스에 의존하도록 변경
- `protocol` 필드 추가
- 생성자에서 팩토리 패턴 사용

**변경 전:**
```dart
final ZipherSocket socket;
```

**변경 후:**
```dart
final PrinterSocket socket;
final PrinterProtocol protocol;
```

### 3. NGPCL 프로토콜 구현 ✅

#### `lib/infra/ngpcl_socket.dart`
- `NGPCLSocket` 클래스 생성
- `PrinterSocket` 인터페이스 구현
- Zipher와 유사한 명령어 구조 사용
- Unsolicited data 처리 지원

**주요 명령어:**
- `GST`: 프린터 상태 조회
- `SST|3|`: 프린터 Running 상태
- `SST|4|`: 프린터 Offline 상태
- `SEL|jobName|`: Job 선택
- `GJD|field|`: Job 데이터 요청
- `JDA|field=value|`: 필드 업데이트
- `PRN`: 인쇄 실행

### 4. 여러 프린터 동시 제어 ✅

#### `lib/core/services/printer_coordinator.dart`
- 여러 프린터를 동시에 관리하는 코디네이터 클래스
- 동시 연결, 동시 작업 할당, 동시 상태 조회 지원

**주요 기능:**
- `connectAll()`: 모든 프린터 동시 연결
- `assignPrintJobsConcurrently()`: 여러 프린터에 동시 작업 할당
- `getAllStatuses()`: 모든 프린터 상태 동시 조회
- `disconnectAll()`: 모든 프린터 연결 해제

### 5. 매퍼 업데이트 ✅

#### `lib/data/mappers/printer_response_data_mapper.dart`
- `PrinterData.toManagedPrinter()` 확장 메서드 수정
- 모델명으로부터 프로토콜 타입 자동 추론
- 팩토리를 사용하여 적절한 소켓 생성

## 아키텍처 개선 사항

### 확장성
- 새로운 프로토콜 추가 시 `PrinterSocket` 인터페이스만 구현하면 됨
- 팩토리 패턴으로 프로토콜 타입에 따른 소켓 생성 자동화
- `ManagedPrinter`가 프로토콜에 독립적

### 동시성
- `PrinterCoordinator`를 통한 여러 프린터 동시 제어
- `Future.wait()`를 사용한 병렬 처리

### 유지보수성
- 프로토콜별 구현체 분리
- 인터페이스 기반 설계로 테스트 용이

## 사용 방법

### 1. 프린터 생성 (자동 프로토콜 감지)
```dart
// API 응답에서 자동으로 프로토콜 타입 추론
final printer = printerData.toManagedPrinter();
// 모델명에 따라 Zipher 또는 NGPCL 소켓이 자동 생성됨
```

### 2. 여러 프린터 동시 연결
```dart
final coordinator = PrinterCoordinator();
coordinator.addPrinter(printer1);
coordinator.addPrinter(printer2);

final results = await coordinator.connectAll();
// 모든 프린터가 동시에 연결 시도됨
```

### 3. 여러 프린터에 동시 작업 할당
```dart
final assignments = [
  PrintJobAssignment(
    printerId: 1,
    jobName: "job1",
    uniqueCode: "CODE001",
    start: 0,
    end: 100,
  ),
  PrintJobAssignment(
    printerId: 2,
    jobName: "job2",
    uniqueCode: "CODE002",
    start: 0,
    end: 100,
  ),
];

final results = await coordinator.assignPrintJobsConcurrently(
  assignments: assignments,
);
// 두 프린터가 동시에 작업을 시작함
```

## 다음 단계 (선택 사항)

1. **NGPCL 프로토콜 명령어 세부 구현**
   - 실제 NGPCL 프로토콜 스펙에 맞게 명령어 형식 조정
   - NGPCL 특화 기능 추가

2. **프로토콜 타입 명시적 저장**
   - API 응답에 `protocol` 필드 추가
   - 데이터베이스에 프로토콜 타입 저장

3. **에러 처리 강화**
   - 프로토콜별 에러 처리 로직
   - 연결 실패 시 재시도 로직

4. **테스트 코드 작성**
   - 프로토콜 팩토리 테스트
   - 동시 제어 테스트

## 주의 사항

1. **기존 UI 변경 없음**: UI 레이어는 수정하지 않았습니다.
2. **하위 호환성**: 기존 Zipher 프린터는 그대로 동작합니다.
3. **NGPCL 명령어**: 현재는 Zipher와 유사한 구조로 구현되어 있으며, 실제 NGPCL 스펙에 맞게 조정이 필요할 수 있습니다.

## 파일 구조

```
lib/
├── core/
│   ├── enums/
│   │   └── printer_protocol.dart          # 프로토콜 타입 enum
│   ├── factories/
│   │   └── printer_socket_factory.dart     # 소켓 팩토리
│   ├── interfaces/
│   │   └── printer_socket.dart             # 기존 인터페이스
│   └── services/
│       └── printer_coordinator.dart        # 여러 프린터 동시 제어
├── domain/
│   └── entities/
│       └── managed_printer.dart            # 프로토콜 독립적으로 수정
├── infra/
│   ├── zipher_socket.dart                  # 기존 Zipher 구현
│   └── ngpcl_socket.dart                   # 새로운 NGPCL 구현
└── data/
    └── mappers/
        └── printer_response_data_mapper.dart # 매퍼 업데이트
```

