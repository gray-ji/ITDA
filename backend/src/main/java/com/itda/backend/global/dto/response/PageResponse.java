package com.itda.backend.global.dto.response;

import org.springframework.data.domain.Page;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

public record PageResponse<T>(List<T> content, int page, int size, boolean hasNext) {
    public static <T, E> PageResponse<T> of(Page<E> page, Function<E, T> converter) {
        List<T> convertedContent = page.getContent().stream()
                .map(converter)
                .collect(Collectors.toList());

        return new PageResponse<>(convertedContent, page.getNumber(), page.getSize(), page.hasNext());
    }
}