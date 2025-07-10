package models;

public class SellerPort {
	private int seller_port_id;
	private String password;
	private String location;
	private String role;
	public int getSeller_port_id() {
		return seller_port_id;
	}
	public void setSeller_port_id(int seller_port_id) {
		this.seller_port_id = seller_port_id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
}
