package com.inventory.config;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Adds CSRF token to the model for FreeMarker templates as "csrf".
 * This makes templates simpler and avoids calling request.getAttribute(...) directly.
 */
@ControllerAdvice
public class CsrfControllerAdvice {

    @ModelAttribute("csrf")
    public CsrfToken csrfToken(HttpServletRequest request) {
        // Spring stores token under "_csrf" and/or the CsrfToken class name.
        CsrfToken token = (CsrfToken) request.getAttribute("_csrf");
        if (token == null) {
            token = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        }
        return token;
    }
}