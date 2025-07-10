package operations;

import java.sql.Timestamp;
import java.util.List;
import models.Order;

public interface OrderOperations {
    List<Order> getOrdersBySeller(String sellerPortId) throws Exception;

    String updateOrderStatus(int orderId, Boolean shipped, Boolean outForDelivery, Boolean delivered) throws Exception;

    // New method to update status with timestamps
    String updateOrderStatusWithTimestamps(int orderId,
                                           Boolean shipped, Timestamp shippedTime,
                                           Boolean outForDelivery, Timestamp outForDeliveryTime,
                                           Boolean delivered, Timestamp deliveredTime) throws Exception;
}
