import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  // اطلاعات کاربر
  String _username = 'علی';
  String _email = 'ali@example.com';

  // Toggle theme function
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  // به روز رسانی اطلاعات کاربر
  void _updateUserInfo(String username, String email) {
    setState(() {
      // Only update if new value is different
      if (username.isNotEmpty && username != _username) {
        _username = username;
      }
      if (email.isNotEmpty && email != _email) {
        _email = email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: UserProfilePage(
        toggleTheme: _toggleTheme,
        username: _username,
        email: _email,
        updateUserInfo: _updateUserInfo,
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

class UserProfilePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final String username;
  final String email;
  final Function(String, String) updateUserInfo;

  UserProfilePage({
    required this.toggleTheme,
    required this.username,
    required this.email,
    required this.updateUserInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حساب کاربری'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 51,
                backgroundImage:
                NetworkImage('https://via.placeholder.com/151'),
              ),
            ),
            SizedBox(height: 21),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.camera_alt),
              label: Text('ویرایش پروفایل'),
            ),
            SizedBox(height: 21),
            _buildInfoRow('نام کاربری', username),
            _buildInfoRow('ایمیل', email),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditInfoPage(updateUserInfo: updateUserInfo),
                  ),
                );
              },
              child: Text('ویرایش اطلاعات'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleTheme,
              child: Text('تغییر تم'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '$label:',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class EditInfoPage extends StatefulWidget {
  final Function(String, String) updateUserInfo;

  EditInfoPage({required this.updateUserInfo});

  @override
  _EditInfoPageState createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ویرایش اطلاعات'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // نام کاربری
            _buildTextField('نام کاربری', _usernameController),
            SizedBox(height: 10),
            // ایمیل
            _buildTextField('ایمیل', _emailController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // به روز رسانی اطلاعات کاربر
                widget.updateUserInfo(
                  _usernameController.text,
                  _emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('اطلاعات شما به روز شد!'),
                ));
                Navigator.pop(context);
              },
              child: Text('ذخیره تغییرات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      textAlign: TextAlign.right,
    );
  }
}
