package com.itda.backend.global.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.util.List;
import java.util.function.Function;

import static org.assertj.core.api.Assertions.assertThat;

class PageResponseTest {
    @Test
    @DisplayName("페이지 응답을 반환한다")
    void test1() {
        // given
        List<String> content = List.of("post1", "post2");
        Page<String> page = new PageImpl<>(content, PageRequest.of(0, 10), 12);

        // when
        PageResponse<String> response = PageResponse.of(page, Function.identity());

        // then
        assertThat(response.content()).containsExactly("post1", "post2");
        assertThat(response.page()).isEqualTo(0);
        assertThat(response.size()).isEqualTo(10);
        assertThat(response.hasNext()).isTrue();
    }
}