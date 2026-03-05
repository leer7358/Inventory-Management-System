package com.inventory.service;

import com.inventory.model.AuditEntry;
import com.inventory.repository.AuditRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
public class AuditService {

    @Autowired
    private AuditRepository auditRepository;

    /**
     * Record a new audit event.
     *
     * @param actor     actor username (or "SYSTEM")
     * @param action    short action code e.g. "USER_CREATED", "ITEM_DELETED"
     * @param entityType e.g. "USER", "ITEM"
     * @param entityId  optional entity id
     * @param details   free-form details (optional)
     */
    public AuditEntry record(String actor, String action, String entityType, Long entityId, String details) {
        AuditEntry entry = new AuditEntry(Instant.now(), actor, action, entityType, entityId, details);
        return auditRepository.save(entry);
    }

    public List<AuditEntry> recent(int limit) {
        return auditRepository.findAllByOrderByTimestampDesc(PageRequest.of(0, Math.max(1, limit)));
    }
}