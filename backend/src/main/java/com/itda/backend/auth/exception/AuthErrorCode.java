package com.itda.backend.auth.exception;

import com.itda.backend.global.exception.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum AuthErrorCode implements ErrorCode {
    // TODO: 코드와 메시지는 API Rules의 오류 코드 표와 맞추기
    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "AUTH-001", "인증이 필요합니다."),
    KAKAO_AUTH_FAILED(HttpStatus.UNAUTHORIZED, "AUTH-003", "카카오 인증에 실패했습니다.");

    private final HttpStatus status;
    private final String code;
    private final String message;
}