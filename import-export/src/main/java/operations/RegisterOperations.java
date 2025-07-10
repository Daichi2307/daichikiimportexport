package operations;

import db_config.DbConnection;
import models.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterOperations {

	public boolean insert(User u) throws Exception {
	    String sql = "{call register_user(?, ?, ?, ?, ?)}";
	    try (Connection c = DbConnection.getConnection();
	         CallableStatement p = c.prepareCall(sql)) {

	        p.setString(1, u.getPortId());
	        p.setString(2, u.getPassword());
	        p.setString(3, u.getConfirmPassword());
	        p.setString(4, u.getLocation());
	        p.setString(5, u.getRole());

	        int result = p.executeUpdate();
	        return result > 0;

	    } catch (SQLException e) {
	        System.err.println("Registration Error: " + e.getMessage());  // Log actual SQL error
	        throw new Exception(e.getMessage()); // Re-throw to controller for handling
	    }
	}


	/* READ single */
	public User find(String id, String role) throws Exception {
		String sql = "";

		if (role.equalsIgnoreCase("consumer")) {
			sql = "{call view_consumer(?, ?, ?, ?)}";
		} else if (role.equalsIgnoreCase("seller")) {
			sql = "{call view_seller(?, ?, ?, ?)}";
		} else {
			throw new IllegalArgumentException("Invalid role: " + role);
		}

		Connection c = DbConnection.getConnection();
		CallableStatement p = null;
		System.out.println(role);
		if(role.equals("consumer")) {
			p = c.prepareCall("{call view_consumer(?)}");
			p.setString(1, id);
		}
		else {
			p = c.prepareCall("{call view_seller(?)}");
			p.setString(1, id);
		}
		ResultSet rs = p.executeQuery();
		if (rs.next()) {
			return new User(rs.getString("port_id"), rs.getString("password"), rs.getString("password"),
					rs.getString("location"), rs.getString("role"));
		}

		return null;
	}

	/* UPDATE */
	public boolean update(User u) throws Exception {
		CallableStatement p = null;
		if(u.getRole().equals("Seller")) {
			String sql = "{call updateSeller(?, ?, ?, ?)}";
			Connection c = DbConnection.getConnection();
			p = c.prepareCall(sql);
			p.setString(2, u.getPassword());
			p.setString(4, u.getRole());
			p.setString(1, u.getPortId());
			p.setString(3, u.getLocation());
		}
		else {
			String sql = "{call updateConsumer(?, ?, ?, ?)}";
			Connection c = DbConnection.getConnection();
			p = c.prepareCall(sql);
			p.setString(2, u.getPassword());
			p.setString(4, u.getRole());
			p.setString(1, u.getPortId());
			p.setString(3, u.getLocation());
		}
		return p.executeUpdate() == 1;

	}

	/* DELETE */
	public boolean delete(String id, String role) throws Exception {
		CallableStatement p = null;
		Connection c = DbConnection.getConnection();
		if(role.equals("Consumer")) {
			p = c.prepareCall("{call deleteConsumer(?)}");
			p.setString(1, id);
		}
		else {
			p = c.prepareCall("{call deleteSeller(?)}");
			p.setString(1, id);
		}
			return p.executeUpdate() == 1;
	}

	/* READ all (optional) */
	public List<User> all() throws Exception {
		List<User> list = new ArrayList<>();
		Connection c = DbConnection.getConnection();
		Statement s = c.createStatement();
		ResultSet rs = s.executeQuery("SELECT * FROM users");
		while (rs.next()) {
			list.add(new User(rs.getString("port_id"), rs.getString("password"), rs.getString("password"),
					rs.getString("location"), rs.getString("role")));
		}
		return list;
	}
}
