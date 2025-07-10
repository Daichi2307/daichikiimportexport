package operations;

import java.util.List;

import models.ReportedProducts;
import models.SellerPort;

public interface ReportedProductOpertions {
	List<ReportedProducts> showReportedProducts(String id) throws Exception;
    void changeStatus(int reportId) throws Exception;
    String updateIssueType(int reportId, String newIssueType) throws Exception;
}
