import 'dart:convert';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'user_profile_page.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

Future<void> signUp(String username, String password) async {
  try {
    // For local testing, use 127.0.0.1 if you're on iOS simulator or desktop.
    // If you're on Android emulator, consider 10.0.2.2
    final socket = await Socket.connect('10.0.2.2', 12345);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // Send the signup command
    socket.write('SIGNUP||$username||$password\n');
    await socket.flush();

    // Listen for the response from the server
    socket.listen(
      (data) {
        final response = String.fromCharCodes(data).trim();
        print('Server response: $response');
        // Once you have the response, you can handle it (show a dialog, etc.)
        socket.destroy();
      },
      onError: (error) {
        print('Error: $error');
        socket.destroy();
      },
      onDone: () {
        print('Server closed connection');
        socket.destroy();
      },
    );
  } catch (e) {
    print('Could not connect to the server: $e');
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoginMode = true;
  String errorMessage = '';
  late UserDetails userDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;

    String? validateEmail(String email) {
      final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!regex.hasMatch(email)) {
        return 'لطفا یک ایمیل معتبر وارد کنید';
      }
      return null;
    }

    String? validatePassword(String password) {
      final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
      if (!regex.hasMatch(password)) {
        return 'رمز عبور باید حداقل ۸ حرف باشد، شامل یک حرف بزرگ، یک حرف کوچک و یک عدد باشد';
      }
      if (password.contains(usernameController.text)) {
        return 'رمز عبور نباید شامل نام کاربری باشد';
      }
      return null;
    }

    void loginOrRegister() {
      final emailError = validateEmail(usernameController.text);
      final passwordError = validatePassword(passwordController.text);
      if (emailError != null || passwordError != null) {
        setState(() {
          errorMessage = emailError ?? passwordError!;
        });
        return;
      }
      if (!isLoginMode &&
          passwordController.text != confirmPasswordController.text) {
        setState(() {
          errorMessage = 'رمز عبور و تکرار آن مطابقت ندارند';
        });
        return;
      }

      // ذخیره اطلاعات کاربر
      userDetails = UserDetails(
        email: usernameController.text,
        password: passwordController.text,
        username: usernameController.text,
      );

      // ناوبری به صفحه هوم
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(), // تغییر صفحه به HomeScreen
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: themeData.scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/nike_logo.png',
                color: Colors.white,
                width: 120,
              ),
              const SizedBox(height: 24),
              Text(
                isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                style: const TextStyle(color: onBackground, fontSize: 22),
              ),
              const SizedBox(height: 16),
              Text(
                isLoginMode
                    ? 'لطفا وارد حساب کاربری خود شوید'
                    : 'ایمیل و رمز عبور خود را تعیین کنید',
                style: const TextStyle(color: onBackground, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'آدرس ایمیل',
                ),
                onChanged: (_) => setState(() => errorMessage = ''),
              ),
              const SizedBox(height: 16),
              _PasswordTextField(
                onBackground: onBackground,
                controller: passwordController,
                onChanged: (_) => setState(() => errorMessage = ''),
              ),
              if (!isLoginMode)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _PasswordTextField(
                    onBackground: onBackground,
                    controller: confirmPasswordController,
                    labelText: 'تکرار رمز عبور',
                    onChanged: (_) => setState(() => errorMessage = ''),
                  ),
                ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loginOrRegister,
                child: Text(isLoginMode ? 'ورود' : 'ثبت نام'),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoginMode = !isLoginMode;
                    errorMessage = '';
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLoginMode
                          ? 'حساب کاربری ندارید؟'
                          : 'حساب کاربری دارید؟',
                      style: TextStyle(color: onBackground.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isLoginMode ? 'ثبت نام' : 'ورود',
                      style: TextStyle(
                          color: themeData.colorScheme.primary,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginService {
  final String serverAddress;
  final int port;

  LoginService({required this.serverAddress, required this.port});

  Future<String> login(String username, String password) async {
    try {
      final socket = await Socket.connect(serverAddress, port);
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // Send the login request to the server
      socket.write('LOGIN||$username||$password\n');
      await socket.flush();

      // Collect the response data
      List<int> responseBytes = [];
      await socket.listen((data) {
        responseBytes.addAll(data);
      }).asFuture();

      socket.destroy();

      // Decode response bytes to String
      String response = String.fromCharCodes(responseBytes);
      return response;
    } catch (e) {
      return 'ERROR: Unable to connect to server - $e';
    }
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.onBackground,
    required this.controller,
    this.labelText = 'رمز عبور',
    this.onChanged,
  }) : super(key: key);

  final Color onBackground;
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onChanged;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          icon: Icon(
            obsecureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: widget.onBackground.withOpacity(0.6),
          ),
        ),
        labelText: widget.labelText,
      ),
      onChanged: widget.onChanged,
    );
  }
}
