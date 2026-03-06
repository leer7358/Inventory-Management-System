package com.inventory.service;

import com.inventory.model.Email;
import com.inventory.repository.EmailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class NotificationService {

    @Autowired
    private EmailRepository emailRepository;

    /**
     * General-purpose notification sender (used by user registration or other events)
     */
    public void sendNotification(String sender, String subject, String message) {
        Email email = new Email();
        email.setSender(sender);
        email.setSubject(subject);
        email.setContent(message);
        email.setRead(false);
        email.setReceivedAt(LocalDateTime.now());
        emailRepository.save(email);
    }

    /**
     * ⚠️ Specialized low stock alert for items with detailed info.
     */
    public void sendLowStockAlert(String itemName, String categoryName, int quantity, Long itemId) {
        String sender = "system@inventorypro.com";
        String subject = "⚠️ Low Stock Alert: " + itemName;

        // Format the timestamp
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        // Message body with details + link to view the item
        String message =
                "🚨 The following item is running low on stock:\n\n" +
                        "🧾 Item: " + itemName + "\n" +
                        "📦 Category: " + (categoryName != null ? categoryName : "Uncategorized") + "\n" +
                        "📉 Current Quantity: " + quantity + "\n" +
                        "🔢 Threshold: System-defined minimum stock level\n" +
                        "🕒 Detected At: " + timestamp + "\n\n" +
                        "👉 [View Item Details](http://localhost:8080/items/edit/" + itemId + ")\n\n" +
                        "Please restock this item soon to avoid shortages.";

        Email email = new Email();
        email.setSender(sender);
        email.setSubject(subject);
        email.setContent(message);
        email.setRead(false);
        email.setReceivedAt(LocalDateTime.now());
        emailRepository.save(email);

        System.out.println("📩 Detailed low-stock notification sent for: " + itemName + " (Qty: " + quantity + ")");
    }
}
