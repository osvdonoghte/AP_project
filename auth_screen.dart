import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'home_screen.dart';
import 'user_profile_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoginMode = true;
  String errorMessage = '';
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      'http://localhost:8080', 
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.onError((data) {
      setState(() {
        errorMessage = 'Server error: $data';
      });
    });

    socket.connect();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

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
    if (!isLoginMode && passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'رمز عبور و تکرار آن مطابقت ندارند';
      });
      return;
    }

    final userData = {
      'email': usernameController.text,
      'password': passwordController.text,
    };

    final event = isLoginMode ? 'login' : 'register';
    socket.emit(event, userData);

    socket.on('$event_success', (data) {
      print('$event success: $data');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });

    socket.on('$event_failed', (data) {
      setState(() {
        errorMessage = 'خطا: $data';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;

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
                      isLoginMode ? 'حساب کاربری ندارید؟' : 'حساب کاربری دارید؟',
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
