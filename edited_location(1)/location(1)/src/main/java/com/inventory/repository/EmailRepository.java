package com.inventory.repository;

import com.inventory.model.Email;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

// Repository for email database operations - Added today
@Repository
public interface EmailRepository extends JpaRepository<Email, Long> {
    List<Email> findAllByOrderByReceivedAtDesc(); // Get all emails sorted by newest first
    long countByIsReadFalse(); // Count unread emails for badge display
}