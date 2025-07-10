package models;

public class User {
    private String    portId;
    private String password;
    private String confirmPassword;
    private String location;
	private String role;

	 public String getConfirmPassword() {
		return confirmPassword;
	}
	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}
	public String getLocation() {
			return location;
		}
		public void setLocation(String location) {
			this.location = location;
		}
    public User() {}
    public User(String portId, String password, String confirm, String location,  String role) {
        this.portId = portId;
        this.password = password;
        this.role = role;
        this.location = location;
        this.confirmPassword = confirm;
    }

    public String    getPortId()       
    { return portId; }
    public void   setPortId(String id)  
    { this.portId = id; }

    public String getPassword() 
    { return password; }
    public void   setPassword(String pw) 
    { this.password = pw; }

    public String getRole()        
    { return role; }
    public void   setRole(String r)  
    { this.role = r; }
}

    


