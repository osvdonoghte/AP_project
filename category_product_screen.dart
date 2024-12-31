import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'payment_page.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  late List<ProductEntity> allProducts;
  late List<ProductEntity> displayedProducts;
  List<CartItem> cartItems = [];

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
        description: 'یک کت مجلسی شیک و جذاب.',
        seller: 'فروشگاه A',
        stock: 10,
        reviews: [
          {'text': 'عالیه!', 'likes': 10, 'dislikes': 2, 'date': DateTime(2024, 12, 30)},
          {'text': 'کیفیت خوب', 'likes': 5, 'dislikes': 1, 'date': DateTime(2024, 12, 29)},
        ],
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
        description: 'لباس دورس مناسب برای فصول سرد.',
        seller: 'فروشگاه B',
        stock: 15,
        reviews: [
          {'text': 'خیلی خوبه!', 'likes': 8, 'dislikes': 3, 'date': DateTime(2024, 12, 30)},
          {'text': 'گرم و راحت', 'likes': 7, 'dislikes': 1, 'date': DateTime(2024, 12, 29)},
        ],
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
        description: 'پالتوی گرم و با کیفیت.',
        seller: 'فروشگاه C',
        stock: 5,
        reviews: [
          {'text': 'بسیار گرم و نرم', 'likes': 15, 'dislikes': 2, 'date': DateTime(2024, 12, 28)},
        ],
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
        description: 'پلیور مناسب برای فصول سرد.',
        seller: 'فروشگاه D',
        stock: 20,
        reviews: [
          {'text': 'خیلی گرم و راحت', 'likes': 12, 'dislikes': 1, 'date': DateTime(2024, 12, 27)},
        ],
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
        description: 'شلوار جین با کیفیت عالی.',
        seller: 'فروشگاه E',
        stock: 30,
        reviews: [
          {'text': 'بسیار خوش دوخت', 'likes': 18, 'dislikes': 3, 'date': DateTime(2024, 12, 26)},
        ],
      ),
      ProductEntity(
        id: 6,
        name: 'کیف',
        imageUrl:
        'https://example.com/image-of-bag.jpg',
        price: 1200,
        originalPrice: 1300,
        rating: 4.8,
        salesCount: 60,
        description: 'کیف با کیفیت و شیک.',
        seller: 'فروشگاه F',
        stock: 25,
        reviews: [
          {'text': 'خیلی خوبه!', 'likes': 20, 'dislikes': 5, 'date': DateTime(2024, 12, 25)},
        ],
      ),
    ];
    displayedProducts = List.from(allProducts); // Initially, display all products
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedProducts = List.from(allProducts); // Restore all products
      });
      return;
    }

    final searchedProducts = allProducts.where((product) => product.name.contains(query)).toList();

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

  void _addToCart(CartItem cartItem) {
    final existingItem = cartItems.firstWhere((item) => item.name == cartItem.name, orElse: () {
      cartItems.add(cartItem);
      return cartItem;
    });

    if (existingItem != cartItem) {
      setState(() {
        existingItem.quantity++;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('محصول به سبد خرید اضافه شد!')),
    );
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
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: _searchProducts,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)),
              );
            },
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
              _ProductList(products: displayedProducts, addToCart: _addToCart),
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
  final Function(CartItem) addToCart;

  const _ProductList({Key? key, required this.products, required this.addToCart}) : super(key: key);

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
          return _ProductItem(product: product, addToCart: addToCart);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductEntity product;
  final Function(CartItem) addToCart;

  const _ProductItem({Key? key, required this.product, required this.addToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: product.name,
              productImageUrl: product.imageUrl,
              previousPrice: product.originalPrice,
              currentPrice: product.price,
              description: product.description,
              seller: product.seller,
              rating: product.rating,
              stock: product.stock,
              sold: product.salesCount,
              reviews: product.reviews,
              addToCart: addToCart,
            ),
          ),
        );
      },
      child: Card(
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
                  onPressed: () {
                    final cartItem = CartItem(
                      name: product.name,
                      imageUrl: product.imageUrl,
                      quantity: 1,
                      originalPrice: product.originalPrice,
                      discountedPrice: product.price,
                    );
                    addToCart(cartItem);
                  },
                ),
              ),
            ],
          ),
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
  final String description;
  final String seller;
  final int stock;
  final List<Map<String, dynamic>> reviews;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.salesCount,
    required this.description,
    required this.seller,
    required this.stock,
    required this.reviews,
  });
}
