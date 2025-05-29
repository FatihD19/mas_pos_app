part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final ProductResponseModel product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

final class ProductAdded extends ProductState {
  final AddProductResponseModel response;

  const ProductAdded(this.response);

  @override
  List<Object> get props => [response];
}

final class ProductDeleted extends ProductState {
  final String productId;

  const ProductDeleted(this.productId);

  @override
  List<Object> get props => [productId];
}

final class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
