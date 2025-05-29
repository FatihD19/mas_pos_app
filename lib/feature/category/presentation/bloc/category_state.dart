part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final CategoryResponseModel category;

  const CategoryLoaded(this.category);

  @override
  List<Object> get props => [category];
}

final class CategoryAdded extends CategoryState {
  final AddCategoryResponseModel response;

  const CategoryAdded(this.response);

  @override
  List<Object> get props => [response];
}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
