package com.inventory.controller;

import com.inventory.model.User;
import com.inventory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // custom login page (shows error messages if present)
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                            Model model) {
        if ("role".equals(error)) {
            model.addAttribute("errorMessage", "You selected a role you are not assigned to. Please choose the correct role.");
        } else if (error != null) {
            model.addAttribute("errorMessage", "Invalid username or password.");
        }
        return "login";
    }

    // Registration form (only creates ROLE_USER accounts)
    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    // Handle registration - only allow ROLE_USER accounts from public registration
    @PostMapping("/register")
    public String handleRegister(@RequestParam String username,
                                 @RequestParam String password,
                                 Model model) {

        if (userService.findByUsername(username).isPresent()) {
            model.addAttribute("errorMessage", "Username already exists.");
            model.addAttribute("user", new User());
            return "register";
        }

        // Force role to ROLE_USER for all self-registered accounts
        String roleValue = "ROLE_USER";
        userService.registerNewUser(username, password, roleValue);

        model.addAttribute("successMessage", "Account created. You can now log in.");
        return "login";


    }


}