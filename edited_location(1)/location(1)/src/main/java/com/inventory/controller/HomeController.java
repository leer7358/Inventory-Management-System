package com.inventory.controller;

import com.inventory.service.CategoryService;
import com.inventory.service.ItemService;
import com.inventory.service.SettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private SettingsService settingsService; // ✅ for dynamic threshold

    @GetMapping("/")
    public String home(Model model) {
        // ✅ Get live threshold from SettingsService
        int threshold = settingsService.getLowStockThreshold();

        // ✅ Compute stats dynamically
        int totalCategories = categoryService.listAll().size();
        int totalItems = itemService.listAll().size();
        long lowStock = itemService.countLowStock(threshold);


        // ✅ Pass values to model
        model.addAttribute("totalCategories", totalCategories);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("lowStock", lowStock);

        return "index"; // returns dashboard view
    }
}
