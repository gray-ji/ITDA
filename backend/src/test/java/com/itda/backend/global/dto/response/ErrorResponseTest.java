package com.itda.backend.global.dto.response;

import com.itda.backend.global.exception.CommonErrorCode;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ErrorResponseTest {
    @Test
    @DisplayName("오류 응답을 반환한다")
    void test1() {
        // given
        CommonErrorCode errorCode = CommonErrorCode.INVALID_REQUEST;
        String code = errorCode.getCode();
        String message = errorCode.getMessage();

        // when
        ErrorResponse response = ErrorResponse.error(code, message);

        // then
        assertThat(response.code()).isEqualTo(code);
        assertThat(response.message()).isEqualTo(message);
        assertThat(response.errors()).isNull();
    }

    @Test
    @DisplayName("검증 오류 있는 오류 응답을 반환한다")
    void test2() {
        // given
        CommonErrorCode errorCode = CommonErrorCode.INVALID_INPUT_VALUE;
        String code = errorCode.getCode();
        String message = errorCode.getMessage();

        List<ErrorResponse.ValidationError> errors = List.of(
                new ErrorResponse.ValidationError("title", "제목은 필수입니다."),
                new ErrorResponse.ValidationError("content", "내용은 필수입니다.")
        );

        // when
        ErrorResponse response = ErrorResponse.error(code, message, errors);

        // then
        assertThat(response.code()).isEqualTo(code);
        assertThat(response.message()).isEqualTo(message);
        assertThat(response.errors()).containsExactlyElementsOf(errors);
    }
}