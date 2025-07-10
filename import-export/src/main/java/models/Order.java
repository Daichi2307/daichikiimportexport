package models;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import implementors.OrderImplementor;

public class Order {
    private int orderId;
    private int productId;
    private String consumerPortId;
    private String sellerPortId;
    private int quantity;
    private Date orderDate;
    private boolean orderPlaced;  // If you want, else remove if unused
    private boolean shipped;
    private boolean outForDelivery;
    private boolean delivered;
    private Timestamp shippedTime;
    private Timestamp outForDeliveryTime;
    private Timestamp deliveredTime;
    private String productName;
    private double price;

    // Getters and setters
    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getConsumerPortId() {
        return consumerPortId;
    }
    public void setConsumerPortId(String consumerPortId) {
        this.consumerPortId = consumerPortId;
    }

    public String getSellerPortId() {
        return sellerPortId;
    }
    public void setSellerPortId(String sellerPortId) {
        this.sellerPortId = sellerPortId;
    }

    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public boolean isOrderPlaced() {
        return orderPlaced;
    }
    public void setOrderPlaced(boolean orderPlaced) {
        this.orderPlaced = orderPlaced;
    }

    public boolean isShipped() {
        return shipped;
    }
    public void setShipped(boolean shipped) {
        this.shipped = shipped;
    }

    public boolean isOutForDelivery() {
        return outForDelivery;
    }
    public void setOutForDelivery(boolean outForDelivery) {
        this.outForDelivery = outForDelivery;
    }

    public boolean isDelivered() {
        return delivered;
    }
    public void setDelivered(boolean delivered) {
        this.delivered = delivered;
    }

    public Timestamp getShippedTime() {
        return shippedTime;
    }
    public void setShippedTime(Timestamp shippedTime) {
        this.shippedTime = shippedTime;
    }

    public Timestamp getOutForDeliveryTime() {
        return outForDeliveryTime;
    }
    public void setOutForDeliveryTime(Timestamp outForDeliveryTime) {
        this.outForDeliveryTime = outForDeliveryTime;
    }

    public Timestamp getDeliveredTime() {
        return deliveredTime;
    }
    public void setDeliveredTime(Timestamp deliveredTime) {
        this.deliveredTime = deliveredTime;
    }

    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }

    // Updated updateStatus to include timestamps for each status
    public String updateStatus(int orderId, 
                               Boolean shipped, Timestamp shippedTime, 
                               Boolean outForDelivery, Timestamp outForDeliveryTime, 
                               Boolean delivered, Timestamp deliveredTime) throws Exception {
        return new OrderImplementor().updateOrderStatusWithTimestamps(orderId, shipped, shippedTime,
                                                                       outForDelivery, outForDeliveryTime,
                                                                       delivered, deliveredTime);
    }

    // Delegate to implementor to get orders by seller
    public List<Order> showOrders(String sellerPortId) throws Exception {
        return new OrderImplementor().getOrdersBySeller(sellerPortId);
    }
}
