import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Models
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

// Repositories
class BannerRepository {
  Future<List<BannerEntity>> getBanners() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      BannerEntity(id: 1, imageUrl: 'https://imageurl1.com'),
      BannerEntity(id: 2, imageUrl: 'https://imageurl2.com'),
      BannerEntity(id: 3, imageUrl: 'https://imageurl3.com'),
      BannerEntity(id: 4, imageUrl: 'https://imageurl4.com'),
      BannerEntity(id: 5, imageUrl: 'https://imageurl5.com'),
    ];
  }
}

class ProductRepository {
  Future<List<ProductEntity>> getLatestProducts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      ProductEntity(
          id: 1,
          name: 'کیف',
          imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/112450676.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80'),
      ProductEntity(
          id: 2,
          name: 'موبایل',
          imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/0de19d26d15f9c5e690ac162a17a58a49c412689_1726040983.jpg?x-oss-process=image/resize,m_lfit,h_300,w_300/format,webp/quality,q_80'),
      ProductEntity(
          id: 3,
          name: 'پیانو',
          imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/163253748.jpg'),
    ];
  }
}

// BLoC States
abstract class BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;
  BannerLoaded({required this.banners});
}

class BannerError extends BannerState {
  final String message;
  BannerError({required this.message});
}

abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  ProductLoaded({required this.products});
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

// BLoC Events
abstract class BannerEvent {}

class LoadBanners extends BannerEvent {}

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

// BLoC Logic
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository bannerRepository;

  BannerBloc({required this.bannerRepository}) : super(BannerLoading());

  @override
  Stream<BannerState> mapEventToState(BannerEvent event) async* {
    if (event is LoadBanners) {
      yield BannerLoading();
      try {
        final banners = await bannerRepository.getBanners();
        yield BannerLoaded(banners: banners);
      } catch (e) {
        yield BannerError(message: e.toString());
      }
    }
  }
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductLoading());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is LoadProducts) {
      yield ProductLoading();
      try {
        final products = await productRepository.getLatestProducts();
        yield ProductLoaded(products: products);
      } catch (e) {
        yield ProductError(message: e.toString());
      }
    }
  }
}

// UI

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BannerRepository bannerRepository = BannerRepository();
  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BannerBloc(bannerRepository: bannerRepository),
          ),
          BlocProvider(
            create: (_) => ProductBloc(productRepository: productRepository),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BannerBloc>().add(LoadBanners());
    context.read<ProductBloc>().add(LoadProducts());

    return Scaffold(
      appBar: AppBar(title: Text('E-commerce App')),
      body: ListView(
        children: [
          BlocBuilder<BannerBloc, BannerState>(
            builder: (context, bannerState) {
              if (bannerState is BannerLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (bannerState is BannerLoaded) {
                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                  items: bannerState.banners
                      .map((banner) => Image.network(banner.imageUrl))
                      .toList(),
                );
              }
              if (bannerState is BannerError) {
                return Center(
                    child:
                    Text('Error loading banners: ${bannerState.message}'));
              }
              return Container();
            },
          ),
          SizedBox(height: 20),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (productState is ProductLoaded) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: productState.products.length,
                  itemBuilder: (context, index) {
                    final product = productState.products[index];
                    return Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(product.imageUrl),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (productState is ProductError) {
                return Center(
                    child: Text(
                        'Error loading products: ${productState.message}'));
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
