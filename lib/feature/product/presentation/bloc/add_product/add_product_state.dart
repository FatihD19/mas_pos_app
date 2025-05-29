import 'package:equatable/equatable.dart';
import '../../../data/model/product_response_model.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final AddProductResponseModel response;

  const AddProductSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class AddProductFailure extends AddProductState {
  final String message;

  const AddProductFailure(this.message);

  @override
  List<Object> get props => [message];
}
