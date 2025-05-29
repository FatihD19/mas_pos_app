import 'package:equatable/equatable.dart';
import '../../../data/model/product_request_model.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class AddProductSubmitted extends AddProductEvent {
  final AddProductRequestModel request;

  const AddProductSubmitted(this.request);

  @override
  List<Object> get props => [request];
}

class AddProductReset extends AddProductEvent {}
