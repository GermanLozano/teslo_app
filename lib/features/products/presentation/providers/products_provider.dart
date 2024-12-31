// se crea el nuevo porveedor que va a permitir llenar los productos en una tabla
// para todo la informacion que se reflejara en la pantalla  de porductos 

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'products_repository_provider.dart';


// creamos el proveedor (Provider) 
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  
  return ProductsNotifier(
    productsRepository: productsRepository
  );

});

class ProductsNotifier extends StateNotifier<ProductsState>{

  // creamos el notificador para los porductos (Notifier)
  final ProductsRepository  productsRepository;

  ProductsNotifier({
    required this.productsRepository
  }): super( ProductsState() ){
    loadNextPage();
  }

  /* metodo para actualizar el nombre del producto en la lista principal de productos
  cuando se cambie el nombre desde editar producto */

  Future<bool> createOrUpdateProduct( Map<String, dynamic> productLike ) async{

    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      
      final isProductInList = state.products.any((element) => element.id == product.id);

      // si el producto no existe
      if( !isProductInList ) {
        state = state.copyWith(
          products: [...state.products, product]
        );
        return true;
      }

      // si el producto existe 
      state = state.copyWith(
        products: state.products.map(
          (element) => (element.id == product.id) ? product : element,
        ).toList()
      );

      return true;

    } catch (e) {
      return false;
    }

  }


  Future loadNextPage() async{

    // para evitar que hagan multiples peticiones y borbandien el metodo loadNextPage
    if (state.isLoading || state.isLastPage ) return;

    state = state.copyWith( isLoading: true);

    final products = await productsRepository
      .getProductsByPage(limit: state.limit, offset: state.offset);

      // si no hay productos
    if (products.isEmpty) {
       state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }

    // si hay productos hacemos...
    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    );
  }

}



// creamos el proveedor de Notificador Estado (state Notifier Provider) 
//que es como queremos que luzca la informacion de ese estado
class ProductsState{

  final bool isLastPage; 
  final int limit; 
  final int offset; 
  final bool isLoading; 
  final List<Product> products;

  ProductsState({
     this.isLastPage = false, 
     this.limit = 10, 
     this.offset = 0, 
     this.isLoading = false, 
     this.products = const[]
  });

  ProductsState copyWith({
    bool? isLastPage, 
    int? limit, 
    int? offset, 
    bool? isLoading, 
    List<Product>? products,
  })=> ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit:  limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products:  products ?? this.products,
  );

}