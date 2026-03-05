package com.inventory.controller;

import com.inventory.service.SettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/settings")
public class SettingsController {

    @Autowired
    private SettingsService settingsService;

    @GetMapping
    public String showSettings(Model model) {
        try {
            int threshold = settingsService.getLowStockThreshold();
            model.addAttribute("threshold", threshold);
            return "settings";
        } catch (Exception e) {
            model.addAttribute("threshold", 5);
            model.addAttribute("msg", "Error loading settings: " + e.getMessage());
            return "settings";
        }
    }

    @PostMapping("/update-threshold")
    @ResponseBody
    public String updateThreshold(@RequestParam("threshold") int newThreshold) {
        try {
            settingsService.updateLowStockThreshold(newThreshold);
            return "✅ Threshold updated to " + newThreshold;
        } catch (Exception e) {
            e.printStackTrace();
            return "❌ Failed to update threshold: " + e.getMessage();
        }
    }
}
