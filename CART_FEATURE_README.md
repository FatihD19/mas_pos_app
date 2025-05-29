# 🛒 Fitur Cart (Keranjang Belanja) - Local Storage

Fitur cart yang dibuat menggunakan **SharedPreferences** untuk menyimpan data secara lokal, dengan arsitektur **BLoC** untuk state management.

## 📁 Struktur File yang Dibuat

```
lib/feature/product/
├── data/
│   ├── model/
│   │   └── cart_item_model.dart          # Model untuk item keranjang
│   └── datasource/
│       └── product_local_datasource.dart # Local storage dengan SharedPreferences
├── presentation/
│   ├── bloc/cart/
│   │   ├── cart_bloc.dart                # BLoC untuk cart logic
│   │   ├── cart_event.dart               # Events untuk cart actions
│   │   ├── cart_state.dart               # States untuk cart status
│   │   └── cart.dart                     # Barrel export file
│   ├── pages/
│   │   └── cart_page.dart                # Halaman keranjang belanja
│   └── widgets/
│       ├── cart_button.dart              # Button cart dengan badge counter (UPDATED)
│       └── product_item.dart             # Product item dengan tombol add to cart (UPDATED)
```

## 🚀 Fitur yang Tersedia

### 1. **Add to Cart**

- Tambah produk ke keranjang dari ProductItem
- Jika produk sudah ada, quantity akan bertambah
- Menampilkan snackbar konfirmasi

### 2. **Cart Management**

- Lihat semua item di keranjang
- Update quantity per item (increment/decrement)
- Hapus item individual
- Hapus semua item (clear cart)

### 3. **Real-time Updates**

- Badge counter di cart button otomatis update
- Total harga dan jumlah item real-time
- State management menggunakan BLoC

### 4. **Persistent Storage**

- Data tersimpan menggunakan SharedPreferences
- Data bertahan setelah app restart
- Singleton pattern untuk efisiensi

## 🎯 Cara Penggunaan

### Menambah Produk ke Cart

```dart
context.read<CartBloc>().add(AddToCart(product));
```

### Update Quantity

```dart
context.read<CartBloc>().add(
  UpdateCartItemQuantity(productId, newQuantity)
);
```

### Remove Item

```dart
context.read<CartBloc>().add(RemoveFromCart(productId));
```

### Clear All Cart

```dart
context.read<CartBloc>().add(ClearCart());
```

## 🔧 Dependencies yang Digunakan

- `shared_preferences`: Local storage
- `flutter_bloc`: State management
- `equatable`: Object comparison

## 📱 UI/UX Features

### Cart Button

- Icon shopping cart dengan badge counter
- Badge muncul hanya jika ada item di cart
- Counter menampilkan "99+" jika lebih dari 99 item
- Navigasi ke cart page saat diklik

### Cart Page

- Empty state jika keranjang kosong
- List item dengan gambar, nama, harga, dan quantity
- Quantity controls (-, +) dengan validasi
- Remove individual item
- Clear all dengan confirmation dialog
- Bottom summary dengan total items dan harga
- Checkout button (ready untuk implementasi)

### Product Item

- Tombol "Tambah" yang terintegrasi dengan cart
- Loading state handling
- Error handling dengan user feedback

## 🎨 Styling

Menggunakan theme yang sudah ada:

- `primaryColor`: Blue untuk buttons dan accents
- `primaryTextStyle`: Untuk text utama
- `secondaryTextStyle`: Untuk text secondary
- `buttonTextStyle`: Untuk text di button

## 🔄 State Management Flow

```
User Action → CartEvent → CartBloc → ProductLocalDatasource → SharedPreferences
     ↑                                        ↓
UI Update ← CartState ← CartBloc ← Data Response
```

## 🛠️ Setup yang Sudah Dilakukan

1. ✅ Model CartItem dengan JSON serialization
2. ✅ ProductLocalDatasource dengan CRUD operations
3. ✅ Cart BLoC dengan semua events & states
4. ✅ CartPage dengan complete UI
5. ✅ Updated ProductItem untuk add to cart
6. ✅ Updated CartButton dengan badge counter
7. ✅ Service Locator registration
8. ✅ Provider setup di main.dart

## 🎉 Siap Digunakan!

Fitur cart sudah fully functional dan siap digunakan. Integrasikan dengan halaman product listing dan fitur ini akan langsung berfungsi.

### Next Steps (Optional):

- Implement checkout functionality
- Add cart persistence expiry
- Add quantity input validation
- Add product variant support
