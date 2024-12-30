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

  ProductEntity({required this.id, required this.name, required this.imageUrl});
}

/// Repositories
class BannerRepository {
  Future<List<BannerEntity>> getBanners() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      BannerEntity(id: 1, imageUrl: 'assets/banner1.png'),
      BannerEntity(id: 2, imageUrl: 'assets/banner2.png'),
    ];
  }
}

class ProductRepository {
  Future<List<ProductEntity>> getLatestProducts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      ProductEntity(id: 1, name: 'Product 1', imageUrl: 'assets/product1.png'),
      ProductEntity(id: 2, name: 'Product 2', imageUrl: 'assets/product2.png'),
    ];
  }

  Future<List<ProductEntity>> getPopularProducts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      ProductEntity(id: 3, name: 'Popular Product 1', imageUrl: 'assets/product3.png'),
      ProductEntity(id: 4, name: 'Popular Product 2', imageUrl: 'assets/product4.png'),
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
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
          title: Column(
            children: [
              const Text(
                'دسته بندی کالاها',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                height: 40,
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
          centerTitle: true,
          backgroundColor: Colors.grey[300],
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeSuccess) {
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
            child: Image.asset(
              banners[index].imageUrl,
              fit: BoxFit.cover,
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: Image.asset(
                products[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              products[index].name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
