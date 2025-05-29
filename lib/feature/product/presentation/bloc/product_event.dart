part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class GetProductsEvent extends ProductEvent {}

final class AddProductEvent extends ProductEvent {
  final AddProductRequestModel request;

  const AddProductEvent(this.request);

  @override
  List<Object> get props => [request];
}

final class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

final class FilterProductEvent extends ProductEvent {
  final String? categoryId;

  const FilterProductEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId ?? ''];
}
