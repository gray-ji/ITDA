package com.itda.backend.global.exception;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;

import org.springframework.http.HttpMethod;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@RestController
class TestController {

    @GetMapping("/test/business-error")
    public void businessError() {
        throw new BaseException(CommonErrorCode.INVALID_REQUEST);
    }

    @PostMapping("/test/validation")
    public void validation(@Valid @RequestBody TestRequest request) {}

    @PostMapping("/test/json")
    public void invalidJson(@RequestBody TestRequest request) {}

    @GetMapping("/test/resource-not-found")
    public void resourceNotFound() throws NoResourceFoundException {
        throw new NoResourceFoundException(HttpMethod.GET, "/test/resource-not-found", "");
    }

    @GetMapping("/test/method-not-supported")
    public void methodNotSupported() {}

    @GetMapping("/test/server-error")
    public void serverError() {
        throw new IllegalStateException("secret exception message");
    }

    record TestRequest(@NotBlank(message = "제목은 필수입니다.") String title) { }
}