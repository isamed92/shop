import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import './products_repository_provider.dart';

// STATE notifier provider
class ProductsState {
  final bool isLastPage;
  final int offset;
  final int limit;
  final List<Product> products;
  final bool isLoading;

  ProductsState(
      {this.isLastPage = false,
      this.offset = 0,
      this.limit = 10,
      this.products = const [],
      this.isLoading = false});

  ProductsState copyWith({
    bool? isLastPage,
    int? offset,
    int? limit,
    List<Product>? products,
    bool? isLoading,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
      );
}

// state NOTIFIER provider
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

// state notifier PROVIDER
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final repository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: repository);
});
