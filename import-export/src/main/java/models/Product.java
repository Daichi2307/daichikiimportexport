package models;

public class Product {
	private int product_id;
	private String seller_port_id;
	private String product_name;
	private int quantity;
	private double price;

	public int getProduct_id() {
		return product_id;
	}

	public void setProduct_id(int product_id) {
		this.product_id = product_id;
	}

	public String getSeller_port_id() {
		return seller_port_id;
	}

	public void setSeller_port_id(String seller_port_id) {
		this.seller_port_id = seller_port_id;
	}

	public String getProduct_name() {
		return product_name;
	}

	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}
}
