package com.itda.backend.global.security;

import com.itda.backend.auth.exception.AuthErrorCode;
import com.itda.backend.global.config.JwtConfig;
import com.itda.backend.global.exception.BaseException;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

@Component
public class TokenProvider {

    private final JwtEncoder jwtEncoder;
    private final JwtProperties properties;
    private final JwtDecoder refreshTokenDecoder;

    public TokenProvider(JwtEncoder jwtEncoder, JwtProperties properties, SecretKey jwtSecretKey) {
        this.jwtEncoder = jwtEncoder;
        this.properties = properties;

        // refresh 토큰 전용 디코더 (API 인증용 디코더와 분리)
        NimbusJwtDecoder decoder = NimbusJwtDecoder.withSecretKey(jwtSecretKey)
                .macAlgorithm(MacAlgorithm.HS256)
                .build();
        decoder.setJwtValidator(new DelegatingOAuth2TokenValidator<>(
                JwtValidators.createDefault(),
                JwtConfig.tokenTypeValidator(TokenType.REFRESH)));
        this.refreshTokenDecoder = decoder;
    }

    public String createAccessToken(UUID userId) {
        return create(userId, TokenType.ACCESS, properties.accessTokenExpiration());
    }

    public String createRefreshToken(UUID userId) {
        return create(userId, TokenType.REFRESH, properties.refreshTokenExpiration());
    }

    public Duration refreshTokenTtl() {
        return properties.refreshTokenExpiration();
    }

    /** refresh 토큰을 검증하고 사용자 ID를 반환한다. 유효하지 않으면 예외. */
    public UUID parseRefreshToken(String token) {
        try {
            Jwt jwt = refreshTokenDecoder.decode(token);
            return UUID.fromString(jwt.getSubject());
        } catch (JwtException | IllegalArgumentException e) {
            // TODO: 재발급 전용 오류 코드로 교체 (#20)
            throw new BaseException(AuthErrorCode.UNAUTHORIZED);
        }
    }

    private String create(UUID userId, TokenType type, Duration ttl) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .subject(userId.toString())
                .issuedAt(now)
                .expiresAt(now.plus(ttl))
                .id(UUID.randomUUID().toString())
                .claim(JwtConfig.TYPE_CLAIM, type.claimValue())
                .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        return jwtEncoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
    }
}