part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class GetCategoriesEvent extends CategoryEvent {}

final class AddCategoryEvent extends CategoryEvent {
  final AddCategoryRequestModel request;

  const AddCategoryEvent(this.request);

  @override
  List<Object> get props => [request];
}
