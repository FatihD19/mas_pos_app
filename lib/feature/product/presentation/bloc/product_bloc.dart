import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mas_pos_app/feature/product/data/datasource/product_remote_datasource.dart';
import 'package:mas_pos_app/feature/product/data/model/product_request_model.dart';
import 'package:mas_pos_app/feature/product/data/model/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource remoteDatasource;
  // Simpan data produk saat ini
  ProductResponseModel? _currentProducts;
  ProductResponseModel? _allProducts; // Simpan semua produk untuk filtering

  ProductBloc({required this.remoteDatasource}) : super(ProductInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final response = await remoteDatasource.getProducts();
        _currentProducts = response; // Simpan data produk terbaru
        _allProducts = response; // Simpan semua produk untuk filtering
        emit(ProductLoaded(response));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
        final response = await remoteDatasource.postProduct(event.request);
        emit(ProductAdded(response));

        // Jika produk berhasil ditambahkan, perbarui daftar produk
        if (_currentProducts != null && response.data != null) {
          // Tambahkan produk baru ke daftar produk saat ini
          final updatedProducts =
              List<Product>.from(_currentProducts!.data ?? []);
          updatedProducts.add(response.data!);

          _currentProducts = ProductResponseModel(
            status: _currentProducts!.status,
            message: _currentProducts!.message,
            data: updatedProducts,
          );

          // Update _allProducts juga
          final allUpdatedProducts =
              List<Product>.from(_allProducts!.data ?? []);
          allUpdatedProducts.add(response.data!);

          _allProducts = ProductResponseModel(
            status: _allProducts!.status,
            message: _allProducts!.message,
            data: allUpdatedProducts,
          );

          emit(ProductLoaded(_currentProducts!));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      try {
        final isDeleted = await remoteDatasource.deleteProduct(event.productId);

        if (isDeleted && _currentProducts != null) {
          // Buat daftar produk baru tanpa produk yang dihapus
          final updatedProducts =
              List<Product>.from(_currentProducts!.data ?? [])
                  .where((product) => product.id != event.productId)
                  .toList();

          // Update _currentProducts dengan daftar yang sudah diperbarui
          _currentProducts = ProductResponseModel(
            status: _currentProducts!.status,
            message: _currentProducts!.message,
            data: updatedProducts,
          );

          // Update _allProducts juga
          if (_allProducts != null) {
            final allUpdatedProducts =
                List<Product>.from(_allProducts!.data ?? [])
                    .where((product) => product.id != event.productId)
                    .toList();

            _allProducts = ProductResponseModel(
              status: _allProducts!.status,
              message: _allProducts!.message,
              data: allUpdatedProducts,
            );
          }

          // Emit state bahwa produk berhasil dihapus
          emit(ProductDeleted(event.productId));

          // Lalu emit state dengan daftar produk yang diperbarui
          emit(ProductLoaded(_currentProducts!));
        } else {
          emit(ProductError('Failed to delete product'));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<FilterProductEvent>((event, emit) async {
      if (_allProducts == null) return;

      try {
        List<Product> filteredProducts;

        if (event.categoryId == null || event.categoryId!.isEmpty) {
          // Tampilkan semua produk
          filteredProducts = List<Product>.from(_allProducts!.data ?? []);
        } else {
          // Filter berdasarkan kategori
          filteredProducts = List<Product>.from(_allProducts!.data ?? [])
              .where((product) => product.categoryId == event.categoryId)
              .toList();
        }

        _currentProducts = ProductResponseModel(
          status: _allProducts!.status,
          message: _allProducts!.message,
          data: filteredProducts,
        );

        emit(ProductLoaded(_currentProducts!));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
