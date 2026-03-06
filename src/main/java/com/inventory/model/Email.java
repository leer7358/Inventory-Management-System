package com.inventory.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

// Email entity for admin email management system - Added today
@Entity
@Table(name = "emails")
public class Email {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // Primary key for email records

    @Column(nullable = false)
    private String sender; // Email sender address

    @Column(nullable = false)
    private String subject; // Email subject line

    @Column(columnDefinition = "TEXT")
    private String content; // Email body content

    @Column(name = "received_at", nullable = false)
    private LocalDateTime receivedAt; // Timestamp when email was received

    @Column(name = "is_read")
    private boolean isRead = false; // Track if admin has read the email

    public Email() {
        this.receivedAt = LocalDateTime.now(); // Auto-set received time
    }

    // Constructor for creating new emails with sender, subject, and content
    public Email(String sender, String subject, String content) {
        this();
        this.sender = sender;
        this.subject = subject;
        this.content = content;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getReceivedAt() { return receivedAt; }
    public void setReceivedAt(LocalDateTime receivedAt) { this.receivedAt = receivedAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}