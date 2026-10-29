
package com.tap.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class PayUHashUtil {

    private PayUHashUtil() {
    }

    public static String generateRequestHash(
            String key,
            String txnid,
            String amount,
            String productinfo,
            String firstname,
            String email,
            String udf1,
            String udf2,
            String udf3,
            String udf4,
            String udf5,
            String salt) {

        requireValue(key, "key");
        requireValue(txnid, "txnid");
        requireValue(amount, "amount");
        requireValue(productinfo, "productinfo");
        requireValue(firstname, "firstname");
        requireValue(email, "email");
        requireValue(salt, "salt");

        String hashInput =
                key + "|" + txnid + "|" + amount + "|"
                + productinfo + "|" + firstname + "|" + email + "|"
                + value(udf1) + "|" + value(udf2) + "|"
                + value(udf3) + "|" + value(udf4) + "|"
                + value(udf5) + "||||||" + salt;

        return sha512(hashInput);
    }

    public static String generateResponseHash(
            String status,
            String udf1,
            String udf2,
            String udf3,
            String udf4,
            String udf5,
            String email,
            String firstname,
            String productinfo,
            String amount,
            String txnid,
            String key,
            String salt,
            String additionalCharges) {

        requireValue(status, "status");
        requireValue(email, "email");
        requireValue(firstname, "firstname");
        requireValue(productinfo, "productinfo");
        requireValue(amount, "amount");
        requireValue(txnid, "txnid");
        requireValue(key, "key");
        requireValue(salt, "salt");

        String hashInput =
                salt + "|" + status + "||||||"
                + value(udf5) + "|" + value(udf4) + "|"
                + value(udf3) + "|" + value(udf2) + "|"
                + value(udf1) + "|" + email + "|"
                + firstname + "|" + productinfo + "|"
                + amount + "|" + txnid + "|" + key;

        if (additionalCharges != null
                && !additionalCharges.trim().isEmpty()) {
            hashInput = additionalCharges + "|" + hashInput;
        }

        return sha512(hashInput);
    }

    public static boolean verifyResponseHash(
            String expectedHash,
            String receivedHash) {

        if (expectedHash == null || receivedHash == null
                || expectedHash.trim().isEmpty()
                || receivedHash.trim().isEmpty()) {
            return false;
        }

        return MessageDigest.isEqual(
                expectedHash.getBytes(StandardCharsets.UTF_8),
                receivedHash.trim().getBytes(StandardCharsets.UTF_8)
        );
    }

    private static String sha512(String input) {

        try {
            MessageDigest digest =
                    MessageDigest.getInstance("SHA-512");

            byte[] hashBytes =
                    digest.digest(
                            input.getBytes(StandardCharsets.UTF_8));

            StringBuilder hex = new StringBuilder();

            for (byte b : hashBytes) {
                hex.append(String.format("%02x", b & 0xff));
            }

            return hex.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(
                    "SHA-512 is unavailable", e);
        }
    }

    private static String value(String input) {
        return input == null ? "" : input;
    }

    private static void requireValue(
            String input,
            String fieldName) {

        if (input == null || input.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Missing required payment field: " + fieldName);
        }
    }
}
