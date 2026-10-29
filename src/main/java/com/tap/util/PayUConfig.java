
package com.tap.util;

public final class PayUConfig {

    private static final String TEST_URL = "https://test.payu.in/_payment";
    private static final String PRODUCTION_URL = "https://secure.payu.in/_payment";

    private PayUConfig() {
    }

    public static String getKey() {
        return getRequiredValue("PAYU_KEY");
    }

    public static String getSalt() {
        return getRequiredValue("PAYU_SALT");
    }

    public static String getPaymentUrl() {
        String environment = System.getenv("PAYU_ENV");

        if (environment == null || environment.trim().isEmpty()
                || "test".equalsIgnoreCase(environment)) {
            return TEST_URL;
        }

        if ("production".equalsIgnoreCase(environment)) {
            return PRODUCTION_URL;
        }

        throw new IllegalStateException(
                "PAYU_ENV must be test or production");
    }

    private static String getRequiredValue(String name) {
        String value = System.getenv(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException(
                    "Missing required environment variable: " + name);
        }

        return value;
    }
}
