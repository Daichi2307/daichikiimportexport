package implementors;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DbConnection;
import models.ReportedProducts;
import operations.ReportedProductOpertions;

public class ReportedProductsImplementor implements ReportedProductOpertions{

	@Override
	public void changeStatus(int id) throws Exception {
		CallableStatement cs = DbConnection.getConnection().prepareCall("{call resolve_report(?)}");
		cs.setInt(1, id);
		cs.executeUpdate();
	}

	@Override
	public List<ReportedProducts> showReportedProducts(String port) throws Exception {
		List<ReportedProducts> report = new ArrayList<>();
		CallableStatement cs = DbConnection.getConnection().prepareCall("{call get_consumer_reported_issues(?)}");
		cs.setString(1, port);
		ResultSet rs = cs.executeQuery();
		while(rs.next()) {
			ReportedProducts products = new ReportedProducts();
			products.setReport_id(rs.getInt("report_id"));
			products.setConsumer_port_id(rs.getString("consumer_port_id"));
	        products.setSeller_port_id(rs.getString("seller_port_id"));
	        products.setProduct_id(rs.getInt("product_id"));
	        products.setIssue_type(rs.getString("issue_type"));
	        products.setStatus(rs.getString("status"));
	        products.setAction_taken(rs.getString("action_taken"));
	        products.setReport_date(rs.getDate("report_date"));
	        report.add(products);
	    }

	    rs.close();
	    cs.close();

	    return report;
	}
	
	@Override
	public String updateIssueType(int reportId, String newIssueType) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
}
