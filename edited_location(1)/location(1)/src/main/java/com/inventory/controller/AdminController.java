package com.inventory.controller;

import com.inventory.model.User;
import com.inventory.model.AuditEntry;
import com.inventory.model.Email; // Added today for email functionality
import com.inventory.repository.UserRepository;
import com.inventory.service.UserService;
import com.inventory.service.AuditService;
import com.inventory.service.EmailService; // Added today for email functionality
import com.inventory.util.PasswordGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private AuditService auditService;

    @Autowired
    private EmailService emailService; // Added today for email management

    // Admin landing page (shows User Management card) - Modified today to include email count
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public String adminHome(Model model) {
        model.addAttribute("title", "Admin Dashboard");
        model.addAttribute("unreadEmailCount", emailService.getUnreadCount()); // Added today for email badge
        return "admin/index";
    }

    // List all users - admin only. Flash attributes (tempPassword/resetFor/successMessage/errorMessage)
    // will be available in the model after redirects.
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/users")
    public String manageUsers(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    // Delete user by id - admin only, use POST to perform destructive action (PRG recommended)
    // Prevent deleting the currently authenticated user.
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = auth != null ? auth.getName() : null;

        Optional<User> target = userRepository.findById(id);
        if (target.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found.");
            return "redirect:/admin/users";
        }

        if (currentUsername != null && currentUsername.equals(target.get().getUsername())) {
            redirectAttributes.addFlashAttribute("errorMessage", "You cannot delete your own account.");
            return "redirect:/admin/users";
        }

        userRepository.deleteById(id);
        // record audit
        String actor = currentUsername != null ? currentUsername : "SYSTEM";
        auditService.record(actor, "USER_DELETED", "USER", id, "Deleted user: " + target.get().getUsername());

        redirectAttributes.addFlashAttribute("successMessage", "User deleted.");
        return "redirect:/admin/users";
    }

    // Also accept DELETE if a client uses AJAX/REST style
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/users/delete/{id}")
    public String deleteUserDeleteMethod(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        // Reuse same logic as POST variant
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = auth != null ? auth.getName() : null;

        Optional<User> target = userRepository.findById(id);
        if (target.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found.");
            return "redirect:/admin/users";
        }

        if (currentUsername != null && currentUsername.equals(target.get().getUsername())) {
            redirectAttributes.addFlashAttribute("errorMessage", "You cannot delete your own account.");
            return "redirect:/admin/users";
        }

        userRepository.deleteById(id);
        String actor = currentUsername != null ? currentUsername : "SYSTEM";
        auditService.record(actor, "USER_DELETED", "USER", id, "Deleted user: " + target.get().getUsername());
        redirectAttributes.addFlashAttribute("successMessage", "User deleted.");
        return "redirect:/admin/users";
    }

    // Show reset-password form
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/users/reset/{id}")
    public String showResetPassword(@PathVariable Long id, Model model) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            return "redirect:/admin/users";
        }
        model.addAttribute("user", user);
        return "admin/reset-password";
    }

    // Handle reset: either use supplied newPassword or generate one.
    // Uses RedirectAttributes so generated temporary password is shown once after redirect (PRG).
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/users/reset")
    public String resetPassword(@RequestParam Long id,
                                @RequestParam(required = false) String newPassword,
                                @RequestParam(required = false) String action, // "generate" or "set"
                                RedirectAttributes redirectAttributes) {

        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found.");
            return "redirect:/admin/users";
        }

        String tempPassword = null;
        String actor = SecurityContextHolder.getContext().getAuthentication().getName();
        if ("generate".equals(action) || (newPassword == null || newPassword.isBlank())) {
            // generate secure temp password and update encoded password
            tempPassword = PasswordGenerator.generate();
            userService.updatePassword(id, tempPassword);
            auditService.record(actor, "USER_PASSWORD_RESET", "USER", id, "Generated temporary password for: " + user.getUsername());
        } else {
            // set to provided password (will be encoded by the service)
            userService.updatePassword(id, newPassword);
            auditService.record(actor, "USER_PASSWORD_SET", "USER", id, "Admin set a new password for: " + user.getUsername());
        }

        // Add flash attributes so the users page can show the generated password once
        if (tempPassword != null) {
            redirectAttributes.addFlashAttribute("tempPassword", tempPassword);
            redirectAttributes.addFlashAttribute("resetFor", user.getUsername());
        } else {
            redirectAttributes.addFlashAttribute("successMessage", "Password updated for " + user.getUsername());
        }

        return "redirect:/admin/users";
    }

    // --- HISTORY ---
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/history")
    public String historyPage(Model model, @RequestParam(defaultValue = "50") int limit) {
        List<AuditEntry> recent = auditService.recent(limit);

        // Format timestamps server-side into "yyyy-MM-dd HH:mm:ss" strings to avoid FreeMarker parsing issues
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").withZone(ZoneId.systemDefault());

        List<Map<String,Object>> dto = recent.stream().map(e -> {
            Map<String,Object> m = new HashMap<>();
            // e.getTimestamp() is an Instant (as in the AuditEntry example). Format it safely.
            String timeStr = "";
            try {
                if (e.getTimestamp() != null) {
                    timeStr = fmt.format(e.getTimestamp());
                }
            } catch (Exception ex) {
                // fallback to toString
                timeStr = e.getTimestamp() != null ? e.getTimestamp().toString() : "";
            }
            m.put("time", timeStr);
            m.put("actor", e.getActor());
            m.put("action", e.getAction());
            m.put("entityType", e.getEntityType());
            m.put("entityId", e.getEntityId());
            m.put("details", e.getDetails());
            return m;
        }).collect(Collectors.toList());

        model.addAttribute("entries", dto);
        model.addAttribute("title", "Recent Updates");
        return "admin/history";
    }

    // --- EMAILS --- All email functionality added today
    // Display admin emails page with all emails
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/emails")
    public String emailsPage(Model model) {
        List<Email> emails = emailService.getAllEmails();
        model.addAttribute("emails", emails);
        model.addAttribute("title", "Admin Emails");
        return "admin/emails";
    }

    // Mark specific email as read
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/emails/mark-read/{id}")
    public String markEmailAsRead(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        emailService.markAsRead(id);
        redirectAttributes.addFlashAttribute("successMessage", "Email marked as read.");
        return "redirect:/admin/emails";
    }

    // Add new sample email for testing purposes
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/emails/add-sample")
    public String addSampleEmail(RedirectAttributes redirectAttributes) {
        Email newEmail = new Email("test@example.com", "New Test Email", "This is a new test email for demonstration.");
        emailService.saveEmail(newEmail);
        redirectAttributes.addFlashAttribute("successMessage", "New sample email added.");
        return "redirect:/admin/emails";
    }
}