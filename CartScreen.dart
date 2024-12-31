import 'package:flutter/material.dart';

class SimpleCartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  SimpleCartScreen({required this.cartItems});

  @override
  _SimpleCartScreenState createState() => _SimpleCartScreenState();
}

class _SimpleCartScreenState extends State<SimpleCartScreen> {
  double deliveryCost = 20000; // هزینه ارسال ثابت
  bool hasSubscription = false; // وضعیت اشتراک کاربر
  String selectedAddress = '';
  bool isManualAddress = false;
  TextEditingController addressController = TextEditingController();
  List<String> savedAddresses = ['آدرس ۱', 'آدرس ۲'];

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cartItems
        .fold(0.0, (sum, item) => sum + item.discountedPrice * item.quantity);
    double totalSavings = widget.cartItems.fold(
        0.0,
            (sum, item) =>
        sum + (item.originalPrice - item.discountedPrice) * item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('سبد خرید'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
              child: Text('سبد خرید شما خالی است.'),
            )
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(widget.cartItems[index]);
              },
            ),
          ),
          _buildAddressSection(),
          _buildDeliveryCostSection(),
          _buildTotalPriceSection(totalPrice),
          _buildTotalSavingsSection(totalSavings),
          _buildCheckoutButton(totalPrice),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return ListTile(
      leading: Image.network(
        item.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قیمت اصلی: ${item.originalPrice} تومان',
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.red),
          ),
          Text('قیمت با تخفیف: ${item.discountedPrice} تومان'),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (item.quantity > 1) {
                      item.quantity--;
                    }
                  });
                },
              ),
              Text('تعداد: ${item.quantity}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    item.quantity++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            widget.cartItems.remove(item);
          });
        },
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آدرس مورد نظر',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Checkbox(
                value: isManualAddress,
                onChanged: (value) {
                  setState(() {
                    isManualAddress = value!;
                    if (!isManualAddress) {
                      addressController.clear();
                    }
                  });
                },
              ),
              Text('وارد کردن دستی آدرس'),
            ],
          ),
          if (isManualAddress)
            TextField(
              controller: addressController,
              decoration: InputDecoration(hintText: 'آدرس خود را وارد کنید'),
            )
          else
            DropdownButton<String>(
              value: selectedAddress.isEmpty ? null : selectedAddress,
              hint: Text('انتخاب آدرس'),
              onChanged: (newValue) {
                setState(() {
                  selectedAddress = newValue!;
                });
              },
              items: savedAddresses.map((address) {
                return DropdownMenuItem(
                  child: Text(address),
                  value: address,
                );
              }).toList(),
            ),
          if (!isManualAddress)
            ElevatedButton(
              onPressed: () {},
              child: Text('انتخاب آدرس از روی نقشه'),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCostSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('هزینه ارسال'),
          Text(hasSubscription ? 'رایگان' : '$deliveryCost تومان'),
        ],
      ),
    );
  }

  Widget _buildTotalPriceSection(double totalPrice) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('مجموع قیمت'),
          Text('${totalPrice + (hasSubscription ? 0 : deliveryCost)} تومان'),
        ],
      ),
    );
  }

  Widget _buildTotalSavingsSection(double totalSavings) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('سود شما از این خرید'),
          Text('$totalSavings تومان'),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(double totalPrice) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('نهایی کردن خرید و پرداخت'),
      ),
    );
  }
}

class CartItem {
  final String name;
  final String imageUrl;
  int quantity;
  final int originalPrice;
  final int discountedPrice;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.originalPrice,
    required this.discountedPrice,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleCartScreen(
        cartItems: [
          CartItem(
            name: 'کتونی اسپورت',
            imageUrl: 'https://via.placeholder.com/50',
            quantity: 1,
            originalPrice: 200000,
            discountedPrice: 150000,
          ),
          CartItem(
            name: 'کتونی رسمی',
            imageUrl: 'https://via.placeholder.com/50',
            quantity: 2,
            originalPrice: 300000,
            discountedPrice: 250000,
          ),
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
