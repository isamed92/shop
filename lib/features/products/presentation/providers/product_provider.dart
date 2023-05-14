import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/provider.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductNotifier(repository: productsRepository, productId: productId);
});

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;
  ProductNotifier({required this.repository, required String productId})
      : super(ProductState(id: productId));

  Future<void> loadProduct() async {}
}
