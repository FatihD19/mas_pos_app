import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/product_remote_datasource.dart';
import 'add_product_event.dart';
import 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRemoteDatasource _remoteDatasource;

  AddProductBloc(this._remoteDatasource) : super(AddProductInitial()) {
    on<AddProductSubmitted>(_onAddProductSubmitted);
    on<AddProductReset>(_onAddProductReset);
  }

  Future<void> _onAddProductSubmitted(
    AddProductSubmitted event,
    Emitter<AddProductState> emit,
  ) async {
    try {
      emit(AddProductLoading());

      final response = await _remoteDatasource.postProduct(event.request);

      emit(AddProductSuccess(response));
    } catch (e) {
      emit(AddProductFailure(e.toString()));
    }
  }

  void _onAddProductReset(
    AddProductReset event,
    Emitter<AddProductState> emit,
  ) {
    emit(AddProductInitial());
  }
}
