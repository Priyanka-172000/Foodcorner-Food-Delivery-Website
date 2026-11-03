package com.tap.model;

public class FoodCategory {

    private int categoryId;
    private String categoryName;
    private boolean active;
    private String imagePath;

    public FoodCategory() {
    }

    public FoodCategory(int categoryId, String categoryName, boolean active, String imagePath) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.active = active;
        this.imagePath = imagePath;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    @Override
    public String toString() {
        return "FoodCategory [categoryId=" + categoryId
                + ", categoryName=" + categoryName
                + ", active=" + active
                + ", imagePath=" + imagePath + "]";
    }
}