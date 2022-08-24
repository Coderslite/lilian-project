import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lilian_project/screens/admin..dart';
import 'package:lilian_project/screens/table_screen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:intl/intl.dart';

class EditUser extends StatefulWidget {
  final String phoneNumber;
  final String docId;
  final String fName;
  final String lName;
  final String gender;
  final String state;
  final String lga;
  final String maritalStatus;
  final String occupation;
  final int date;
  final String email;
  const EditUser(
      {Key? key,
      required this.phoneNumber,
      required this.docId,
      required this.fName,
      required this.lName,
      required this.gender,
      required this.state,
      required this.lga,
      required this.maritalStatus,
      required this.occupation,
      required this.date,
      required this.email})
      : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormBuilderState>();
  String state = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit User"),
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
                SizedBox(
                  child: Text(
                    "Edit " +
                        widget.fName +
                        " " +
                        widget.lName +
                        " Information",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  name: 'fName',
                  initialValue: widget.fName,
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
                  initialValue: widget.lName,
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
                  initialValue: widget.email,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
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
                  name: 'occupation',
                  initialValue: widget.occupation,
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
                  initialValue: widget.maritalStatus,
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
                  initialValue: widget.gender,
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
                // FormBuilderDateTimePicker(
                //   name: 'date',
                //   inputType: InputType.date,
                //   initialDate: myDOB,
                //   format: DateFormat('dd-MM-yyyy'),
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(),
                //   ]),
                //   controller: dateController,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       hintText: "date of birth"),
                // ),
                FormBuilderDropdown(
                  name: 'state',
                  initialValue: widget.state,
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
                FormBuilderTextField(
                  name: 'lga',
                  initialValue: widget.lga,
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
                            handleUpdate();
                          },
                          child: const Text(
                            "Update User",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }

  handleUpdate() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var formData = formKey.currentState!.value;
      // print(formData);
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.docId)
          .update(formData)
          .whenComplete(() => {
                Fluttertoast.showToast(msg: 'User Information Updated')
                    .then((value) => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return TableScreen();
                          })),
                        })
              })
          .catchError((err) => {Fluttertoast.showToast(msg: err)});
    }
  }
}
