package com.inventory.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.inventory.model.Item;
import com.inventory.service.CategoryService;
import com.inventory.service.ItemService;
import com.inventory.service.SettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ReportsController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private SettingsService settingsService;

    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping("/reports")
    public String showReports(Model model) throws JsonProcessingException {
        try {
            // ✅ Retrieve safe defaults
            List<Item> items = Optional.ofNullable(itemService.listAll()).orElse(Collections.emptyList());
            int totalCategories = categoryService.listAll().size();
            int totalItems = items.size();
            int threshold = settingsService.getLowStockThreshold() > 0 ? settingsService.getLowStockThreshold() : 5;

            // ✅ Filter low-stock items
            List<Item> lowStockItems = items.stream()
                    .filter(i -> i.getQuantity() <= threshold)
                    .collect(Collectors.toList());

            // ✅ Count items per category
            Map<String, Long> countByCategory = items.stream()
                    .filter(i -> i.getCategory() != null)
                    .collect(Collectors.groupingBy(
                            i -> i.getCategory().getName(),
                            Collectors.counting()
                    ));

            // ✅ Convert to JSON safely
            String countByCategoryJson = objectMapper.writeValueAsString(countByCategory);
            String lowStockItemsJson = objectMapper.writeValueAsString(lowStockItems);

            // ✅ Add to model
            model.addAttribute("totalCategories", totalCategories);
            model.addAttribute("totalItems", totalItems);
            model.addAttribute("lowStockCount", lowStockItems.size());
            model.addAttribute("threshold", threshold);
            model.addAttribute("lowStockItems", lowStockItems);
            model.addAttribute("countByCategoryJson", countByCategoryJson);
            model.addAttribute("lowStockItemsJson", lowStockItemsJson);

            return "reports";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", e.getMessage());
            return "error";
        }
    }
}
