package com.itda.backend.global.security;

import com.itda.backend.global.config.JwtConfig;
import com.itda.backend.global.exception.BaseException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.oauth2.jwt.JwtEncoder;

import javax.crypto.SecretKey;
import java.time.Duration;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class TokenProviderTest {

    private static final String SECRET = "test-secret-test-secret-test-secret-123456";

    private TokenProvider tokenProvider;

    @BeforeEach
    void setUp() {
        JwtProperties properties =
                new JwtProperties(SECRET, Duration.ofMinutes(30), Duration.ofDays(14));
        JwtConfig config = new JwtConfig();
        SecretKey key = config.jwtSecretKey(properties);
        JwtEncoder encoder = config.jwtEncoder(key);
        tokenProvider = new TokenProvider(encoder, properties, key);
    }

    @Test
    void refresh_토큰을_만들고_다시_읽으면_같은_사용자_ID가_나온다() {
        UUID userId = UUID.randomUUID();

        String refreshToken = tokenProvider.createRefreshToken(userId);

        assertThat(tokenProvider.parseRefreshToken(refreshToken)).isEqualTo(userId);
    }

    @Test
    void access_토큰은_refresh_토큰으로_쓸_수_없다() {
        String accessToken = tokenProvider.createAccessToken(UUID.randomUUID());

        assertThatThrownBy(() -> tokenProvider.parseRefreshToken(accessToken))
                .isInstanceOf(BaseException.class);
    }

    @Test
    void 형식이_잘못된_토큰은_거절된다() {
        assertThatThrownBy(() -> tokenProvider.parseRefreshToken("abc"))
                .isInstanceOf(BaseException.class);
    }
}