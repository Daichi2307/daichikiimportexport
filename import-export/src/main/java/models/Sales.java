package models;

public class Sales {
    private String productName;
    private int salesCount;

    public Sales() {}

    public Sales(String productName, int salesCount) {
        this.productName = productName;
        this.salesCount = salesCount;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getSalesCount() {
        return salesCount;
    }

    public void setSalesCount(int salesCount) {
        this.salesCount = salesCount;
    }
}
