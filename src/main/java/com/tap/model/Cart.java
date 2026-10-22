package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items =
            new LinkedHashMap<>();


    public void addItem(CartItem item) {

        int menuId = item.getMenuId();

        if (items.containsKey(menuId)) {

            CartItem existingItem =
                    items.get(menuId);

            existingItem.setQuantity(
                    existingItem.getQuantity()
                    + item.getQuantity()
            );

        } else {

            items.put(menuId, item);
        }
    }


    public void updateItem(int menuId,
                           int quantity) {

        if (items.containsKey(menuId)) {

            if (quantity <= 0) {

                items.remove(menuId);

            } else {

                items.get(menuId)
                     .setQuantity(quantity);
            }
        }
    }


    public void removeItem(int menuId) {

        items.remove(menuId);
    }


    public Collection<CartItem> getItems() {

        return items.values();
    }


    public double getTotalAmount() {

        double total = 0;

        for (CartItem item : items.values()) {

            total += item.getSubtotal();
        }

        return total;
    }


    public int getTotalQuantity() {

        int totalQuantity = 0;

        for (CartItem item : items.values()) {

            totalQuantity += item.getQuantity();
        }

        return totalQuantity;
    }


    public boolean isEmpty() {

        return items.isEmpty();
    }


    public void clear() {

        items.clear();
    }


    @Override
    public String toString() {
        return "Cart{" +
                "items=" + items +
                '}';
    }
}