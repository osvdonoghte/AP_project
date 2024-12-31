import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductDetailScreen(
        productName: 'کتونی اسپورت',
        productImageUrl: 'https://via.placeholder.com/200',
        previousPrice: 200000,
        currentPrice: 150000,
        description: 'این کتونی برای دویدن و راه رفتن مناسب است.',
        seller: 'فروشگاه ورزشی',
        rating: 4.4,
        stock: 20,
        sold: 50,
        reviews: [
          {
            'text': 'خیلی خوبه!',
            'likes': 0,
            'dislikes': 0,
            'date': DateTime(2024, 12, 30)
          },
          {
            'text': 'کیفیت مناسب دارد.',
            'likes': 0,
            'dislikes': 0,
            'date': DateTime(2024, 12, 29)
          },
          {
            'text': 'خیلی رضایت داشتم.',
            'likes': 0,
            'dislikes': 0,
            'date': DateTime(2024, 12, 28)
          },
        ],
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String productImageUrl;
  final int previousPrice;
  final int currentPrice;
  final String description;
  final String seller;
  final double rating;
  final int stock;
  final int sold;
  final List<Map<String, dynamic>> reviews;

  const ProductDetailScreen({
    Key? key,
    required this.productName,
    required this.productImageUrl,
    required this.previousPrice,
    required this.currentPrice,
    required this.description,
    required this.seller,
    required this.rating,
    required this.stock,
    required this.sold,
    required this.reviews,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double userRating = 0;
  bool hasRated = false;
  bool hasLikedOrDisliked = false;
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    reviews = widget.reviews;
  }

  @override
  Widget build(BuildContext context) {
    reviews.sort((a, b) => b['date'].compareTo(a['date']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('جزئیات محصول'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Image.network(
                widget.productImageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.productName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'فروشنده: ${widget.seller}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('قیمت فعلی', '${widget.currentPrice} تومان'),
            _buildPriceRow('قیمت قبلی', '${widget.previousPrice} تومان'),
            _buildPriceRow('موجودی', '${widget.stock}'),
            const SizedBox(height: 16),
            Text(
              'امتیاز محصول: ${widget.rating.toStringAsFixed(1)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'توضیحات محصول',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('محصول به سبد خرید اضافه شد!'),
                  ),
                );
              },
              child: const Text('افزودن به سبد خرید'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('محصول به لیست علاقه‌مندی‌ها اضافه شد!'),
                  ),
                );
              },
              child: const Text('افزودن به لیست علاقه‌مندی‌ها'),
            ),
            const SizedBox(height: 24),
            const Text(
              'نظرات کاربران',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var review in reviews) _buildReview(review),
            const SizedBox(height: 24),
            _buildReviewInput(context),
            const SizedBox(height: 24),
            const Text(
              'امتیاز شما به این محصول:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < userRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: hasRated
                      ? null
                      : () {
                    setState(() {
                      userRating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            if (!hasRated)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasRated = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text('شما امتیاز $userRating به این محصول دادید!'),
                    ),
                  );
                },
                child: const Text('ثبت امتیاز'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(Map<String, dynamic> review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review['text'],
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'تاریخ: ${review['date'].toString()}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up, color: Colors.blue),
                    onPressed: hasLikedOrDisliked
                        ? null
                        : () {
                      setState(() {
                        review['likes']++;
                        hasLikedOrDisliked = true;
                      });
                    },
                  ),
                  Text('${review['likes']}'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_down, color: Colors.red),
                    onPressed: hasLikedOrDisliked
                        ? null
                        : () {
                      setState(() {
                        review['dislikes']++;
                        hasLikedOrDisliked = true;
                      });
                    },
                  ),
                  Text('${review['dislikes']}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewInput(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'نظر خود را بنویسید...',
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              reviews.add({
                'text': _controller.text,
                'likes': 0,
                'dislikes': 0,
                'date': DateTime.now(),
              });
              _controller.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('نظر شما ثبت شد!'),
              ),
            );
          },
          child: const Text('ارسال نظر'),
        ),
      ],
    );
  }
}
