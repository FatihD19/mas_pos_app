# ➕ Fitur Add Product - Modal Bottom Sheet

Fitur add product yang dibuat menggunakan **Modal Bottom Sheet** dengan form lengkap untuk menambahkan produk baru, terintegrasi dengan **ProductBloc** dan **CategoryBloc**.

## 📁 Struktur File yang Dibuat

```
lib/feature/product/
├── presentation/
│   ├── bloc/
│   │   └── product_bloc.dart              # Updated: Added AddProductEvent handler
│   └── widgets/
│       ├── add_product_sheet.dart         # Modal bottom sheet form
│       └── add_product_helper.dart        # Helper function untuk show modal
```

## 🚀 Fitur yang Tersedia

### 1. **Upload Gambar**

- Image picker dari gallery
- Preview gambar yang dipilih
- Validasi ukuran file (max 5MB)
- Support format JPG & PNG
- UI dengan drag & drop area

### 2. **Form Validation**

- Nama produk (required)
- Harga (required, numeric)
- Kategori (required, dropdown)
- Real-time validation feedback

### 3. **Dynamic Category Dropdown**

- Data kategori diambil dari CategoryBloc
- Loading state saat fetch categories
- Error handling jika gagal load
- Dropdown terintegrasi dengan CategoryModel

### 4. **State Management**

- ProductBloc untuk handle add product
- BlocListener untuk response handling
- Loading state dengan indicator
- Success/error feedback dengan SnackBar

## 🎯 Cara Penggunaan

### Menampilkan Modal Add Product

```dart
import 'package:mas_pos_app/feature/product/presentation/widgets/add_product_helper.dart';

// Dalam widget/page
ElevatedButton(
  onPressed: () => showAddProductSheet(context),
  child: Text('Tambah Produk'),
)
```

### Manual Modal Implementation

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.9,
    child: const AddProductSheet(),
  ),
);
```

## 🔧 Komponen Utama

### AddProductSheet Widget

- **StatefulWidget** dengan form management
- **GlobalKey<FormState>** untuk validation
- **TextEditingController** untuk input fields
- **ImagePicker** untuk upload gambar
- **BlocListener** & **BlocBuilder** untuk state management

### Key Features:

```dart
// Form Controllers
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _priceController = TextEditingController();

// Image & Category Selection
File? _selectedImage;
CategoryModel? _selectedCategory;

// Loading State
bool _isLoading = false;
```

## 📱 UI/UX Features

### Modal Design

- Bottom sheet dengan rounded corners
- Handle bar untuk drag indication
- Responsive height (90% screen)
- Smooth animations

### Image Upload Area

- Large upload zone dengan icons
- Drag & drop visual indication
- Image preview setelah dipilih
- File size validation message

### Form Fields

- Clean material design
- Consistent styling dengan theme
- Real-time validation
- Error messages dalam bahasa Indonesia

### Category Dropdown

- Loading indicator saat fetch data
- Error handling UI
- Smooth dropdown animation
- Category validation

### Action Buttons

- Batal (Outlined) & Tambah (Filled) buttons
- Loading state pada tombol Tambah
- Disabled state saat processing

## 🔄 State Flow

```
User Opens Modal → Load Categories → User Fills Form → Validation →
Submit → ProductBloc → API Call → Success/Error → Close Modal → Refresh List
```

### Detailed Flow:

1. **Modal Open**: `initState()` → Load categories
2. **Form Input**: User mengisi form dengan validation
3. **Image Select**: ImagePicker → File preview
4. **Category Select**: Dropdown dari CategoryBloc data
5. **Submit**: Validation → AddProductEvent → API call
6. **Response**: Success → Close modal + SnackBar + Refresh list
7. **Error**: Show error SnackBar, form tetap terbuka

## 🎨 Styling

### Menggunakan Theme Consistency:

- `primaryColor`: Button colors dan focus borders
- `primaryTextStyle`: Text utama dan labels
- `secondaryTextStyle`: Hint text dan descriptions
- `buttonTextStyle`: Button text styling

### Custom Styling:

- Border radius: 8px untuk form fields, 12px untuk containers
- Colors: Grey[300] untuk borders, Grey[50] untuk backgrounds
- Spacing: Consistent 8, 16, 20, 24px margins

## 🛠️ Setup yang Sudah Dilakukan

1. ✅ **ProductBloc Updated**: Added AddProductEvent handler
2. ✅ **AddProductSheet**: Complete modal form widget
3. ✅ **Image Upload**: ImagePicker integration
4. ✅ **Category Integration**: CategoryBloc dropdown
5. ✅ **Form Validation**: Complete validation logic
6. ✅ **Helper Function**: Easy modal display
7. ✅ **State Management**: BlocListener & BlocBuilder
8. ✅ **Error Handling**: Comprehensive error handling

## 📋 API Integration

### Request Model (AddProductRequestModel):

```dart
{
  "categoryId": "string",
  "name": "string",
  "price": "string",
  "picturePath": "string?" // Optional file path
}
```

### API Call Flow:

```dart
FormData.fromMap({
  'category_id': request.categoryId,
  'name': request.name,
  'price': request.price,
  'picture': MultipartFile.fromFile(...), // If image selected
})
```

## 🔍 Validation Rules

### Field Validations:

- **Nama Produk**: Required, not empty
- **Harga**: Required, numeric, > 0
- **Kategori**: Required selection
- **Gambar**: Optional, size validation (5MB max)

### Error Messages:

- "Nama produk tidak boleh kosong"
- "Harga tidak boleh kosong"
- "Harga harus berupa angka yang valid"
- "Silakan pilih kategori"

## 🎉 Ready to Use!

Fitur Add Product sudah fully functional dan siap diintegrasikan ke aplikasi.

### Quick Integration:

```dart
// Di AppBar atau FAB
IconButton(
  icon: Icon(Icons.add),
  onPressed: () => showAddProductSheet(context),
)
```

### Next Steps (Optional):

- Add image compression
- Multiple image upload
- Product variant support
- Barcode scanner integration
- Draft save functionality
