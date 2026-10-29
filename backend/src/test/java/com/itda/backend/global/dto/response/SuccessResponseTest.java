package com.itda.backend.global.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

class SuccessResponseTest {
    String message = "요청이 성공했습니다.";

    @Test
    @DisplayName("성공 응답을 반환한다")
    void test1() {
        // given
        String data = "test";

        // when
        SuccessResponse<String> response = SuccessResponse.success(message, data);

        // then
        assertThat(response.code()).isEqualTo("SUCCESS");
        assertThat(response.data()).isEqualTo(data);
    }

    @Test
    @DisplayName("데이터 없는 성공 응답을 반환한다")
    void test2() {
        // when
        SuccessResponse<Void> response = SuccessResponse.success(message);

        // then
        assertThat(response.code()).isEqualTo("SUCCESS");
        assertThat(response.data()).isNull();
    }
}