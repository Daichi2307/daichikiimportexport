package implementors;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import db_config.DbConnection;
import models.Order;
import operations.OrderOperations;

public class OrderImplementor implements OrderOperations {
    @Override
    public List<Order> getOrdersBySeller(String sellerPortId) throws Exception {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DbConnection.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL view_seller_orders(?)}")) {
            stmt.setString(1, sellerPortId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setProductId(rs.getInt("product_id"));
                o.setConsumerPortId(rs.getString("consumer_port_id"));
                o.setSellerPortId(rs.getString("seller_port_id"));
                o.setQuantity(rs.getInt("quantity"));
                o.setOrderDate(rs.getDate("order_date"));
                o.setOrderPlaced(rs.getBoolean("order_placed"));
                o.setShipped(rs.getBoolean("shipped"));
                o.setOutForDelivery(rs.getBoolean("out_for_delivery"));
                o.setDelivered(rs.getBoolean("delivered"));
                o.setProductName(rs.getString("product_name"));
                o.setPrice(rs.getDouble("price"));
                // If your stored proc returns these timestamps, add:
                // o.setShippedTime(rs.getTimestamp("shipped_time"));
                // o.setOutForDeliveryTime(rs.getTimestamp("out_for_delivery_time"));
                // o.setDeliveredTime(rs.getTimestamp("delivered_time"));
                orders.add(o);
            }
        }
        return orders;
    }

    @Override
    public String updateOrderStatus(int orderId, Boolean shipped, Boolean outForDelivery, Boolean delivered)
            throws Exception {
        String result = "";
        try (Connection conn = DbConnection.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL update_order_status(?, ?, ?, ?)}")) {
            stmt.setInt(1, orderId);
            if (shipped != null)
                stmt.setBoolean(2, shipped);
            else
                stmt.setNull(2, Types.BOOLEAN);
            if (outForDelivery != null)
                stmt.setBoolean(3, outForDelivery);
            else
                stmt.setNull(3, Types.BOOLEAN);
            if (delivered != null)
                stmt.setBoolean(4, delivered);
            else
                stmt.setNull(4, Types.BOOLEAN);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                result = rs.getString("status_message");
            }
        }
        return result;
    }

    // New method to update status with timestamps
    public String updateOrderStatusWithTimestamps(int orderId,
            Boolean shipped, Timestamp shippedTime,
            Boolean outForDelivery, Timestamp outForDeliveryTime,
            Boolean delivered, Timestamp deliveredTime) throws Exception {
        String result = "";
        try (Connection conn = DbConnection.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL update_order_status_with_timestamps(?, ?, ?, ?, ?, ?, ?)}")) {

            stmt.setInt(1, orderId);

            if (shipped != null)
                stmt.setBoolean(2, shipped);
            else
                stmt.setNull(2, Types.BOOLEAN);

            if (shippedTime != null)
                stmt.setTimestamp(3, shippedTime);
            else
                stmt.setNull(3, Types.TIMESTAMP);

            if (outForDelivery != null)
                stmt.setBoolean(4, outForDelivery);
            else
                stmt.setNull(4, Types.BOOLEAN);

            if (outForDeliveryTime != null)
                stmt.setTimestamp(5, outForDeliveryTime);
            else
                stmt.setNull(5, Types.TIMESTAMP);

            if (delivered != null)
                stmt.setBoolean(6, delivered);
            else
                stmt.setNull(6, Types.BOOLEAN);

            if (deliveredTime != null)
                stmt.setTimestamp(7, deliveredTime);
            else
                stmt.setNull(7, Types.TIMESTAMP);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                result = rs.getString("status_message");
            }
        }
        return result;
    }
}
