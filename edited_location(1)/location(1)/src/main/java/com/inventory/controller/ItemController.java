package com.inventory.controller;

import com.inventory.model.Item;
import com.inventory.service.ItemService;
import com.inventory.service.CategoryService;
import com.inventory.service.SettingsService; // ✅ Added for threshold
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@Controller
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private SettingsService settingsService; // ✅ To fetch live threshold

    // ✅ View all items with dynamic threshold
    @GetMapping("/items")
    public String viewItems(@RequestParam(required = false) String search, Model model) {
        List<Item> items;

        if (search != null && !search.trim().isEmpty()) {
            items = itemService.searchByNameOrCategory(search);
            model.addAttribute("search", search);
        } else {
            items = itemService.listAll();
            model.addAttribute("search", "");
        }

        // ✅ Pass both items and live threshold
        model.addAttribute("items", items);
        model.addAttribute("threshold", settingsService.getLowStockThreshold());
        return "items";
    }

    // ✅ Add new item page
    @GetMapping("/items/add")
    public String addItem(Model model) {
        model.addAttribute("item", new Item());
        model.addAttribute("categories", categoryService.listAll());
        return "add-item";
    }

    // ✅ Save new item
    @PostMapping("/items/save")
    public String saveItem(@ModelAttribute("item") Item item) {
        itemService.save(item);
        return "redirect:/items";
    }

    // ✅ Delete item
    @GetMapping("/items/delete/{id}")
    public String deleteItem(@PathVariable Long id) {
        itemService.delete(id);
        return "redirect:/items";
    }

    // ✅ Edit item form
    @GetMapping("/items/edit/{id}")
    public String editItem(@PathVariable("id") Long id, Model model) {
        Item item = itemService.get(id);
        model.addAttribute("item", item);
        model.addAttribute("categories", categoryService.listAll());
        return "edit-item"; // ensure edit-item.ftlh exists
    }

    // ✅ Update existing item
    @PostMapping("/items/update")
    public String updateItem(@ModelAttribute("item") Item item) {
        itemService.save(item);
        return "redirect:/items";
    }

    // ✅ Export items to CSV
    @GetMapping("/items/export")
    public void exportToCSV(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        String headerKey = "Content-Disposition";
        String headerValue = "attachment; filename=items.csv";
        response.setHeader(headerKey, headerValue);

        List<Item> listItems = itemService.listAll();
        PrintWriter writer = response.getWriter();
        writer.println("ID,Name,Description,Quantity,Price,Category");

        for (Item item : listItems) {
            writer.println(
                    item.getId() + "," +
                            item.getName() + "," +
                            item.getDescription() + "," +
                            item.getQuantity() + "," +
                            item.getPrice() + "," +
                            (item.getCategory() != null ? item.getCategory().getName() : "")
            );
        }

        writer.flush();
        writer.close();
    }
}
