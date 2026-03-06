package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItemService {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private NotificationService notificationService; // ✅ for sending alerts

    @Autowired
    private SettingsService settingsService;         // ✅ for dynamic threshold

    /**
     * Get all items.
     */
    public List<Item> listAll() {
        return itemRepository.findAll();
    }

    /**
     * Get an item by ID (returns null if not found).
     */
    public Item get(Long id) {
        return itemRepository.findById(id).orElse(null);
    }

    /**
     * Optional find by ID.
     */
    public Optional<Item> findById(Long id) {
        return itemRepository.findById(id);
    }

    /**
     * Save or update an item and automatically check for low stock.
     */
    public Item save(Item item) {
        Item savedItem = itemRepository.save(item);
        checkLowStock(savedItem); // ✅ trigger check each time an item is added/updated
        return savedItem;
    }

    /**
     * Delete item by ID.
     */
    public void delete(Long id) {
        itemRepository.deleteById(id);
    }

    /**
     * Search items by name or category.
     */
    public List<Item> searchByNameOrCategory(String query) {
        if (query == null || query.isBlank()) {
            return listAll();
        }
        return itemRepository.searchByNameOrCategory(query.trim());
    }

    /**
     * Count items that are at or below the low-stock threshold.
     */
    public long countLowStock(int threshold) {
        return itemRepository.countByQuantityLessThanEqual(threshold);
    }

    /**
     * ✅ Check if an item’s quantity is below the threshold and send a notification.
     */
    public void checkLowStock(Item item) {
        int threshold = settingsService.getLowStockThreshold(); // get threshold from DB

        System.out.println("🔍 Checking stock for: " + item.getName() +
                " | Qty: " + item.getQuantity() + " | Threshold: " + threshold);

        if (item.getQuantity() <= threshold) {
            // ✅ Pass full details (name, category, quantity, and ID)
            notificationService.sendLowStockAlert(
                    item.getName(),
                    (item.getCategory() != null ? item.getCategory().getName() : "N/A"),
                    item.getQuantity(),
                    item.getId()
            );
            System.out.println("⚠️ Low stock alert triggered for: " + item.getName());
        } else {
            System.out.println("✅ " + item.getName() + " is above the low stock threshold.");
        }
    }

}
