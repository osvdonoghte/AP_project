import 'package:flutter/material.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  late List<ProductEntity> allProducts; // Holds all products
  late List<ProductEntity> displayedProducts; // Holds the filtered products

  @override
  void initState() {
    super.initState();
    allProducts = [
      ProductEntity(
        id: 1,
        name: 'کت مجلسی',
        imageUrl:
        'https://media.bergdorfgoodman.com/f_auto,q_auto/01/bg_4910082_100550_m',
        price: 1000,
        originalPrice: 1200,
        rating: 4.5,
        salesCount: 30,
      ),
      ProductEntity(
        id: 2,
        name: 'دورس',
        imageUrl:
        'https://m.media-amazon.com/images/I/61Ey-4KNcYL._AC_SY550_.jpg',
        price: 800,
        originalPrice: 1000,
        rating: 4.0,
        salesCount: 50,
      ),
      ProductEntity(
        id: 3,
        name: 'پالتو',
        imageUrl:
        'https://mantocity.com/wp-content/uploads/2024/12/andia-ma.jpg',
        price: 1500,
        originalPrice: 1600,
        rating: 5.0,
        salesCount: 20,
      ),
      ProductEntity(
        id: 4,
        name: 'پلیور',
        imageUrl:
        'https://m.media-amazon.com/images/I/510BfsGWrcL._AC_SX569_.jpg',
        price: 600,
        originalPrice: 700,
        rating: 4.3,
        salesCount: 10,
      ),
      ProductEntity(
        id: 5,
        name: 'شلوار جین',
        imageUrl:
        'https://brandiol.com/wp-content/uploads/2022/09/20220919_101417.jpg',
        price: 900,
        originalPrice: 1000,
        rating: 4.2,
        salesCount: 40,
      ),
      ProductEntity(
        id: 6,
        name: 'کیف',
        imageUrl:
        'data:image/jpeg;base64,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',
        price: 1200,
        originalPrice: 1300,
        rating: 4.8,
        salesCount: 60,
      ),
    ];
    displayedProducts =
        List.from(allProducts); // Initially, display all products
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedProducts = List.from(allProducts); // Restore all products
      });
      return;
    }

    final searchedProducts =
    allProducts.where((product) => product.name.contains(query)).toList();

    setState(() {
      displayedProducts = searchedProducts;
    });

    if (searchedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('وجود ندارد')),
      );
    }
  }

  void _sortProducts(String sortBy) {
    switch (sortBy) {
      case 'بیشترین قیمت':
        displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'کمترین قیمت':
        displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'پرفروش‌ترین':
        displayedProducts.sort((a, b) => b.salesCount.compareTo(a.salesCount));
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        actions: [
          Container(
            height: 40,
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'جستجو...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: _searchProducts,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SortingBar(onSort: _sortProducts),
              const SizedBox(height: 16),
              _ProductList(products: displayedProducts),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortingBar extends StatelessWidget {
  final Function(String) onSort;

  const _SortingBar({Key? key, required this.onSort}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => onSort('بیشترین قیمت'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('بیشترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () => onSort('کمترین قیمت'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text('کمترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () => onSort('پرفروش‌ترین'),
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
  final List<ProductEntity> products;

  const _ProductList({Key? key, required this.products}) : super(key: key);

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
          childAspectRatio: 0.75,
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
              width: 120,
              height: 120,
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
                    color: Colors.black,
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
  final int salesCount;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.salesCount,
  });
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryProductScreen(categoryName: 'لباس زنانه'),
    ),
  );
}
