package com.inventory;

import com.inventory.model.Category;
import com.inventory.model.Item;
import com.inventory.model.User;
import com.inventory.model.Email; // Added today for email functionality
import com.inventory.repository.CategoryRepository;
import com.inventory.repository.ItemRepository;
import com.inventory.repository.UserRepository;
import com.inventory.repository.EmailRepository; // Added today for email functionality
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.security.crypto.password.PasswordEncoder;

@Component
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepo;
    private final ItemRepository itemRepo;
    private final UserRepository userRepo;
    private final EmailRepository emailRepo; // Added today for email initialization
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(CategoryRepository categoryRepo, ItemRepository itemRepo, UserRepository userRepo, EmailRepository emailRepo, PasswordEncoder passwordEncoder) {
        this.categoryRepo = categoryRepo;
        this.itemRepo = itemRepo;
        this.userRepo = userRepo;
        this.emailRepo = emailRepo; // Added today for email initialization
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (categoryRepo.count() == 0) {
            Category electronics = categoryRepo.save(new Category("Electronics"));
            Category groceries = categoryRepo.save(new Category("Groceries"));
            Category apparel = categoryRepo.save(new Category("Apparel"));

            itemRepo.save(new Item("Laptop", "Dell XPS 13", 10, 65000, electronics));
            itemRepo.save(new Item("Smartphone", "Samsung Galaxy S24", 4, 48000, electronics));
            itemRepo.save(new Item("T-shirt", "Cotton Oversized", 15, 499, apparel));
            itemRepo.save(new Item("Apples", "Fresh Red Apples", 3, 150, groceries));
        }

        // seed users if none exist
        if (userRepo.count() == 0) {
            User admin = new User("admin", passwordEncoder.encode("admin123"), "ROLE_ADMIN");
            User user = new User("user", passwordEncoder.encode("user123"), "ROLE_USER");
            userRepo.save(admin);
            userRepo.save(user);
            System.out.println("✅ Created default users: admin/admin123 and user/user123");
        }

        // seed sample emails if none exist - Added today for email functionality
        if (emailRepo.count() == 0) {
            emailRepo.save(new Email("support@company.com", "System Alert: Low Stock Warning", "Several items are running low on stock. Please review inventory levels."));
            emailRepo.save(new Email("noreply@notifications.com", "Weekly Report Available", "Your weekly inventory report is ready for review."));
            emailRepo.save(new Email("admin@system.com", "Security Notice", "Multiple failed login attempts detected. Please review security logs."));
            System.out.println("✅ Created sample admin emails");
        }
    }
}