import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:lilian_project/screens/edit_user.dart';
import 'package:intl/intl.dart';
import 'package:lilian_project/screens/register.dart';
import 'package:progress_indicators/progress_indicators.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Register();
          }));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Lilian App"),
      ),
      body: _getBodyWidget(size),
    );
  }

  handleDelete(id) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete()
        .whenComplete(() => {
              Fluttertoast.showToast(msg: 'User Deleted Successfully')
                  .then((value) => {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return TableScreen();
                        })),
                      }),
            })
        .catchError((error) => {
              Fluttertoast.showToast(msg: error),
            });
  }

  Widget _getBodyWidget(Size size) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 100,
        left: 20,
        right: 20,
      ),
      // ignore: sort_child_properties_last
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('role', isEqualTo: 'user')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData) {
              return HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 1500,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: snapshot.data!.docs.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                verticalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.yellow,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.red,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                enablePullToRefresh: true,
                refreshIndicator: const WaterDropHeader(
                  waterDropColor: Colors.yellow,
                ),
                refreshIndicatorHeight: 60,
                onRefresh: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.refreshCompleted();
                },
                enablePullToLoadNewData: true,
                loadIndicator: const ClassicFooter(),
                onLoad: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.loadComplete();
                },
                htdRefreshController: _hdtRefreshController,
              );
            }
            return Column(
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
            );
          }),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Date' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
            100),
        onPressed: () {
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'First Name' +
                (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
            100),
        onPressed: () {
          sortType = sortStatus;
          isAscending = !isAscending;
          // user.sortStatus(isAscending);
          setState(() {});
        },
      ),
      _getTitleItemWidget('Last Name', 120),
      _getTitleItemWidget('Phone Number', 120),
      _getTitleItemWidget('Email', 300),
      _getTitleItemWidget('Gender', 70),
      _getTitleItemWidget('Occupation', 100),
      _getTitleItemWidget('State', 100),
      _getTitleItemWidget('Lga', 100),
      _getTitleItemWidget('Marital Status', 100),
      _getTitleItemWidget('Doc ID', 300),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user')
            .snapshots(),
        builder: (context, dateSnapshot) {
          if (dateSnapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (dateSnapshot.hasData) {
            var dt = DateTime.fromMillisecondsSinceEpoch(
                dateSnapshot.data!.docs[index]['time']);
            var newDate = DateFormat("dd-MM-yyyy").format(dt);
            return Container(
              child: Text(newDate.toString()),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            );
          }
          return const Text("Loading..");
        });
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData) {
            if (snapshot.data!.docs == null ||
                snapshot.data!.size == 0 ||
                snapshot.data!.docs.isEmpty) {
              return Text("no data found");
            }
            var userData = snapshot.data!.docs[index];

            return GestureDetector(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Hi Admin'),
                        content: Text(
                            'which action do you wish to perform on ' +
                                userData['fName'] +
                                " " +
                                userData['lName'] +
                                " profile"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return EditUser(
                                    phoneNumber: userData['phoneNumber'],
                                    docId: userData['docID'],
                                    fName: userData['fName'],
                                    lName: userData['lName'],
                                    gender: userData['gender'],
                                    state: userData['state'],
                                    lga: userData['lga'],
                                    maritalStatus: userData['maritalStatus'],
                                    occupation: userData['occupation'],
                                    date: userData['time'],
                                    email: userData['email'],
                                  );
                                }));
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.black),
                              )),
                          TextButton(
                            onPressed: () {
                              handleDelete(userData['docID']);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      );
                    });
              },
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return EditUser(
                    phoneNumber: userData['phoneNumber'],
                    docId: userData['docID'],
                    fName: userData['fName'],
                    lName: userData['lName'],
                    gender: userData['gender'],
                    state: userData['state'],
                    lga: userData['lga'],
                    maritalStatus: userData['maritalStatus'],
                    occupation: userData['occupation'],
                    date: userData['time'],
                    email: userData['email'],
                  );
                }));
              },
              child: Row(
                children: [
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Icon(
                        //     user.userInfo[index].merchant
                        //         ? Icons.notifications_off
                        //         : Icons.notifications_active,
                        //     color:
                        //         user.userInfo[index].merchant ? Colors.red : Colors.green),
                        Text(userData['fName'])
                      ],
                    ),
                    width: 100,
                    height: 52,
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['lName']),
                    width: 120,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['phoneNumber']),
                    width: 120,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['email']),
                    width: 300,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['gender']),
                    width: 70,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['occupation']),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['state']),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['lga']),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['maritalStatus']),
                    width: 100,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text(userData['docID']),
                    width: 300,
                    height: 52,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            );
          }
          return const Text("Loading ......");
        });
  }
}

class UserInfo {
  String date;
  String merchant;
  String phone;
  String registerDate;
  String terminationDate;

  UserInfo(this.date, this.merchant, this.phone, this.registerDate,
      this.terminationDate);
}
