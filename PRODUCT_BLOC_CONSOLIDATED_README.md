# 🔄 ProductBloc Consolidated - Unified Product Management

Konsolidasi ProductBloc untuk menangani semua operasi product (Get, Add, Delete) dalam satu bloc dengan state management yang efisien.

## 📁 Struktur Terbaru

```
lib/feature/product/
├── presentation/
│   ├── bloc/
│   │   ├── product_bloc.dart              # ✅ Unified: Get, Add, Delete
│   │   ├── product_event.dart             # All product events
│   │   ├── product_state.dart             # All product states
│   │   └── cart/                          # Separate cart logic
│   └── widgets/
│       ├── add_product_sheet.dart         # Uses ProductBloc
│       └── add_product_helper.dart        # Simple modal helper
```

## 🎯 Unified ProductBloc Features

### Events

```dart
sealed class ProductEvent extends Equatable

// Get all products
final class GetProductsEvent extends ProductEvent

// Add new product
final class AddProductEvent extends ProductEvent {
  final AddProductRequestModel request;
}

// Delete product
final class DeleteProductEvent extends ProductEvent {
  final String productId;
}
```

### States

```dart
sealed class ProductState extends Equatable

class ProductInitial extends ProductState
class ProductLoading extends ProductState      // For all operations

class ProductLoaded extends ProductState {     // List of products
  final ProductResponseModel product;
}

class ProductAdded extends ProductState {      // Success add
  final AddProductResponseModel response;
}

class ProductDeleted extends ProductState {    // Success delete
  final String productId;
}

class ProductError extends ProductState {      // Any error
  final String message;
}
```

## 🚀 Key Features

### 1. **Smart State Management**

- `_currentProducts` menyimpan data produk terkini
- Auto-update list setelah add/delete
- No need manual refresh

### 2. **Optimistic Updates**

```dart
// Add product
on<AddProductEvent>((event, emit) async {
  final response = await remoteDatasource.postProduct(event.request);
  emit(ProductAdded(response));

  // Auto update product list
  if (_currentProducts != null && response.data != null) {
    final updatedProducts = List<Product>.from(_currentProducts!.data ?? []);
    updatedProducts.add(response.data!);

    _currentProducts = ProductResponseModel(/*updated*/);
    emit(ProductLoaded(_currentProducts!));
  }
});
```

### 3. **Efficient Delete**

```dart
// Delete product
on<DeleteProductEvent>((event, emit) async {
  final isDeleted = await remoteDatasource.deleteProduct(event.productId);

  if (isDeleted && _currentProducts != null) {
    final updatedProducts = List<Product>.from(_currentProducts!.data ?? [])
        .where((product) => product.id != event.productId)
        .toList();

    _currentProducts = ProductResponseModel(/*updated*/);
    emit(ProductDeleted(event.productId));
    emit(ProductLoaded(_currentProducts!));
  }
});
```

## 📱 AddProductSheet Integration

### Updated to use ProductBloc

```dart
// Submit form
context.read<ProductBloc>().add(AddProductEvent(request));

// Listen for responses
BlocListener<ProductBloc, ProductState>(
  listener: (context, state) {
    if (state is ProductAdded) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
    } else if (state is ProductError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
)

// Show loading state
BlocBuilder<ProductBloc, ProductState>(
  builder: (context, state) {
    if (state is ProductLoading) {
      return CircularProgressIndicator();
    } else if (state is ProductAdded) {
      return Text('Produk berhasil ditambahkan');
    } else if (state is ProductError) {
      return Text('Gagal: ${state.message}');
    }
    return Container();
  }
)
```

## 🔄 State Flow

```
┌─ GetProductsEvent ─→ ProductLoading ─→ ProductLoaded
│
├─ AddProductEvent ─→ ProductLoading ─→ ProductAdded ─→ ProductLoaded (updated)
│
└─ DeleteProductEvent ─→ ProductDeleted ─→ ProductLoaded (updated)
                     └─ ProductError (if failed)
```

## 🎯 Benefits

### 1. **Single Source of Truth**

- All product operations dalam satu bloc
- Consistent state management
- No state conflicts

### 2. **Auto-Sync Lists**

- Add product → Auto update list
- Delete product → Auto update list
- No manual refresh needed

### 3. **Better Performance**

- Smart caching dengan `_currentProducts`
- Minimal API calls
- Optimistic UI updates

### 4. **Simplified Usage**

```dart
// Add product
showAddProductSheet(context);

// Delete product
context.read<ProductBloc>().add(DeleteProductEvent(productId));

// Refresh products
context.read<ProductBloc>().add(GetProductsEvent());
```

## 📋 API Integration

### ProductRemoteDatasource

```dart
abstract class ProductRemoteDatasource {
  Future<ProductResponseModel> getProducts();
  Future<AddProductResponseModel> postProduct(AddProductRequestModel request);
  Future<bool> deleteProduct(String productId);
}
```

### Request/Response Flow

```dart
// Add Product
AddProductRequestModel {
  categoryId: String,
  name: String,
  price: int,           // ✅ Changed to int
  picturePath: String?
}

// Response
AddProductResponseModel {
  message: String,
  data: Product
}
```

## 🎉 Migration Benefits

### ✅ Before vs After

**Before:**

- Separate AddProductBloc
- Manual list refresh
- Multiple state sources
- Complex integration

**After:**

- Unified ProductBloc
- Auto list updates
- Single state source
- Simple integration

### 🚀 Result

- **Cleaner Architecture**: One bloc for all product operations
- **Better UX**: Auto-updating lists, no manual refresh
- **Simpler Code**: Less boilerplate, easier maintenance
- **Performance**: Smart caching and optimized updates

Usage tetap simple, tapi internal management jauh lebih efisien! 🎯
