// esta clase se ocupa para satisfacer  cada uno de los metodos y casos que hay que hacer

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../errors/product_error.dart';
import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
    }): dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken'
        }
    )
  );

  
  // metodo para subir una unica imagen 
  Future<String> _uploadFile(String path) async{

    try {
      // determinanmos el nombre del archivo 
      final fileName = path.split('/').last;

      // creamos la data para enviar 
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName)
      });

      final response = await dio.post('/files/product', data: data );

      return response.data['image'];

    } catch (e) {
      throw Exception();
    }

  }


  // metodo de implementacion para subir una imagen al backen
  Future<List<String>> _uploadPhotos(List<String> photos) async {

    // determinamos si la foto trae un "/" osea si biene de un archivo
    final photosToUpload = photos.where((element) => element.contains('/')).toList();

    // fotografias a ignorar
    final photosToIgnore = photos.where((element) => !element.contains('/')).toList();

    // crear una serie de futures de carga de imagenes simultaneas
    final List<Future<String>> uploadJob = photosToUpload.map( _uploadFile).toList();

    final mewImages = await Future.wait(uploadJob);

    return [...photosToIgnore, ...mewImages];
  }

  // metodo para crear o actualiza el producto
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      // ocupamos saber si tenemos o no el producto para crear o actualizar
      // para creacion o actualizacion hay que remover el id, por temas del backend
      final String? productId = productLike['id'];

      // method para determinar si hay Id o no, para crear o actualizar
      final String method = (productId == null) ? 'POST' : 'PATCH';

      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      // removemos la propiedad id del productLike
      productLike.remove('id');

      // usamos el _uploadPhotos para regresar el nuevo listado de las fotografias
      productLike['images'] = await _uploadPhotos(productLike['images']);

      // se hace la peticion
      final response = await dio.request(url,
          data: productLike, options: Options(method: method));

      // obtenemos la nueva respuesta
      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
