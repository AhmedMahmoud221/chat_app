import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  bool isLoading = false;
  static String id = 'LoginPage';

  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true ;
        } else if (state is LoginSuccess) {
           Navigator.pushNamed(context, ChatPage.id);
        } else if (state is LoginFailure) {
          showSnackBar(context, 'something went wrong');
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 75),
                  Image.asset('assets/images/scholar.png', height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'pacifico',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 95),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 15),

                  CustomFormTextField(
                    onChanged: (data) => email = data,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 10),

                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) => password = data,
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await loginUser();
                          String? token = await userCredential.user
                              ?.getIdToken();

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('token', token ?? '');
                          await prefs.setString('email', email!);

                          Navigator.pushReplacementNamed(
                            context,
                            ChatPage.id,
                            arguments: email,
                          );
                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'user-not-found') {
                            showSnackBar(context, 'User not found');
                          } else if (ex.code == 'wrong-password') {
                            showSnackBar(context, 'Wrong password');
                          }
                        } catch (ex) {
                          print(ex);
                          showSnackBar(context, 'There was an error');
                        }
                      } else {}
                    },
                    text: 'Log In',
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          '   Register',
                          style: TextStyle(color: Color(0xffC7EDE6)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> loginUser() async {
    var auth = FirebaseAuth.instance;
    return await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
