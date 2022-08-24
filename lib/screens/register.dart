import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lilian_project/screens/table_screen.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormBuilderState>();
  String state = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register User"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10,
        ),
        child: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register New User",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'fName',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter First Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'lName',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Second Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Address"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'phoneNumber',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.maxLength(11),
                ]),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter phone number"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'occupation',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Occupation"),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderDropdown(
                name: 'maritalStatus',
                items: ['Married', 'Single', 'Prefered not to say']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Choose marital status"),
              ),
              FormBuilderDropdown(
                name: 'gender',
                items: ['Male', 'Female']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "select gender"),
              ),
              FormBuilderDateTimePicker(
                name: 'date',
                inputType: InputType.date,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                controller: dateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "date of birth"),
              ),
              FormBuilderDropdown(
                name: 'state',
                onChanged: (st) {
                  setState(() {
                    state = st.toString();
                  });
                },
                items: [
                  'Abia',
                  'Adamawa',
                  'Akwa Ibom',
                  'Anambra',
                  'Bauchi',
                  'Bayelsa',
                  'Benue',
                  'Borno',
                  'Cross River',
                  'Delta',
                  'Ebonyi',
                  'Edo',
                  'Ekiti',
                  'Enugu',
                  'Gombe',
                  'Imo',
                  'Jigawa',
                  'Kaduna',
                  'Kano',
                  'Kastina',
                  'Kebbi',
                  'Kogi',
                  'Kwara',
                  'Lagos',
                  'Nasarawa',
                  'Niger',
                  'Ondo',
                  'Osun',
                  'Oyo',
                  'Plateau',
                  'Rivers',
                  'Sokoto',
                  'Yobe',
                  'Zamfara',
                  'F.c.t'
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Select state"),
              ),
              const SizedBox(
                height: 10,
              ),
              state == ''
                  ? Container()
                  : FormBuilderTextField(
                      name: 'lga',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Local government origin",
                      ),
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
                          handleRegister();
                        },
                        child: const Text(
                          "Register User",
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

  handleRegister() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var formData = formKey.currentState!.value;
      setState(() {
        isLoading = true;
      });
      FirebaseFirestore.instance
          .collection("users")
          .where('phoneNumber', isEqualTo: formData['phoneNumber'])
          .get()
          .then((value) => {
                print(value.docs[0]),
                setState(() {
                  isLoading = false;
                }),
                Fluttertoast.showToast(msg: 'User Information already exist'),
              })
          .catchError((error) {
        var doc = FirebaseFirestore.instance.collection("users").doc();
        doc
            .set(formData)
            .whenComplete(() => {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(doc.id)
                      .update({
                    'role': 'user',
                    'docID': doc.id,
                    'time': DateTime.now().millisecondsSinceEpoch,
                  }),
                  setState(() {
                    isLoading = false;
                  }),
                  Fluttertoast.showToast(msg: 'Registration Successful')
                      .then((value) => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return TableScreen();
                            })),
                          })
                })
            .catchError((error) => {
                  setState(() {
                    isLoading = false;
                  }),
                  Fluttertoast.showToast(msg: error),
                });
      });
    }
  }
}
