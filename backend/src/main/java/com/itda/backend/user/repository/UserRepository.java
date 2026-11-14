package com.itda.backend.user.repository;

import com.itda.backend.user.entity.Provider;
import com.itda.backend.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByProviderAndProviderIdAndDeletedAtIsNull(Provider provider, String providerId);

    Optional<User> findByIdAndDeletedAtIsNull(UUID id);
}