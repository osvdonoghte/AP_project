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

Future<void> signUp(String username, String email, String password) async {
  try {
    // Connect to the server
    final socket = await Socket.connect('10.0.2.2', 12345);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // Send signup data to the server in the format: "SIGNUP||username||email||password"
    socket.write('$username $email $password\n');
    await socket.flush();

    // Listen for the server's response
    socket.listen(
      (data) {
        final response = String.fromCharCodes(data).trim();
        print('Server response: $response');
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
  final TextEditingController emailController = TextEditingController();
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
      final emailError = validateEmail(emailController.text);
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

      userDetails = UserDetails(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
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
              if (!isLoginMode)
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'نام کاربری',
                  ),
                  onChanged: (_) => setState(() => errorMessage = ''),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
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
