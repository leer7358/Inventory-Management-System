package com.inventory.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;

import java.io.IOException;

public class RoleCheckingAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    /**
     * Expects the login form to include a parameter named "loginAs" with values "USER" or "ADMIN".
     * If the authenticated user doesn't have the selected role, the handler logs them out and redirects
     * back to /login?error=role
     */
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        String chosen = request.getParameter("loginAs"); // expected "USER" or "ADMIN"
        if (chosen == null) {
            // no choice, proceed to default
            response.sendRedirect("/");
            return;
        }

        String requiredAuthority = "ROLE_" + chosen.toUpperCase();

        boolean hasRole = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(a -> a.equals(requiredAuthority));

        if (!hasRole) {
            // logout the user and redirect back with a clear message
            new SecurityContextLogoutHandler().logout(request, response, authentication);
            response.sendRedirect("/login?error=role");
            return;
        }

        // success and role matches — redirect to home (or redirectUrl can be added)
        response.sendRedirect("/");
    }
}