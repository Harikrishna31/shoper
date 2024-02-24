import 'dart:convert';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/productdetails.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup.dart';
import 'cart.dart';
import 'modelclassapi.dart';

void main() {
  runApp(MaterialApp(
    home: Shop3(),
  ));
}

class Shop3 extends StatefulWidget {
  // User? currrentUser = FirebaseAuth.instance.currentUser;

  @override
  State<Shop3> createState() {
    return Screen3();
  }
}

class Screen3 extends State<Shop3> {
  List<ProductRest> searchproduct = [];
  bool isSearch = false;
  TextEditingController controller = TextEditingController();
  final List<String> hello = [
    'assets/hb.jpg',
    'assets/he.jpg',
    'assets/hi.jpg',
    'assets/bi.jpg',
    'assets/hq.jpg'
  ];

  final List<String> userProfiles = [
    'assets/man.png',
    'assets/women.png',
    'assets/Tele.png',
  ];

  List<Widget> getImages() {
    return hello
        .map((e) => ClipRRect(
              child: Image.asset(
                e,
                width: 400,
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(20.1),
            ))
        .toList();
  }

  final PageController contro = PageController();
  int myindex = 0;

  Future<List<ProductRest>> _getproduct() async {
    var url = Uri.parse("https://fakestoreapi.com/products");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<ProductRest> products = data.map<ProductRest>((item) {
          return ProductRest.fromJson(item);
        }).toList();

        return products;
      } else {
        print('API returned an error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage1()));
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.redAccent,
              ))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 2.3,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 0,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person_2_sharp,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(0),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.male,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Men",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                padding: EdgeInsets.all(0),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.female,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Women",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.all(0),
              ),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => login()));
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined
                            
                            ),
                        SizedBox(width: 16),
                        Text(
                          "Logout",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
      body: Container(
          child: Column(children: [
        Container(
          width: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: AnimationSearchBar(
            onChanged: (keyword) {
              setState(() {
                isSearch = keyword.isNotEmpty;
              });
            },
            searchTextEditingController: controller,
            backIcon: Icons.arrow_back_ios_new,
            backIconColor: Colors.white,
            hintText: 'Search here...',
            centerTitleStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 20,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            cursorColor: Colors.lightBlue.shade300,
            duration: const Duration(milliseconds: 500),
            searchFieldHeight: 35,
            searchBarHeight: 50,
            searchBarWidth: MediaQuery.of(context).size.width - 30,
            horizontalPadding: 5,
            verticalPadding: 0,
            searchIconColor: Colors.grey.withOpacity(.7),
            searchFieldDecoration: BoxDecoration(
              color: Colors.blueGrey.shade700,
              border:
                  Border.all(color: Colors.black.withOpacity(.2), width: .6),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://st2.depositphotos.com/3676619/7616/v/600/depositphotos_76164217-stock-illustration-fashion-girl-in-sketch-style.jpg"),
                  fit: BoxFit.cover,
                  alignment: Alignment.center)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(userProfiles[1]),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(userProfiles[0]),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                  radius: 30, backgroundImage: AssetImage(userProfiles[2])),
            )
          ]),
        ),
        CarouselSlider(
          items: getImages(),
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            viewportFraction: 1.5,
          ),
        ),
        Expanded(
          child: Isproducts(),
        ),
      ])),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myindex = index;
          });

          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Shop3()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage1()),
              );
              break;
          }
        },
        currentIndex: myindex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
  Widget Isproducts() {
    return FutureBuilder<List<ProductRest>>(
      future: _getproduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<ProductRest> filteredProducts = snapshot.data ?? [];
        if (isSearch && controller.text.isNotEmpty) {
          filteredProducts = filteredProducts
              .where((product) => product.title
                  .toLowerCase()
                  .contains(controller.text.toLowerCase()))
              .toList();
        }

        return GridView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            var product = filteredProducts[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                          productImage: product.image,
                          productId: product.id,
                          productName: product.title,
                          productPrice: product.price)),
                );
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_outline_rounded),
                        )),
                    Image.network(
                      product.image,
                      width: 100,
                      height: 80,
                    ),
                    SizedBox(height: 6),
                    Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Price: \$${product.price.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        );
      },
    );
  }
}
