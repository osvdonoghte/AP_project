import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PaymentPage(),
  ));
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardPasswordController = TextEditingController();
  String? errorMessage;
  String? successMessage;

  final String correctPassword = '1234'; // Example password
  final String paymentAmount = '200000'; // Example payment amount

  void _handlePayment() {
    final String cardPassword = _cardPasswordController.text.trim();
    final String cardNumber = _cardNumberController.text.trim();

    if (cardPassword != correctPassword) {
      setState(() {
        errorMessage = 'رمز عبور نادرست است';
        successMessage = null; // Clear any previous success message
      });
      return;
    }

    // Simulate payment success
    setState(() {
      errorMessage = null; // Clear any previous error
      successMessage = 'پرداخت موفقیت آمیز بود';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            const Text('پرداخت', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: const [
                    Text(
                      'مبلغ پرداخت:',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '200,000 تومان',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight, // Align label to the right
                child: const Text(
                  'شماره کارت',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              _buildInputField(
                hint: 'شماره کارت را وارد کنید',
                controller: _cardNumberController,
                maxLength: 16,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight, // Align label to the right
                child: const Text(
                  'رمز عبور',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              _buildInputField(
                hint: 'رمز را وارد کنید',
                controller: _cardPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'پرداخت',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              if (successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      successMessage!,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLength: maxLength,
        keyboardType: keyboardType,
        textAlign: TextAlign.right, // Align text to the right inside the box
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
