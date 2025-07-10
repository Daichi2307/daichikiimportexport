package implementors;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DbConnection;
import models.Product;
import models.SellerPort;
import operations.ProductOperations;

public class ProductImplementor implements ProductOperations {
	@Override
	public String addProduct(Product pojo) {
		CallableStatement callableStatement;
		String msg = "Something went wrong";
		try {
			callableStatement = DbConnection.getConnection().prepareCall("{call add_product(?,?,?,?)}");
			callableStatement.setString(1, pojo.getSeller_port_id());
			callableStatement.setString(2, pojo.getProduct_name());
			callableStatement.setInt(3, pojo.getQuantity());
			callableStatement.setDouble(4, pojo.getPrice());
			

			ResultSet resultSet=callableStatement.executeQuery();
			if (resultSet.next()) {
				msg = resultSet.getString("message");
				
			}
		} catch (Exception e) {
		      System.out.println("Error in addProduct(): " + e.getMessage());
			e.printStackTrace();
		}
		
		
		return msg;
		
	}

	@Override
	public String updateProduct(Product pojo) {
		CallableStatement callableStatement;
		String msg="Something went wrong";
		try {
			callableStatement = DbConnection.getConnection().prepareCall("{call update_product(?,?,?,?)}");
			callableStatement.setInt(1, pojo.getProduct_id());
			callableStatement.setString(2, pojo.getProduct_name());
			callableStatement.setInt(3, pojo.getQuantity());
			callableStatement.setDouble(4, pojo.getPrice());
			ResultSet rs = callableStatement.executeQuery();
	        if (rs.next()) {
	             msg = rs.getString("message");
	        }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return msg;
		
	}

	@Override
	public String deleteProduct(models.Product port) {
		String msg = "Something went wrong!";
        try {
            CallableStatement cs = DbConnection.getConnection().prepareCall("{call delete_product(?)}");
            cs.setInt(1, port.getProduct_id());

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                msg = rs.getString("message");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return msg;
    }

	@Override
	public List<Product> viewSellerProducts(String id) {
		List<Product> list = new ArrayList<>();
	    try {
	        CallableStatement cs = DbConnection.getConnection().prepareCall("{call view_seller_products(?)}");
	        cs.setString(1, id);

	        ResultSet rs = cs.executeQuery();

	        if (rs.next()) {
	            // Check if result only has a "message" column
	            if (rs.getMetaData().getColumnCount() == 1 &&
	                rs.getMetaData().getColumnLabel(1).equalsIgnoreCase("message")) {

	                // Store the message in a custom dummy product for controller to handle
	                Product msgProduct = new Product();
	                msgProduct.setProduct_name(rs.getString("message"));
	                list.add(msgProduct);
	            } else {
	                do {
	                    Product p = new Product();
	                    p.setProduct_id(rs.getInt("product_id"));
	                    p.setSeller_port_id(rs.getString("seller_port_id"));
	                    p.setProduct_name(rs.getString("product_name"));
	                    p.setQuantity(rs.getInt("quantity"));
	                    p.setPrice(rs.getDouble("price"));
	                    list.add(p);
	                } while (rs.next());
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public List<Product> viewAllProducts() {
		List<Product> list = new ArrayList<>();
	    try {
	        CallableStatement cs = DbConnection.getConnection().prepareCall("{call view_all_products()}");

	        ResultSet rs = cs.executeQuery();

	        if (rs.next()) {
	            // Check if result only has a "message" column
	            if (rs.getMetaData().getColumnCount() == 1 &&
	                rs.getMetaData().getColumnLabel(1).equalsIgnoreCase("message")) {

	                // Store the message in a custom dummy product for controller to handle
	                Product msgProduct = new Product();
	                msgProduct.setProduct_name(rs.getString("message"));
	                list.add(msgProduct);
	            } else {
	                do {
	                    Product p = new Product();
	                    p.setProduct_id(rs.getInt("product_id"));
	                    p.setSeller_port_id(rs.getString("seller_port_id"));
	                    p.setProduct_name(rs.getString("product_name"));
	                    p.setQuantity(rs.getInt("quantity"));
	                    p.setPrice(rs.getDouble("price"));
	                    list.add(p);
	                } while (rs.next());
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;

	}
	

	
}
