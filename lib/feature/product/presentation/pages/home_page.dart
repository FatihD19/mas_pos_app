import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/feature/product/data/model/product_response_model.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/product/product_bloc.dart';
import 'package:mas_pos_app/feature/product/presentation/pages/product_page.dart';
import 'package:mas_pos_app/feature/product/presentation/widgets/product_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(GetProductsEvent());
    super.initState();
  }

  final List<String> imgCarousel = [
    "assets/img_carousel_1.png",
    "assets/img_carousel_2.png",
    "assets/img_carousel_3.png",
  ];
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Cari nama produk...',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Banner
                CarouselSlider(
                  items: imgCarousel.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                        ),
                      ),
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgCarousel.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                // Diminati pembeli section
                Row(
                  children: [
                    Text(
                      'Diminati pembeli ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '😋',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Product cards
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ProductError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is ProductLoaded) {
                      final products = state..product.data;
                      return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: products.product.data!.map((product) {
                            return ProductItem(data: product);
                          }).toList()));
                    }
                    return Center(child: Text('No products available'));
                  },
                ),
                SizedBox(height: 24),
                // Produk yang dijual section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produk yang dijual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage())),
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Product grid
                BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is ProductLoaded) {
                    final products = state..product.data;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.product.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = products.product.data![index];
                        return ProductItem(data: product);
                      },
                    );
                  }
                  return Center(child: Text('No products available'));
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
