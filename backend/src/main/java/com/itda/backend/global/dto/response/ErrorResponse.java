package com.itda.backend.global.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ErrorResponse(String code, String message, List<ValidationError> errors) {
    public static ErrorResponse error(String code, String message) {
        return new ErrorResponse(code, message, null);
    }

    public static ErrorResponse error(String code, String message, List<ValidationError> errors) {
        return new ErrorResponse(code, message, errors);
    }

    public record ValidationError(String field, String message) {}
}