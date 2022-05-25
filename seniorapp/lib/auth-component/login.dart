import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/home.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordhide = true;
  bool _isEN = true;

  var allSnackbar = const SnackBar(
    content: Text('Please fill in both Email and Password'),
  );

  var emailSnack = const SnackBar(
    content: Text('Please fill in your Email'),
  );

  var passwordSnack = const SnackBar(
    content: Text('Please fill in your Password'),
  );

  Future signin() async {
    try {
      if (_emailController.text.isNotEmpty &
          _passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else if (_emailController.text.isNotEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(passwordSnack);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(emailSnack);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(allSnackbar);
      }
    } catch (error) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error Authentication'),
            content: const Text(
                "The Email and Password are invalid. Please refill your Email and Password"),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _passwordController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              IconButton(
                  icon: _isEN
                      ? SvgPicture.asset(
                          'icons/flags/svg/th.svg',
                          package: 'country_icons',
                        )
                      : SvgPicture.asset(
                          'icons/flags/svg/us.svg',
                          package: 'country_icons',
                        ),
                  onPressed: () {
                    setState(() {
                      if (context.locale.languageCode == 'en') {
                        context.setLocale(const Locale('th', 'TH'));
                        _isEN = false;
                      } else {
                        context.setLocale(const Locale('en', 'US'));
                        _isEN = true;
                      }
                    });
                  }),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/mahidol_logo.png"),
                  ),
                ),
                height: h / 3.25,
                width: w / 1.5,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Email text insertion
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// Password text insertion
              TextField(
                controller: _passwordController,
                obscureText: _passwordhide,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordhide
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordhide = !_passwordhide;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () => signin(),
                child: const Text("Log In"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w / 1.1, h / 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('app.login_description').tr(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) {
                            return const Register();
                          }),
                        ),
                      );
                    },
                    child: Text(
                      'app.signup_textbutton'.tr(),
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
