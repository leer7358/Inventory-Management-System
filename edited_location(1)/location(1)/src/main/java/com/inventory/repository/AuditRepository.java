package com.inventory.repository;

import com.inventory.model.AuditEntry;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuditRepository extends JpaRepository<AuditEntry, Long> {
    // fetch most recent entries
    List<AuditEntry> findAllByOrderByTimestampDesc(Pageable pageable);
}

