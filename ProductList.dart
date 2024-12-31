import 'package:flutter/material.dart';

class CategoryProductScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        actions: [
          Container(
            height: 40,
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'جستجو...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SortingBar(),
              const SizedBox(height: 16),
              _ProductList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('بیشترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('کمترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('پرفروش‌ترین'),
          ),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final List<ProductEntity> products = [
    ProductEntity(
      id: 1,
      name: 'Product 1',
      imageUrl: 'https://m.media-amazon.com/images/I/61Ey-4KNcYL._AC_SY550_.jpg',
      price: 1000,
      originalPrice: 1200,
      rating: 4.5,
    ),
    ProductEntity(
      id: 2,
      name: 'Product 2',
      imageUrl: 'https://m.media-amazon.com/images/I/61Ey-4KNcYL._AC_SY550_.jpg',
      price: 800,
      originalPrice: 1000,
      rating: 4.0,
    ),
    ProductEntity(
      id: 3,
      name: 'Product 3',
      imageUrl: 'https://www.net-a-porter.com/variants/images/1647597292605947/in/w920_q60.jpg',
      price: 1500,
      originalPrice: 1600,
      rating: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductItem(product: product);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductEntity product;

  const _ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey[100],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'تومان ${product.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                if (product.originalPrice > product.price)
                  Text(
                    'تومان ${product.originalPrice}',
                    style: const TextStyle(
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductEntity {
  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final int originalPrice;
  final double rating;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.rating,
  });
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryProductScreen(categoryName: 'Electronics'),
    ),
  );
}
