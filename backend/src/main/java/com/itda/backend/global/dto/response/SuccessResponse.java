package com.itda.backend.global.dto.response;

public record SuccessResponse<T>(String code, String message, T data){
    public static <T> SuccessResponse<T> success(String message) {
        return new SuccessResponse<>("SUCCESS", message, null);
    }

    public static <T> SuccessResponse<T> success(String message, T data) {
        return new SuccessResponse<>("SUCCESS", message, data);
    }
}