# 🔄 AddProduct Bloc Refactor

Refactor fitur Add Product dengan memisahkan logic ke dalam **AddProductBloc** yang terpisah dari **ProductBloc** untuk separation of concerns yang lebih baik.

## 📁 Struktur Baru

```
lib/feature/product/
├── presentation/
│   ├── bloc/
│   │   ├── product_bloc.dart              # Hanya untuk GetProducts
│   │   │   ├── product_bloc.dart
│   │   │   └── product_event.dart
│   │   └── add_product/                   # NEW: Dedicated AddProduct Bloc
│   │   │   ├── add_product_bloc.dart
│   │   │   ├── add_product_event.dart
│   │   │   ├── add_product_state.dart
│   │   │   └── add_product.dart           # Barrel export
│   │   └── cart/
│   └── widgets/
│       ├── add_product_sheet.dart         # UPDATED: Uses AddProductBloc
│       └── add_product_helper.dart        # UPDATED: Provides AddProductBloc
```

## 🎯 Benefits Refactor

### 1. **Separation of Concerns**

- **ProductBloc**: Hanya untuk `GetProducts`
- **AddProductBloc**: Dedicated untuk add product logic
- Tidak ada mixing responsibilities

### 2. **Better State Management**

- Isolated loading states
- Cleaner error handling
- Independent state cycles

### 3. **Improved Maintainability**

- Easier to test individual features
- Simpler debugging
- Clear responsibility boundaries

### 4. **Enhanced Performance**

- No unnecessary rebuilds
- Focused state updates
- Better memory management

## 📋 Events & States

### AddProductEvent

```dart
abstract class AddProductEvent extends Equatable

class AddProductSubmitted extends AddProductEvent {
  final AddProductRequestModel request;
}

class AddProductReset extends AddProductEvent
```

### AddProductState

```dart
abstract class AddProductState extends Equatable

class AddProductInitial extends AddProductState
class AddProductLoading extends AddProductState
class AddProductSuccess extends AddProductState {
  final AddProductResponseModel response;
}
class AddProductFailure extends AddProductState {
  final String message;
}
```

## 🔄 Refactor Changes

### 1. **ProductBloc Simplified**

```dart
// BEFORE: Mixed responsibilities
ProductBloc() {
  on<GetProductsEvent>(_onGetProducts);
  on<AddProductEvent>(_onAddProduct);  // ❌ Removed
}

// AFTER: Single responsibility
ProductBloc() {
  on<GetProductsEvent>(_onGetProducts);  // ✅ Only GetProducts
}
```

### 2. **AddProductSheet Updated**

```dart
// BEFORE: Used ProductBloc
BlocListener<ProductBloc, ProductState>(
  listener: (context, state) {
    if (state is ProductAdded) { ... }
  }
)

// AFTER: Uses dedicated AddProductBloc
BlocListener<AddProductBloc, AddProductState>(
  listener: (context, state) {
    if (state is AddProductSuccess) { ... }
  }
)
```

### 3. **Helper Function Enhanced**

```dart
// BEFORE: Simple modal
showModalBottomSheet(
  builder: (context) => AddProductSheet()
)

// AFTER: Provides AddProductBloc
showModalBottomSheet(
  builder: (context) => BlocProvider(
    create: (context) => sl<AddProductBloc>(),
    child: AddProductSheet(),
  )
)
```

### 4. **Service Locator Updated**

```dart
// Added registration
sl.registerFactory<AddProductBloc>(
  () => AddProductBloc(sl()),
);
```

## 🚀 Usage (No Changes)

Usage tetap sama seperti sebelumnya:

```dart
// Show modal
showAddProductSheet(context);

// Return value now indicates success
final result = await showAddProductSheet(context);
if (result == true) {
  // Product successfully added
}
```

## 🎯 Key Improvements

### 1. **Cleaner State Management**

- Loading state hanya untuk add product
- No interference dengan product list state
- Independent error handling

### 2. **Better UX**

- More responsive UI
- Cleaner state transitions
- Better loading indicators

### 3. **Enhanced Maintainability**

- Easier to add new add-product features
- Simpler testing
- Clear separation of concerns

### 4. **Performance Optimized**

- Focused rebuilds
- Better memory usage
- Faster state updates

## 📝 Migration Notes

### Breaking Changes

- None for external usage
- Internal bloc usage changed in AddProductSheet

### Benefits

- ✅ Better architecture
- ✅ Improved performance
- ✅ Easier maintenance
- ✅ Cleaner code

## 🎉 Result

Refactor berhasil dengan:

- **Separation of Concerns** yang jelas
- **Performance** yang lebih baik
- **Maintainability** yang lebih mudah
- **Code quality** yang lebih tinggi

Usage tetap sama, tapi internal architecture jauh lebih clean! 🚀
