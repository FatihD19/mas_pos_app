# 🔄 Add Category Feature - Complete Implementation

Implementasi lengkap fitur Add Category dengan form modal bottom sheet, menggunakan CategoryBloc dengan auto-update list functionality.

## 📁 Struktur File

```
lib/feature/category/
├── presentation/
│   ├── bloc/
│   │   ├── category_bloc.dart             # ✅ Updated: Auto-update list
│   │   ├── category_event.dart            # GetCategories, AddCategory
│   │   └── category_state.dart            # All category states
│   └── widgets/
│       ├── add_category_sheet.dart        # ✅ NEW: Category form modal
│       └── add_category_helper.dart       # ✅ NEW: Helper function
├── data/
│   ├── models/
│   │   ├── category_request_model.dart    # AddCategoryRequestModel
│   │   └── category_response_model.dart   # Response models
│   └── datasource/
│       └── category_remote_datasource.dart # API integration
```

## 🎯 Fitur Utama

### 1. **AddCategorySheet Widget**

Form modal dengan:

- **Clean UI Design**: Icon kategori, form input nama
- **Form Validation**: Nama tidak boleh kosong, minimal 3 karakter
- **Real-time Feedback**: Loading, success, dan error states
- **BlocListener**: Auto close modal setelah berhasil dengan snackbar
- **Responsive Layout**: Handle bar, scrollable content

### 2. **Auto-Update CategoryBloc**

```dart
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryResponseModel? _currentCategories;

  on<AddCategoryEvent>((event, emit) async {
    final response = await remoteDataSource.addCategory(event.request);
    emit(CategoryAdded(response));

    // Auto update category list
    if (_currentCategories != null && response.data != null) {
      final updatedCategories = List<CategoryModel>.from(_currentCategories!.data ?? []);
      final newCategory = CategoryModel(/* new category data */);
      updatedCategories.add(newCategory);

      _currentCategories = CategoryResponseModel(/* updated list */);
      emit(CategoryLoaded(_currentCategories!));
    }
  });
}
```

### 3. **Integrasi dengan Add Product**

Updated `add_product_helper.dart`:

```dart
// Kategori button
onTap: () async {
  Navigator.of(context).pop();
  await showAddCategorySheet(context);
},
```

## 🚀 Flow Usage

### 1. **Akses Add Category**

```dart
// Melalui dashboard add button -> pilih "Kategori"
showAddProductSheet(context); // Shows option modal
// User tap "Kategori" -> showAddCategorySheet(context)
```

### 2. **Form Add Category**

```dart
showAddCategorySheet(context);
```

### 3. **Auto-Update Integration**

- Add category berhasil → CategoryBloc auto-update list
- AddProductSheet dropdown otomatis refresh dengan category baru
- No manual refresh needed

## 📋 AddCategorySheet Details

### Form Fields

```dart
// Nama Kategori
TextFormField(
  controller: _nameController,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama kategori tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama kategori minimal 3 karakter';
    }
    return null;
  },
)
```

### Submit Logic

```dart
void _addCategory() {
  if (_formKey.currentState!.validate()) {
    final request = AddCategoryRequestModel(
      name: _nameController.text.trim(),
    );
    context.read<CategoryBloc>().add(AddCategoryEvent(request));
  }
}
```

### State Management

```dart
BlocListener<CategoryBloc, CategoryState>(
  listener: (context, state) {
    if (state is CategoryAdded) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori berhasil ditambahkan')),
      );
    } else if (state is CategoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
)
```

## 🎨 UI Design Features

### 1. **Icon Section**

```dart
Container(
  width: 120,
  height: 120,
  decoration: BoxDecoration(
    color: primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(60),
  ),
  child: Icon(
    Icons.category_outlined,
    size: 60,
    color: primaryColor,
  ),
)
```

### 2. **Status Feedback**

- **Loading**: CircularProgressIndicator dengan teks
- **Success**: Check icon dengan pesan sukses
- **Error**: Error icon dengan pesan error

### 3. **Bottom Buttons**

- **Batal**: OutlinedButton untuk cancel
- **Tambah**: ElevatedButton dengan loading state

## 🔄 Integration dengan Product

### AddProductSheet Auto-Update

```dart
class _AddProductSheetState {
  @override
  void initState() {
    super.initState();
    // Load categories when modal opens
    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }
}

// Dropdown akan otomatis update karena CategoryBloc
// sudah emit CategoryLoaded dengan data terbaru
BlocBuilder<CategoryBloc, CategoryState>(
  builder: (context, state) {
    if (state is CategoryLoaded) {
      return DropdownButtonFormField<CategoryModel>(
        items: state.category.data!.map(/* category items */).toList(),
      );
    }
  },
)
```

## 📊 API Integration

### Request Model

```dart
class AddCategoryRequestModel {
  String? name;

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
```

### Response Model

```dart
class AddCategoryResponseModel {
  String? message;
  Data? data; // Contains id and name
}
```

### API Call

```dart
Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request) async {
  final response = await _dioClient.dio.post('/category', data: request.toJson());
  return AddCategoryResponseModel.fromJson(response.data);
}
```

## 🎯 Key Benefits

### 1. **Seamless User Experience**

- Add category → Auto available di product form
- No manual refresh needed
- Immediate feedback dengan snackbar

### 2. **Clean Architecture**

- Separated concerns dengan helper function
- BLoC pattern untuk state management
- Reusable components

### 3. **Consistent Design**

- Mengikuti design system dari AddProductSheet
- Consistent theming dan styling
- Responsive layout

### 4. **Error Handling**

- Form validation
- Network error handling
- User-friendly error messages

## 🚀 Usage Examples

### Simple Add Category

```dart
// Show modal
await showAddCategorySheet(context);
```

### With Success Callback

```dart
final result = await showAddCategorySheet(context);
if (result == true) {
  // Category berhasil ditambahkan
  // CategoryBloc sudah auto-update list
}
```

### Integration in Dashboard

```dart
// Dashboard add button
if (index == 1) {
  showAddProductSheet(context); // Shows option modal
  // User dapat pilih "Kategori" atau "Produk"
}
```

## 🎉 Result

Fitur add category yang lengkap dengan:

- ✅ **Beautiful UI**: Modern design dengan icon dan form
- ✅ **Auto-Update**: CategoryBloc smart state management
- ✅ **Integration**: Seamless dengan AddProductSheet
- ✅ **Validation**: Form validation dan error handling
- ✅ **Feedback**: Loading states dan success/error messages
- ✅ **Clean Code**: Separated helpers dan reusable components

User flow: Dashboard → Add → Kategori → Form → Submit → Auto-update di Product form! 🎯
