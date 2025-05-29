# 🔍 Product Filter by Category - Complete Implementation

Implementasi lengkap fitur filter produk berdasarkan kategori dengan chip horizontal dan auto-update integration.

## 📁 Struktur File

```
lib/feature/product/
├── presentation/
│   ├── bloc/
│   │   ├── product_bloc.dart             # ✅ Updated: FilterProductEvent
│   │   ├── product_event.dart            # ✅ Added: FilterProductEvent
│   │   └── product_state.dart            # ProductLoaded states
│   ├── widgets/
│   │   ├── category_filter_chips.dart    # ✅ NEW: Horizontal filter chips
│   │   └── product_item.dart             # Product display items
│   └── pages/
│       └── product_page.dart             # ✅ Updated: Integrated filter chips
```

## 🎯 Fitur Utama

### 1. **FilterProductEvent**

```dart
final class FilterProductEvent extends ProductEvent {
  final String? categoryId;

  const FilterProductEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId ?? ''];
}
```

### 2. **ProductBloc Filter Logic**

```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductResponseModel? _currentProducts;
  ProductResponseModel? _allProducts; // Cache untuk filtering

  on<FilterProductEvent>((event, emit) async {
    if (_allProducts == null) return;

    try {
      List<Product> filteredProducts;

      if (event.categoryId == null || event.categoryId!.isEmpty) {
        // Tampilkan semua produk
        filteredProducts = List<Product>.from(_allProducts!.data ?? []);
      } else {
        // Filter berdasarkan kategori
        filteredProducts = List<Product>.from(_allProducts!.data ?? [])
            .where((product) => product.categoryId == event.categoryId)
            .toList();
      }

      _currentProducts = ProductResponseModel(
        status: _allProducts!.status,
        message: _allProducts!.message,
        data: filteredProducts,
      );

      emit(ProductLoaded(_currentProducts!));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  });
}
```

### 3. **CategoryFilterChips Widget**

Horizontal scrollable chips dengan:

- **"Semua Menu" chip**: Default selection untuk menampilkan semua produk
- **Category chips**: Dynamic dari CategoryBloc
- **Selection state**: Visual feedback untuk chip yang dipilih
- **Auto-loading**: Load categories pada initState

## 🎨 UI Design Features

### 1. **Chip Design**

```dart
FilterChip(
  label: Text(
    'Semua Menu',
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: selectedCategoryId == null ? Colors.white : primaryColor,
    ),
  ),
  selected: selectedCategoryId == null,
  backgroundColor: Colors.grey[100],
  selectedColor: primaryColor,
  checkmarkColor: Colors.white,
  side: BorderSide(
    color: selectedCategoryId == null ? primaryColor : Colors.grey[300]!,
    width: 1,
  ),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
)
```

### 2. **Horizontal Layout**

```dart
Container(
  height: 50,
  margin: EdgeInsets.only(bottom: 16),
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      // "Semua Menu" chip
      // Category chips
    ],
  ),
)
```

### 3. **Loading & Error States**

- **Loading**: CircularProgressIndicator
- **Error**: Error message display
- **Empty**: "No categories available"

## 🚀 Integration Flow

### 1. **ProductPage Layout**

```dart
Column(
  children: [
    CategoryFilterChips(),    // ✅ Filter chips
    SearchBar(),              // Search functionality
    ProductGrid(),            // Filtered products
  ],
)
```

### 2. **Filter Interaction**

```dart
void _onCategorySelected(String? categoryId) {
  setState(() {
    selectedCategoryId = categoryId;
  });

  // Trigger filter event
  context.read<ProductBloc>().add(FilterProductEvent(categoryId));
}
```

### 3. **Auto-Update Integration**

- Add new category → CategoryFilterChips auto-update
- Add new product → ProductBloc maintains filtered state
- Delete product → Filter state preserved

## 📊 State Management

### 1. **Smart Caching**

```dart
ProductResponseModel? _allProducts;     // Cache semua produk
ProductResponseModel? _currentProducts; // Produk yang ditampilkan

// Pada GetProductsEvent
_allProducts = response;        // Simpan semua data
_currentProducts = response;    // Set current display

// Pada FilterProductEvent
// Filter dari _allProducts, set ke _currentProducts
```

### 2. **Filter Persistence**

- Filter state tetap saat add/delete product
- Auto-update filtered list saat ada perubahan data
- Reset ke "Semua Menu" saat reload halaman

### 3. **Error Handling**

```dart
if (_allProducts == null) return; // Prevent filter without data

try {
  // Filter logic
  emit(ProductLoaded(_currentProducts!));
} catch (e) {
  emit(ProductError(e.toString()));
}
```

## 🎯 User Experience

### 1. **Empty State Handling**

```dart
if (products.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.inventory_2_outlined, size: 64),
        Text('Tidak ada produk'),
        Text('Coba pilih kategori lain atau tambah produk baru'),
      ],
    ),
  );
}
```

### 2. **Visual Feedback**

- **Selected chip**: Primary color background, white text
- **Unselected chip**: Grey background, primary color text
- **Smooth transitions**: Automatic UI updates

### 3. **Responsive Design**

- Horizontal scrolling untuk banyak kategori
- Consistent spacing (8px between chips)
- Proper padding dan margins

## 🔄 CategoryBloc Integration

### 1. **Category Loading**

```dart
@override
void initState() {
  super.initState();
  // Load categories when widget initializes
  context.read<CategoryBloc>().add(GetCategoriesEvent());
}
```

### 2. **Dynamic Chip Generation**

```dart
BlocBuilder<CategoryBloc, CategoryState>(
  builder: (context, state) {
    if (state is CategoryLoaded) {
      final categories = state.category.data!;

      return ListView(
        children: [
          SemuaMenuChip(),
          ...categories.map((category) => CategoryChip(category)),
        ],
      );
    }
  },
)
```

### 3. **Auto-Update**

- Add category → Chip otomatis muncul
- CategoryBloc auto-update → Filter chips refresh
- No manual refresh needed

## 🚀 Usage Examples

### 1. **Basic Filter**

```dart
// Filter by category
context.read<ProductBloc>().add(FilterProductEvent(categoryId));

// Show all products
context.read<ProductBloc>().add(FilterProductEvent(null));
```

### 2. **Widget Integration**

```dart
// In ProductPage
Column(
  children: [
    CategoryFilterChips(), // Auto-handles category filtering
    SearchBar(),
    ProductGrid(),
  ],
)
```

### 3. **Custom Filter Logic**

```dart
// Custom filter dengan multiple conditions
void customFilter(String? categoryId, String? searchQuery) {
  context.read<ProductBloc>().add(FilterProductEvent(categoryId));
  // Additional search logic dapat ditambahkan
}
```

## 🎉 Key Benefits

### ✅ **Performance**

- Smart caching dengan `_allProducts`
- Client-side filtering (no API calls)
- Optimized UI updates

### ✅ **User Experience**

- Instant filtering response
- Visual selection feedback
- Empty state handling
- Horizontal scrolling

### ✅ **Maintainability**

- Separated widget (`CategoryFilterChips`)
- Clean BLoC event handling
- Reusable filter logic

### ✅ **Integration**

- Auto-sync dengan CategoryBloc
- Compatible dengan existing ProductBloc
- Seamless dengan add/delete operations

## 🎯 Result

Filter produk by category yang lengkap dengan:

- 🔍 **Smart Filtering**: Client-side dengan caching
- 🎨 **Beautiful UI**: Horizontal filter chips dengan visual feedback
- 🔄 **Auto-Update**: Integration dengan CategoryBloc dan ProductBloc
- 📱 **Responsive**: Horizontal scroll, empty states
- 🚀 **Performance**: No unnecessary API calls
- 🎯 **UX**: Instant response, clear visual feedback

User dapat dengan mudah filter produk berdasarkan kategori dan melihat hasil secara instant! 🎉
