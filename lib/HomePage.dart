import 'dart:developer';
import 'dart:math';
import 'package:demo/src/utils/shared_pref.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../../constant.dart';
import 'Models/userModel.dart';
import 'Screens/Authentication/SignIn.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  static const int pageSize = 20;
  bool isLoadingMore = false;
  bool hasMoreData = true; // Flag to track if more data is available
  List<User> userList = [];
  int pageIndex = 0;
  List<User> filteredUserList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeHiveData().then((_) => setState(() => filteredUserList = userList.take(pageSize).toList()));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeHiveData() async {
    var box = await Hive.openBox<User>('userBox');
    if (box.isEmpty) {
      await _addDummyData(box);
    }

    setState(() {
      userList = box.values.toList().cast<User>();
      filteredUserList = userList.take(pageSize).toList();
      pageIndex = 1;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUserList = userList.where((user) {
        return user.name.contains(query) ||
            user.phone.contains(query) ||
            user.city.contains(query);
      }).take(pageSize).toList();
      pageIndex = 1;
      hasMoreData = filteredUserList.length < userList.length;
    });
  }

  void _loadMoreData() async {
    if (isLoadingMore || !hasMoreData) return;

    setState(() {
      isLoadingMore = true;
    });

    await Future.delayed(Duration(milliseconds: 700)); // Minimum loader display time

    final int startIndex = pageIndex * pageSize;
    final int endIndex = startIndex + pageSize;

    if (startIndex < userList.length) {
      setState(() {
        filteredUserList.addAll(
          userList.sublist(startIndex, endIndex > userList.length ? userList.length : endIndex),
        );
        pageIndex++;
        isLoadingMore = false;
        if (endIndex >= userList.length) {
          hasMoreData = false; // All data has been loaded
        }
      });
    } else {
      setState(() {
        isLoadingMore = false;
        hasMoreData = false; // No more data to load
      });
    }
  }

  Future<void> _addDummyData(Box<User> box) async {
    Faker faker = Faker();
    Random random = Random();

    for (int i = 0; i < 43; i++) {
      String name = faker.person.name();
      String phone = (random.nextInt(900000000) + 1000000000).toString();
      String city = faker.address.city();
      int rupee = random.nextInt(101);

      bool isMale = random.nextBool();
      int id = random.nextInt(100);

      String imageUrl = isMale
          ? 'https://randomuser.me/api/portraits/men/$id.jpg'
          : 'https://randomuser.me/api/portraits/women/$id.jpg';

      User user = User(name: name, phone: phone, city: city, imageUrl: imageUrl, rupee: rupee);
      await box.add(user);
    }
  }

  void confirmationDialog(BuildContext context) async {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: TextStyleExample(name : 'Privacy',style : textTheme.titleMedium!.copyWith(color: MyColors.black, fontWeight: FontWeight.bold)),
          title: Text("Exit!"),
          content: Text("Are you sure want to exit?",
              style: TextStyle(fontSize: 15)),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              //child: TextStyleExample(name : 'DISAGREE',style : textTheme.labelLarge!),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              // child: TextStyleExample(name : 'AGREE',style : textTheme.labelLarge!.copyWith(color: MyColors.accentDark)),
              child: Text("Sure"),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        confirmationDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'eVital Demo',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 16.0),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  color: kMainColor,
                ),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              CircleAvatar(
                                radius: 60.0,
                                backgroundColor: kMainColor,
                                backgroundImage: AssetImage(
                                  'Images/Pro.png',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Ronak Priyadarshi",
                                    style: kTextStyle.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // Text(
                              //   'Admin',
                              //   style: kTextStyle.copyWith(color: kGreyTextColor),
                              // ),
                            ],
                          )/*.onTap(() {
                          ProfileScreen().launch(context);
                        }),*/
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Version 1.0.0',
                            style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

              ListTile(
                onTap: () {
                  //ProfileScreen().launch(context);
                },
                leading: Icon(
                  Icons.person,
                  color: kGreyTextColor,
                ),
                title: Text(
                  'Profile',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                onTap: () {
                  //LeaderBoard().launch(context);
                },
                leading: Icon(
                  Icons.score,
                  color: kGreyTextColor,
                ),
                title: Text(
                  'Leader Board',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                onTap: () {
                  //PrivacyPolicyPage().launch(context);
                },
                leading: Icon(
                  Icons.privacy_tip,
                  color: kGreyTextColor,
                ),
                title: Text(
                  'Privacy Policy',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
              ),
              ListTile(
                onTap: () {
                  PreferenceManager.instance.setBooleanValue(
                      "Login", false);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                leading: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: kGreyTextColor,
                ),
                title: Text(
                  'Logout',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
              ),

            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 20.0, right: 20, top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: CupertinoSearchTextField(
                    onChanged: _filterUsers,
                    onSubmitted: (value) {},
                    autocorrect: true,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: hasMoreData ? filteredUserList.length + 1 : filteredUserList.length,
                    itemBuilder: (context, index) {
                      if (index == filteredUserList.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final user = filteredUserList[index];
                      final stockStatus = user.rupee > 50 ? "High" : "Low";
                      final stockColor = user.rupee > 50 ? Colors.green : Colors.red;

                      return GestureDetector(
                        onTap: () => _showUpdateRupeeDialog(user, index),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.imageUrl),
                                  radius: 30,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Phone : ${user.phone}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'City  : ${user.city}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Rupee: ${user.rupee}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  stockStatus,
                                  style: TextStyle(
                                    color: stockColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  void _showUpdateRupeeDialog(User user, int index) {
    final TextEditingController rupeeController =
    TextEditingController(text: user.rupee.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Update Rupee",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: rupeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter new rupee value",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                int? newRupee = int.tryParse(rupeeController.text);
                if (newRupee != null) {
                  // Update the user's rupee value in Hive
                  var box = await Hive.openBox<User>('userBox');
                  user.rupee = newRupee;
                  await box.putAt(index, user);

                  // Update the UI
                  setState(() {
                    userList[index].rupee = newRupee;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
}}
