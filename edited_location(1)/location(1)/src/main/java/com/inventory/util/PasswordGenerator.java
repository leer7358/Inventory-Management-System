package com.inventory.util;

import java.security.SecureRandom;

public final class PasswordGenerator {

    private static final String CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_+={}[]";
    private static final SecureRandom rnd = new SecureRandom();

    private PasswordGenerator() {}

    public static String generate(int length) {
        if (length < 8) length = 8;
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARSET.charAt(rnd.nextInt(CHARSET.length())));
        }
        return sb.toString();
    }

    // default length
    public static String generate() {
        return generate(12);
    }
}