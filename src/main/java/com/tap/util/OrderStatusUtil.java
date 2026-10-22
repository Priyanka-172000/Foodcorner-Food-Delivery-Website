package com.tap.util;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.model.Order;


public class OrderStatusUtil {

    /*
     * Prevent object creation.
     */
    private OrderStatusUtil() {

    }


    /*
     * AUTOMATIC ORDER STATUS
     *
     * 0 - 2 minutes
     * PENDING
     *
     * 2 - 10 minutes
     * CONFIRMED
     *
     * After 10 minutes
     * DELIVERED
     *
     * CANCELLED orders
     * will never be changed.
     */
    public static void updateAutomaticStatus(
            Order order,
            OrderDaoImpl orderDao) {


        if (order == null ||
            orderDao == null ||
            order.getOrderDate() == null) {

            return;
        }


        String currentStatus =
                order.getStatus();


        /*
         * CANCELLED ORDER
         * MUST REMAIN CANCELLED
         */
        if ("CANCELLED".equalsIgnoreCase(
                currentStatus)) {

            return;
        }


        /*
         * DELIVERED ORDER
         * DOES NOT NEED AN UPDATE
         */
        if ("DELIVERED".equalsIgnoreCase(
                currentStatus)) {

            return;
        }


        long currentTime =
                System.currentTimeMillis();


        long orderTime =
                order.getOrderDate()
                     .getTime();


        long difference =
                currentTime - orderTime;


        /*
         * SAFETY CHECK
         */
        if (difference < 0) {

            difference = 0;
        }


        /*
         * MILLISECONDS TO MINUTES
         */
        long minutes =
                difference / (1000 * 60);


        String newStatus;


        /*
         * LESS THAN 2 MINUTES
         */
        if (minutes < 2) {

            newStatus =
                    "PENDING";
        }


        /*
         * 2 TO 10 MINUTES
         */
        else if (minutes < 10) {

            newStatus =
                    "CONFIRMED";
        }


        /*
         * AFTER 10 MINUTES
         */
        else {

            newStatus =
                    "DELIVERED";
        }


        /*
         * UPDATE ONLY WHEN
         * STATUS HAS CHANGED
         */
        if (currentStatus == null ||
            !newStatus.equalsIgnoreCase(
                    currentStatus)) {


            order.setStatus(
                    newStatus
            );


            orderDao.updateOrder(
                    order
            );
        }
    }
}