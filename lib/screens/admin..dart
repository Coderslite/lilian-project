import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lilian_project/screens/edit_user.dart';
import 'package:lilian_project/screens/register.dart';
import 'package:lilian_project/screens/table_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Register();
          }));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('role', isEqualTo: 'user')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("something went wrong"),
                ],
              );
            }
            if (snapshot.data == null ||
                !snapshot.hasData ||
                snapshot.data!.docs.length < 1) {
              return Text("No Data");
            }
            if (snapshot.hasData) {
              var userData = snapshot.data!.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return Column(children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return TableScreen();
                          }));
                        },
                        onLongPress: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return EditUser(
                              phoneNumber: userData[index]['phoneNumber'],
                              docId: userData[index]['docID'],
                              fName: userData[index]['fName'],
                              lName: userData[index]['lName'],
                              gender: userData[index]['gender'],
                              state: userData[index]['state'],
                              lga: userData[index]['lga'],
                              maritalStatus: userData[index]['maritalStatus'],
                              occupation: userData[index]['occupation'],
                              date: userData[index]['time'],
                              email: userData[index]['email'],
                            );
                          }));
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )
                                ]),
                          ),
                          child: ListTile(
                            autofocus: false,
                            title: Text(userData[index]['fName'] +
                                " " +
                                userData[index]['lName']),
                            subtitle: Text(userData[index]['phoneNumber']),
                          ),
                        ),
                      )
                    ]);
                  }));
            }
            return Center(child: const CircularProgressIndicator());
          }),
    );
  }
}
