package com.itda.backend.global.exception;

import com.itda.backend.global.dto.response.ErrorResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {
    // 비즈니스 예외
    @ExceptionHandler(BaseException.class)
    public ResponseEntity<ErrorResponse> handleBaseException(BaseException e) {
        return buildResponse(e.getErrorCode());
    }

    // 입력값 검증 실패
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(MethodArgumentNotValidException e) {
        ErrorCode errorCode = CommonErrorCode.INVALID_INPUT_VALUE;

        List<ErrorResponse.ValidationError> errors = e.getBindingResult().getFieldErrors().stream()
                .map(error -> new ErrorResponse.ValidationError(error.getField(), error.getDefaultMessage()))
                .toList();

        return buildResponse(errorCode, errors);
    }

    // 잘못된 JSON 또는 요청 본문 형식
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleHttpMessageNotReadable(HttpMessageNotReadableException e) {
        return buildResponse(CommonErrorCode.INVALID_REQUEST);
    }

    // 찾을 수 없는 리소스
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ErrorResponse> handleNoResourceFound(NoResourceFoundException e) {
        return buildResponse(CommonErrorCode.RESOURCE_NOT_FOUND);
    }

    // 지원하지 않는 HTTP 메서드
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ErrorResponse> handleMethodNotSupported(HttpRequestMethodNotSupportedException e) {
        return buildResponse(CommonErrorCode.METHOD_NOT_ALLOWED);
    }

    // 예상하지 못한 서버 오류
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception e) {
        return buildResponse(CommonErrorCode.INTERNAL_SERVER_ERROR);
    }

    private ResponseEntity<ErrorResponse> buildResponse(ErrorCode errorCode) {
        return buildResponse(errorCode, null);
    }

    private ResponseEntity<ErrorResponse> buildResponse(ErrorCode errorCode, List<ErrorResponse.ValidationError> errors) {
        return ResponseEntity.status(errorCode.getStatus())
                .body(ErrorResponse.error(errorCode.getCode(), errorCode.getMessage(), errors));
    }
}