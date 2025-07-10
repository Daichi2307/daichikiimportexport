package operations;

import java.util.List;

import models.Product;
import models.SellerPort;

public interface ProductOperations {
	String addProduct(Product pojo);
	String updateProduct(Product pojo);
	String deleteProduct(models.Product port);
	List<Product> viewSellerProducts(String port);
	List<Product> viewAllProducts();
}
