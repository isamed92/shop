import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String id);

  Future<List<Product>> getProductByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
