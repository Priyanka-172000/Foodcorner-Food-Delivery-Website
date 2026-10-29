
package com.tap.util;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final String PREFIX = "pbkdf2$";
    private static final int ITERATIONS = 210000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hashIfNeeded(String password) {
        if (password == null || password.startsWith(PREFIX)) {
            return password;
        }

        byte[] salt = new byte[SALT_LENGTH];
        RANDOM.nextBytes(salt);

        byte[] hash = deriveHash(password, salt, ITERATIONS);

        return PREFIX + ITERATIONS + "$"
                + Base64.getEncoder().encodeToString(salt) + "$"
                + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean matches(String enteredPassword, String storedPassword) {
        if (enteredPassword == null || storedPassword == null) {
            return false;
        }

        if (!storedPassword.startsWith(PREFIX)) {
            return enteredPassword.equals(storedPassword);
        }

        try {
            String[] parts = storedPassword.split("\\$", -1);

            if (parts.length != 4 || !parts[0].equals("pbkdf2")) {
                return false;
            }

            int iterations = Integer.parseInt(parts[1]);

            if (iterations < 100000 || iterations > 1000000) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[3]);

            if (salt.length != SALT_LENGTH || expectedHash.length != KEY_LENGTH / 8) {
                return false;
            }

            byte[] actualHash = deriveHash(enteredPassword, salt, iterations);

            return MessageDigest.isEqual(expectedHash, actualHash);

        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static boolean isHashed(String password) {
        return password != null && password.startsWith(PREFIX);
    }

    private static byte[] deriveHash(String password, byte[] salt, int iterations) {
        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                iterations,
                KEY_LENGTH
        );

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            return factory.generateSecret(spec).getEncoded();

        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("Password hashing failed.", e);

        } finally {
            spec.clearPassword();
        }
    }
}
