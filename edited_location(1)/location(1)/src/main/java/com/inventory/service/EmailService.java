package com.inventory.service;

import com.inventory.model.Email;
import com.inventory.repository.EmailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

// Service layer for email business logic - Added today
@Service
public class EmailService {
    
    @Autowired
    private EmailRepository emailRepository;

    // Get all emails sorted by newest first
    public List<Email> getAllEmails() {
        return emailRepository.findAllByOrderByReceivedAtDesc();
    }

    // Get count of unread emails for dashboard badge
    public long getUnreadCount() {
        return emailRepository.countByIsReadFalse();
    }

    // Mark specific email as read by ID
    public Email markAsRead(Long id) {
        Email email = emailRepository.findById(id).orElse(null);
        if (email != null) {
            email.setRead(true);
            return emailRepository.save(email);
        }
        return null;
    }

    // Save new email to database
    public Email saveEmail(Email email) {
        return emailRepository.save(email);
    }
}