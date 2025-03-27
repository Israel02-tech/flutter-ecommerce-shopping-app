import 'dart:io';
import 'package:ecommerce_shopping_app/services/database.dart';
import 'package:ecommerce_shopping_app/widget/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Initialize ImagePicker for selecting images
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  bool isLoading = false;

  // Function to pick an image from the gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  // Function to upload the selected image and product details
  uploadItem() async {
    if (selectedImage != null && namecontroller.text != "") {
      setState(() {
        isLoading = true;
      });
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      String firstletter = namecontroller.text.substring(0, 1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "Name": namecontroller.text,
        "Image": downloadUrl,
        "SearchKey": firstletter,
        "UpdatedName": namecontroller.text.toUpperCase(),
        "Price": pricecontroller.text,
        "Product Detail": detailcontroller.text,
      };
      await DatabaseMethods().addProduct(addProduct, value!).then(
        (value) async {
          await DatabaseMethods().addAllProducts(addProduct);
          setState(() {
            isLoading = false;
          });
          selectedImage = null;
          namecontroller.text = "";
          pricecontroller.text = "";
          detailcontroller.text = "";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color(0xfff2f2f2),
              content: Text("Product Successfully Uploaded",
                  style: TextStyle(fontSize: 20, color: Colors.black))));
        },
      );
    }
  }

  String? value;

  // List of categories for the dropdown menu
  final List<String> categoryitem = [
    "Laptops",
    "Smartphones",
    "Tablets",
    "Televisions",
    "Cameras",
    "Headphones",
    "Smartwatches",
    "Men's Clothing",
    "Women's Clothing",
    "Kids' Clothing",
    "Shoes",
    "Accessories",
    "Furniture",
    "Kitchen Appliances",
    "Home Decor",
    "Bedding",
    "Lighting",
    "Skincare",
    "Haircare",
    "Makeup",
    "Supplements",
    "Personal Care",
    "Fitness Equipment",
    "Outdoor Gear",
    "Sports Apparel",
    "Camping Equipment",
    "Action Figures",
    "Board Games",
    "Educational Toys",
    "Puzzles",
    "Fiction",
    "Non-Fiction",
    "Children's Books",
    "Educational Books",
    "Car Accessories",
    "Motorcycle Accessories",
    "Tools & Equipment",
    "Fresh Produce",
    "Snacks",
    "Beverages",
    "Household Supplies",
    "Stationery",
    "Office Furniture",
    "Printers & Scanners",
    "Audio Equipment", // Added category for microphones and speakers
    "Health & Wellness", // Added category for steroids
    "Music & Sound", // Additional category for microphones and speakers
    "Admin Default Images"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Add Product",
          style: AppWidget.semiBoldTextStyle(),
          textAlign: TextAlign.center,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin:
                EdgeInsets.only(left: 10.0, top: 20, right: 10.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload the Product Image",
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                        image: selectedImage != null
                            ? DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: selectedImage == null
                          ? Icon(Icons.add_a_photo_rounded)
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Name",
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      hintText: "Product Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Price",
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: pricecontroller,
                    decoration: InputDecoration(
                      hintText: "Product Price",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Details",
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: 6,
                    controller: detailcontroller,
                    decoration: InputDecoration(
                      hintText: "Product Details",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Product Category",
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width /
                      0.8, // Adjust width here
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: categoryitem
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: AppWidget.lightTextStyle(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        this.value = value;
                      }),
                      dropdownColor: Colors.white,
                      hint: Text('Select Category'),
                      iconSize: 35,
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.black,
                      ),
                      value: value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      uploadItem();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Product",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
