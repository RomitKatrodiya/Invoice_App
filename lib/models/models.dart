class Products {
  String? productName;
  String? price;

  Products({required this.productName, required this.price});

  factory Products.fromAdd(
      {required String productName, required String price}) {
    return Products(
      productName: productName,
      price: price,
    );
  }
}

class Customer {
  String? customerName;
  String? customerNumber;

  Customer({required this.customerName, required this.customerNumber});

  factory Customer.fromAdd(
      {required String customerName, required String customerNumber}) {
    return Customer(
      customerName: customerName,
      customerNumber: customerNumber,
    );
  }
}
