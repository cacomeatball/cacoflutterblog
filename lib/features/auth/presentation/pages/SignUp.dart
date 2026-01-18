import 'package:caco_flutter_blog/core/theme/app_palette.dart';
import 'package:caco_flutter_blog/features/auth/presentation/pages/Login.dart';
import 'package:caco_flutter_blog/features/auth/presentation/widgets/auth_button.dart';
import 'package:caco_flutter_blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const Login()
  );
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 30),
              AuthField(
                hintText: 'Username', 
                controller: nameController),
              const SizedBox(height: 15),
              AuthField(
                hintText: 'Email', 
                controller: emailController),
              const SizedBox(height: 15),
              AuthField(
                hintText: 'Password', 
                controller: passwordController,
                isObscureText: true,),
              const SizedBox(height: 20),
              const AuthButton(
                buttonText: 'Create Account',
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    SignUp.route()
                  );
                },
                child: RichText(
                  text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: AppPalette.primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                      // Add gesture recognizer if needed for navigation
                    )
                  ]
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}