package com.inventory.model;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "audit_entries")
public class AuditEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Instant timestamp;

    // who performed the action (username)
    private String actor;

    // short action name, e.g. "USER_CREATED", "ITEM_DELETED"
    private String action;

    // entity type, e.g. "USER", "ITEM"
    private String entityType;

    // optional id of the entity affected
    private Long entityId;

    // optional free-form details (max length set reasonably)
    @Column(length = 2000)
    private String details;

    public AuditEntry() {}

    public AuditEntry(Instant timestamp, String actor, String action, String entityType, Long entityId, String details) {
        this.timestamp = timestamp;
        this.actor = actor;
        this.action = action;
        this.entityType = entityType;
        this.entityId = entityId;
        this.details = details;
    }

    // getters / setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Instant getTimestamp() { return timestamp; }
    public void setTimestamp(Instant timestamp) { this.timestamp = timestamp; }

    public String getActor() { return actor; }
    public void setActor(String actor) { this.actor = actor; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getEntityType() { return entityType; }
    public void setEntityType(String entityType) { this.entityType = entityType; }

    public Long getEntityId() { return entityId; }
    public void setEntityId(Long entityId) { this.entityId = entityId; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
}