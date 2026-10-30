package com.itda.backend.global.exception;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(controllers = TestController.class)
@Import(GlobalExceptionHandler.class)
@AutoConfigureMockMvc(addFilters = false)
class GlobalExceptionHandlerTest {
    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("비즈니스 예외 발생 시 오류 응답을 반환한다")
    void handleBaseException() throws Exception {
        ErrorCode errorCode = CommonErrorCode.INVALID_REQUEST;

        mockMvc.perform(get("/test/business-error"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()));
    }

    @Test
    @DisplayName("입력값 검증 실패 시 오류 응답을 반환한다")
    void handleValidationException() throws Exception {
        ErrorCode errorCode = CommonErrorCode.INVALID_INPUT_VALUE;

        mockMvc.perform(post("/test/validation")
                        .contentType("application/json")
                        .content("{ \"title\": \"\" } "))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()))
                .andExpect(jsonPath("$.errors[0].field")
                        .value("title"))
                .andExpect(jsonPath("$.errors[0].message")
                        .value("제목은 필수입니다."));
    }

    @Test
    @DisplayName("잘못된 JSON 요청 시 오류 응답을 반환한다")
    void handleHttpMessageNotReadable() throws Exception {
        ErrorCode errorCode = CommonErrorCode.INVALID_REQUEST;

        mockMvc.perform(post("/test/json")
                        .contentType("application/json")
                        .content("{ invalid json }"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()));
    }

    @Test
    @DisplayName("찾을 수 없는 리소스 요청 시 오류 응답을 반환한다")
    void handleNoResourceFound() throws Exception {
        ErrorCode errorCode = CommonErrorCode.RESOURCE_NOT_FOUND;

        mockMvc.perform(get("/test/resource-not-found"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()));
    }

    @Test
    @DisplayName("지원하지 않는 HTTP 메서드 요청 시 오류 응답을 반환한다")
    void handleMethodNotSupported() throws Exception {
        ErrorCode errorCode = CommonErrorCode.METHOD_NOT_ALLOWED;

        // GET으로 등록된 경로에 POST 요청
        mockMvc.perform(post("/test/method-not-supported"))
                .andExpect(status().isMethodNotAllowed())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()));
    }

    @Test
    @DisplayName("예상하지 못한 예외 발생 시 서버 오류 응답을 반환한다")
    void handleException() throws Exception {
        ErrorCode errorCode = CommonErrorCode.INTERNAL_SERVER_ERROR;

        mockMvc.perform(get("/test/server-error"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.code")
                        .value(errorCode.getCode()))
                .andExpect(jsonPath("$.message")
                        .value(errorCode.getMessage()))
                .andExpect(jsonPath("$.message")
                        .value(not(containsString("secret"))));
    }
}