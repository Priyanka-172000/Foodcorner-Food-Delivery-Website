package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu(restaurantId, itemName, description, price, isAvailable, imagePath) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_MENU_BY_ID =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String GET_MENUS_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurantId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, itemName = ?, description = ?, "
          + "price = ?, isAvailable = ?, imagePath = ? WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";


    @Override
    public void addMenu(Menu menu) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(INSERT_MENU);
        ) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " menu item added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_MENU_BY_ID);
        ) {

            pstmt.setInt(1, menuId);

            try (ResultSet res = pstmt.executeQuery()) {

                if (res.next()) {
                    menu = extractMenu(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }


    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ALL_MENUS);
            ResultSet res = pstmt.executeQuery();
        ) {

            while (res.next()) {
                menus.add(extractMenu(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_MENUS_BY_RESTAURANT);
        ) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet res = pstmt.executeQuery()) {

                while (res.next()) {
                    menus.add(extractMenu(res));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public void updateMenu(Menu menu) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(UPDATE_MENU);
        ) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setInt(7, menu.getMenuId());

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " menu item updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteMenu(int menuId) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(DELETE_MENU);
        ) {

            pstmt.setInt(1, menuId);

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " menu item deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private Menu extractMenu(ResultSet res) throws SQLException {

        Menu menu = new Menu();

        menu.setMenuId(res.getInt("menuId"));
        menu.setRestaurantId(res.getInt("restaurantId"));
        menu.setItemName(res.getString("itemName"));
        menu.setDescription(res.getString("description"));
        menu.setPrice(res.getDouble("price"));
        menu.setAvailable(res.getBoolean("isAvailable"));
        menu.setImagePath(res.getString("imagePath"));

        return menu;
    }
}