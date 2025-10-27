import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 75,),
                Image.asset('assets/images/scholar.png',
                height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                SizedBox(height: 95,),
                Row(
                  children: [
                    Text(
                      'Register', 
                      style: TextStyle(
                        fontSize: 18, 
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
            
                SizedBox(
                  height: 15,
                ),
            
                CustomFormTextField(
                  onChanged: (data){
                    email = data;
                  },
                  hintText: 'Email',
                ),
            
                SizedBox(
                  height: 10,
                ),
            
                CustomFormTextField(
                  onChanged: (data){
                    password = data;
                  },
                  hintText: 'Password',
                ),
            
                SizedBox(
                  height: 30,
                ),
            
                CustomButton(
                  onTap: () async 
                  {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                    try {
                      UserCredential user = await registerUser();
                    
                    if (user.additionalUserInfo != null && user.additionalUserInfo!.isNewUser) {   // ✅ لو الحساب جديد فعلاً (أول مرة يسجل)
                      showSnackBar(context, 'user registered successfully');
                    }
                    } on FirebaseAuthException catch (ex) {
                      if (ex.code == 'weak-password') {
                        showSnackBar(context, 'weak password');
                      } else if (ex.code == 'email-already-in-use') {
                        showSnackBar(context, 'email is already registered');
                      }
                    } catch (ex) {
                      showSnackBar(context, 'there was an error');
                    }
                    isLoading = false;
                    setState(() {});
                    }
                  },
            
                  text: 'Sign Up'),
            
                SizedBox(
                  height: 10,
                ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already have an account  ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        '   Sign In',
                        style: TextStyle(
                          color: Color(0xffC7EDE6),
                        ),
                      ),
                    ),        
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> registerUser() async {
     var auth = FirebaseAuth.instance;
                    UserCredential user = await auth.createUserWithEmailAndPassword(
    email: email!, 
    password: password!);
    return user;
  }
}