import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shopping_app/pages/product_detail.dart';
import 'package:ecommerce_shopping_app/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import '../services/database.dart';
import '../widget/category_tile.dart';
import '../widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isLoading = true; // Added a loading state variable
  bool search =
      false; // A bool variable for the search bool, initially set to be false, when no search is been done

  List categories = [
    "images/headphone2.png",
    "images/Laptop3.jpg",
    "images/TV.jpg",
    "images/Watch4.jpg",
  ];

  List Categoryname = ["Headphones", "Laptops", "Televisions", "Smartwatches"];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["UpdatedName"].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  getthesharedpref() async {
    try {
      name = await SharedPreferenceHelper().getUserName();
      image = await SharedPreferenceHelper().getUserImage();
    } catch (e) {
      print('Error getting shared preferences: $e');
    }
    setState(() {});
  }

  Future<void> ontheload() async {
    try {
      Map<String, dynamic> userData = await fetchUserData();
      await SharedPreferenceHelper().saveUserName(userData['Name']);
      await SharedPreferenceHelper().saveUserImage(userData['Image']);
      await getthesharedpref();
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
    ontheload();
  }

  // Function to pick an image from the gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  // Function to upload the selected image and product details
  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : image == null
              ? Center(
                  child: Text(
                    'Error loading user data. Please restart the app.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 55.0, left: 20.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hey, ${name!}",
                                  style: AppWidget.boldTextFeildStyle(),
                                ),
                                Text(
                                  "Good Morning",
                                  style: AppWidget.lightTextStyle(),
                                ),
                              ],
                            ),
                            selectedImage != null
                                ? GestureDetector(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        selectedImage!,
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: getImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        image!,
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          // margin: const EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: searchcontroller,
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Products",
                              hintStyle: AppWidget.hintTextStyle(),
                              prefixIcon: search
                                  ? GestureDetector(
                                      onTap: () {
                                        search = false;
                                        tempSearchStore = [];
                                        queryResultSet = [];
                                        searchcontroller.text = "";
                                        setState(() {});
                                      },
                                      child: Icon(Icons.close))
                                  : Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        search
                            ? ListView(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                primary: false,
                                shrinkWrap: true,
                                children: tempSearchStore.map((element) {
                                  return buildResultCard(element);
                                }).toList(),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Categories",
                                          style: AppWidget.semiBoldTextStyle(),
                                        ),
                                        Text(
                                          "see all",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xFFfd6f3e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.only(right: 15.0),
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFD6F3E),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "All",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 130,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: categories.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return CategoryTile(
                                                image: categories[index],
                                                name: Categoryname[index],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Text(
                                        "All Products",
                                        style: AppWidget.semiBoldTextStyle(),
                                      ),
                                      Spacer(),
                                      Text(
                                        "see all",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xFFfd6f3e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 220,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        productCard("images/headphone2.png",
                                            "Headphone", "\$100"),
                                        productCard("images/Watch3.jpg",
                                            "Wrist watch", "\$2500"),
                                        productCard("images/watch2.jpg",
                                            "Apple watch", "\$5000"),
                                        productCard("images/laptop2.png",
                                            "Laptop", "\$85000"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    image: data["Image"],
                    name: data["Name"],
                    detail: data["Product Detail"],
                    price: data["Price"])));
      },
      child: Card(
        shadowColor: Color.fromARGB(255, 203, 224, 233),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 85,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data["Image"],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(data["Name"], style: AppWidget.semiBoldTextStyle()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget productCard(String imagePath, String name, String price) {
  return Container(
    margin: EdgeInsets.only(right: 20.0),
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      children: [
        Image.asset(
          imagePath,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
        Text(
          name,
          style: AppWidget.semiBoldTextStyle(),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              price,
              style: TextStyle(
                color: Color(0xFFfd6f3e),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 40),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xFFfd6f3e),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
