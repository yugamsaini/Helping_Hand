import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/widgets/my_button.dart';
import 'package:helping_hand/widgets/my_textField.dart';

class ForgetPasswordPageOrg extends StatefulWidget {
  const ForgetPasswordPageOrg({super.key});

  @override
  State<ForgetPasswordPageOrg> createState() => _ForgetPasswordPageOrgState();
}

class _ForgetPasswordPageOrgState extends State<ForgetPasswordPageOrg> {
  final emailController = TextEditingController();

  Future passwordReset() async{
    try{
      QuerySnapshot query = await FirebaseFirestore.instance.collection('organisations').where('email',isEqualTo:emailController.text).get();
      if (query.docs.isEmpty){
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (context){
          return const AlertDialog(
            content: Text('NO USER WITH GIVEN EMAIL'),
          );
        });
      }
      else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (context){
          return const AlertDialog(
            content: Text('Password change email sent! Please check your email'),
          );
        });
      }
    } on FirebaseAuthException catch (e){
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context){
        String res = e.code.toString();
        if(res == 'channel-error')res = 'Enter email';
        return AlertDialog(
          content: Text(res),
        );
      });
    }    
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, size: 20,)
        ), 
        centerTitle: true,
        title: const Text(
            'Forget Password',
            style: TextStyle(
                color: Color(0xFF1D1517),
                fontSize: 25,
                // fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
            ),
        ),
        shadowColor: Colors.white, 
        backgroundColor: Colors.white, 
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.04,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Enter your email and we will send you a password change link',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(height: height*0.02,),
              MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
              SizedBox(height: height*0.03,),
              MyButton(onTap: passwordReset, text: 'Reset Password'),
            ],
          ),
        ),
      ),
    );
  }
}