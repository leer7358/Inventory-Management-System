package com.inventory.service;

import com.inventory.model.User;
import com.inventory.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuditService auditService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
        );
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    // Registers a new user with the specified role (role should be either "ROLE_USER" or "ROLE_ADMIN")
    public User registerNewUser(String username, String rawPassword, String role) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setRole(role);
        User saved = userRepository.save(user);

        // audit
        auditService.record("SYSTEM", "USER_CREATED", "USER", saved.getId(), "Account created via registration: " + saved.getUsername());
        return saved;
    }

    @Autowired
    private NotificationService notificationService;

    // update password helper
    public Optional<User> updatePassword(Long userId, String rawPassword) {
        return userRepository.findById(userId).map(user -> {
            user.setPassword(passwordEncoder.encode(rawPassword));
            User saved = userRepository.save(user);
            auditService.record("SYSTEM", "USER_PASSWORD_UPDATED", "USER", saved.getId(), "Password reset/updated");

            // Send system notification
            notificationService.sendNotification(
                    "system@inventorypro.com",
                    "🟢 New User Registered",
                    "A new user named " + user.getUsername() + " has just registered in the system."
            );

            return saved;
        });
    }

}