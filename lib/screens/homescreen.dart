import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lilian_project/screens/admin..dart';
import 'package:lilian_project/screens/register.dart';
import 'package:lilian_project/screens/table_screen.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isObscure = false;
  var formKey = GlobalKey<FormBuilderState>();
  // var user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lilian App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login to Panel",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter email address"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'password',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ]),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: isObscure
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "************",
                ),
                obscureText: isObscure,
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CollectionScaleTransition(
                          end: 3.0,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Color(0XFF0072BA),
                              radius: size.width / 20,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: size.width / 30,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.yellow,
                              radius: size.width / 45,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadingText(
                          'Loading...',
                          style: TextStyle(
                            letterSpacing: 3.0,
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    )
                  : Material(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10),
                      child: MaterialButton(
                        onPressed: () {
                          handleLogin();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
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

  handleLogin() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var formData = formKey.currentState!.value;
      // print(formData);
      setState(() {
        isLoading = true;
      });
      FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: formData['email'])
          .get()
          .then((value) => {
                if (value.docs[0]['password'] == formData['password'] &&
                    value.docs[0]['role'] == 'admin')
                  {
                    setState(() {
                      isLoading = false;
                    }),
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return TableScreen();
                    }))
                  }
                else
                  {
                    setState(() {
                      isLoading = false;
                    }),
                    Fluttertoast.showToast(msg: 'Password is not correct')
                  }
              })
          .catchError((error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: error);
      });
      // if (formData['email'] == 'admin@gmail.com') {
      //   Navigator.push(context, MaterialPageRoute(builder: (_) {
      //     return AdminScreen();
      //   }));
      // } else {
      //   Navigator.push(context, MaterialPageRoute(builder: (_) {
      //     return const Register();
      //   }));
      // }
    }
  }
}
