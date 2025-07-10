package models;

import java.sql.Date;
import java.util.List;

import implementors.ReportedProductsImplementor;

public class ReportedProducts {
	private int report_id;
	private String seller_port_id;
	private String consumer_port_id;
	private int product_id;
	private String issue_type;
	private String action_taken;
	private String status;
	private Date report_date;
	public int getReport_id() {
		return report_id;
	}
	public void setReport_id(int report_id) {
		this.report_id = report_id;
	}
	public String getSeller_port_id() {
		return seller_port_id;
	}
	public void setSeller_port_id(String seller_port_id) {
		this.seller_port_id = seller_port_id;
	}
	public String getConsumer_port_id() {
		return consumer_port_id;
	}
	public void setConsumer_port_id(String consumer_port_id) {
		this.consumer_port_id = consumer_port_id;
	}
	public int getProduct_id() {
		return product_id;
	}
	public void setProduct_id(int product_id) {
		this.product_id = product_id;
	}
	public String getIssue_type() {
		return issue_type;
	}
	public void setIssue_type(String issue_type) {
		this.issue_type = issue_type;
	}
	public String getAction_taken() {
		return action_taken;
	}
	public void setAction_taken(String action_taken) {
		this.action_taken = action_taken;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getReport_date() {
		return report_date;
	}
	public void setReport_date(Date report_date) {
		this.report_date = report_date;
	}
	public List<ReportedProducts> showReport(String port) throws Exception {
		List<ReportedProducts> list = new ReportedProductsImplementor().showReportedProducts(port);
		return list;
	}
	public void updateStatus(int id) throws Exception {
		new ReportedProductsImplementor().changeStatus(id);
	}
}
