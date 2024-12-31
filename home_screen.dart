import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Models
class BannerEntity {
  final int id;
  final String imageUrl;

  BannerEntity({required this.id, required this.imageUrl});
}

class ProductEntity {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final double rate;
  final int salesCount;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rate,
    required this.salesCount,
  });
}

/// Repositories
class BannerRepository {
  Future<List<BannerEntity>> getBanners() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      BannerEntity(id: 1, imageUrl: 'https://example.com/banner1.jpg'),
      BannerEntity(id: 2, imageUrl: 'https://example.com/banner2.jpg'),
      // Add more banners as needed
    ];
  }
}

class ProductRepository {
  // Get Latest Products
  Future<List<ProductEntity>> getLatestProducts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      ProductEntity(
        id: 1,
        name: 'یخچال',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/0f4f4c1bfec584a5be619accb86ca79111144357_1699527484.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 299.99, // Example price
        rate: 4.5, // Example rating
        salesCount: 150, // Example sales count
      ),
      ProductEntity(
        id: 2,
        name: 'موبایل',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/0de19d26d15f9c5e690ac162a17a58a49c412689_1726040983.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 549.99,
        rate: 4.7,
        salesCount: 200,
      ),
      ProductEntity(
        id: 3,
        name: 'پیانو',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/0de19d26d15f9c5e690ac162a17a58a49c412689_1726040983.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 549.99,
        rate: 4.8,
        salesCount: 400,
      ),
      ProductEntity(
        id: 4,
        name: 'لپ‌تاپ',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/124be94a6f42e3f589395fa8e7b9283c6d9b689f_1701290849.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 1299.99,
        rate: 4.6,
        salesCount: 100,
      ),
    ];
  }

  // Get Popular Products
  Future<List<ProductEntity>> getPopularProducts() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return [
      ProductEntity(
        id: 1,
        name: 'میکروفن',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/79e9a49947e4242f346ac9db3e2411d396b9c0fe_1699527415.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 1099.99,
        rate: 4.3,
        salesCount: 80,
      ),
      ProductEntity(
        id: 2,
        name: 'دوربین',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/287dc9c01a399f89c0d609741b49145dbb4cfe17_1680491914.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 3499.99,
        rate: 4.7,
        salesCount: 150,
      ),
      ProductEntity(
        id: 3,
        name: 'پخش‌کننده',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/1b498289c60e5c5b9b330032ecb16dbd09da5448_1689625102.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 799.99,
        rate: 4.0,
        salesCount: 210,
      ),
      ProductEntity(
        id: 4,
        name: 'هدفون',
        imageUrl:
        'https://dkstatics-public.digikala.com/digikala-products/1b48489e418299e9a564e48e14b1b4bba2c3b7a6_1689476182.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80',
        price: 199.99,
        rate: 4.2,
        salesCount: 350,
      ),
    ];
  }
}

/// Bloc
abstract class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomeRefresh extends HomeEvent {}

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<BannerEntity> banners;
  final List<ProductEntity> latestProducts;
  final List<ProductEntity> popularProducts;

  HomeSuccess({
    required this.banners,
    required this.latestProducts,
    required this.popularProducts,
  });
}

class HomeError extends HomeState {
  final Exception exception;

  HomeError({required this.exception});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BannerRepository bannerRepository;
  final ProductRepository productRepository;

  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoading()) {
    on<HomeStarted>((event, emit) async {
      emit(HomeLoading());
      try {
        final banners = await bannerRepository.getBanners();
        final latestProducts = await productRepository.getLatestProducts();
        final popularProducts = await productRepository.getPopularProducts();
        emit(HomeSuccess(
          banners: banners,
          latestProducts: latestProducts,
          popularProducts: popularProducts,
        ));
      } catch (e) {
        emit(HomeError(exception: e as Exception));
      }
    });

    on<HomeRefresh>((event, emit) {
      add(HomeStarted());
    });
  }
}

/// HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  List<ProductEntity> _allProducts = [];
  List<ProductEntity> _filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository: BannerRepository(),
          productRepository: ProductRepository(),
        );
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('خانه', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.grey[300],
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(
                      products: _filteredProducts.isEmpty
                          ? _allProducts
                          : _filteredProducts,
                      onSearch: _onSearch,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeSuccess) {
                _allProducts = state.latestProducts + state.popularProducts;
                _filteredProducts = _allProducts;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BannerSlider(banners: state.banners),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'جدیدترین'),
                      _ProductGrid(products: state.latestProducts),
                      const SizedBox(height: 16),
                      _SectionTitle(title: 'پربازدیدترین'),
                      _ProductGrid(products: state.popularProducts),
                    ],
                  ),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.exception.toString()),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                        },
                        child: const Text('تلاش دوباره'),
                      ),
                    ],
                  ),
                );
              } else {
                throw Exception('Unsupported state');
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'سبد خرید',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'حساب کاربری',
            ),
          ],
        ),
      ),
    );
  }

  // Search function to update filtered products based on query
  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _allProducts
          .where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }
}

/// ProductSearchDelegate
class ProductSearchDelegate extends SearchDelegate<String> {
  final List<ProductEntity> products;
  final Function(String) onSearch;

  ProductSearchDelegate({required this.products, required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          leading: Image.network(product.imageUrl),
          onTap: () {
            // Handle selection
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          leading: Image.network(product.imageUrl),
          onTap: () {
            query = product.name;
            onSearch(query);
          },
        );
      },
    );
  }
}

/// Helper Widgets
class _BannerSlider extends StatelessWidget {
  final List<BannerEntity> banners;

  const _BannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                banners[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;

  const _ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      products[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  products[index].name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    ),
  );
}
