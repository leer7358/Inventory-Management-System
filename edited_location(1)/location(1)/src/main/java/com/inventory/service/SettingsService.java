package com.inventory.service;

import com.inventory.model.Settings;
import com.inventory.repository.SettingsRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SettingsService {

    @Autowired
    private SettingsRepository settingsRepository;

    @PostConstruct
    public void init() {
        // ensure one record always exists
        if (settingsRepository.count() == 0) {
            Settings defaultSettings = new Settings(5);
            settingsRepository.save(defaultSettings);
            System.out.println("✅ Created default settings (low_stock_threshold = 5)");
        } else {
            System.out.println("✅ Loaded existing settings from DB");
        }
    }

    // Always read the latest from DB
    public int getLowStockThreshold() {
        return settingsRepository.findAll().stream()
                .findFirst()
                .map(Settings::getLowStockThreshold)
                .orElse(5);
    }

    // Update value directly in DB
    public void updateLowStockThreshold(int newThreshold) {
        Settings current = settingsRepository.findAll().stream().findFirst().orElse(null);

        if (current == null) {
            current = new Settings(newThreshold);
        } else {
            current.setLowStockThreshold(newThreshold);
        }

        settingsRepository.save(current);
        System.out.println("✅ Updated low_stock_threshold to " + newThreshold);
    }
}
