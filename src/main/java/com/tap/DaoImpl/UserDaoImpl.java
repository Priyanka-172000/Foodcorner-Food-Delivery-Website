
package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.UserDao;
import com.tap.model.User;
import com.tap.util.DBConnection;
import com.tap.util.PasswordUtil;

public class UserDaoImpl implements UserDao {

    private static final String INSERT_USER =
            "INSERT INTO user(username, password, email, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_USER_BY_ID =
            "SELECT * FROM user WHERE userId = ?";

    private static final String GET_USER_BY_EMAIL =
            "SELECT * FROM user WHERE email = ?";

    private static final String GET_ALL_USERS =
            "SELECT * FROM user";

    private static final String UPDATE_USER =
            "UPDATE user SET username = ?, password = ?, email = ?, phone = ?, address = ?, role = ? WHERE userId = ?";

    private static final String DELETE_USER =
            "DELETE FROM user WHERE userId = ?";

    @Override
    public void addUser(User user) {
        String hashedPassword = PasswordUtil.hashIfNeeded(user.getPassword());
        user.setPassword(hashedPassword);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_USER)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, hashedPassword);
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public User getUser(int userId) {
        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_USER_BY_ID)) {

            pstmt.setInt(1, userId);

            try (ResultSet res = pstmt.executeQuery()) {
                if (res.next()) {
                    user = extractUser(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public User getUserByEmail(String email) {
        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_USER_BY_EMAIL)) {

            pstmt.setString(1, email);

            try (ResultSet res = pstmt.executeQuery()) {
                if (res.next()) {
                    user = extractUser(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_USERS);
             ResultSet res = pstmt.executeQuery()) {

            while (res.next()) {
                users.add(extractUser(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    @Override
    public void updateUser(User user) {
        String hashedPassword = PasswordUtil.hashIfNeeded(user.getPassword());
        user.setPassword(hashedPassword);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_USER)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, hashedPassword);
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            pstmt.setInt(7, user.getUserId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

public boolean updatePassword(int userId, String newPassword) {
    if (userId <= 0 || newPassword == null || newPassword.isEmpty()) {
        return false;
    }

    String hashedPassword = PasswordUtil.hashIfNeeded(newPassword);

    String sql = "UPDATE user SET password = ? WHERE userId = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement pstmt = con.prepareStatement(sql)) {

        pstmt.setString(1, hashedPassword);
        pstmt.setInt(2, userId);

        return pstmt.executeUpdate() == 1;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    @Override
    public void deleteUser(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_USER)) {

            pstmt.setInt(1, userId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private User extractUser(ResultSet res) throws SQLException {
        User user = new User();

        user.setUserId(res.getInt("userId"));
        user.setUsername(res.getString("username"));
        user.setPassword(res.getString("password"));
        user.setEmail(res.getString("email"));
        user.setPhone(res.getString("phone"));
        user.setAddress(res.getString("address"));
        user.setRole(res.getString("role"));

        return user;
    }
}
