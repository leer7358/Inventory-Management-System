package com.inventory.repository;

import com.inventory.model.Settings;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SettingsRepository extends JpaRepository<Settings, Long> { } // ✅ must be Long
