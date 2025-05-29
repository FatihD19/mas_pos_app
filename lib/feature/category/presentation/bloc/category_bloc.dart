import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mas_pos_app/feature/category/data/datasource/category_remote_datasource.dart';
import 'package:mas_pos_app/feature/category/data/models/category_request_model.dart';
import 'package:mas_pos_app/feature/category/data/models/category_response_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDataSource remoteDataSource;
  CategoryResponseModel? _currentCategories;

  CategoryBloc({required this.remoteDataSource}) : super(CategoryInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await remoteDataSource.getCategories();
        _currentCategories = response;
        emit(CategoryLoaded(response));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await remoteDataSource.addCategory(event.request);
        emit(CategoryAdded(response));

        // Auto update category list
        if (_currentCategories != null && response.data != null) {
          final updatedCategories =
              List<CategoryModel>.from(_currentCategories!.data ?? []);
          final newCategory = CategoryModel(
            id: response.data!.id,
            name: response.data!.name,
            createdAt: DateTime.now(),
          );
          updatedCategories.add(newCategory);

          _currentCategories = CategoryResponseModel(
            status: _currentCategories!.status,
            message: _currentCategories!.message,
            data: updatedCategories,
          );
          emit(CategoryLoaded(_currentCategories!));
        }
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
