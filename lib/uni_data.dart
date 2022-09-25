// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UniData extends StatefulWidget {
  const UniData({Key? key}) : super(key: key);

  @override
  State<UniData> createState() => _UniDataState();
}

class _UniDataState extends State<UniData> {
  final countryController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var responseBody;
  bool loading = true;
  List countries = [];

  @override
  initState() {
    super.initState();
    getPopulationData(countryController.text.toString());
  }

  getPopulationData(String userData) async {
    setState(() {
      loading = true;
    });
    print('api calling...............');
    var api = "http://universities.hipolabs.com/search?country=$userData";
    var response = await http.get(
      Uri.parse(api),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        responseBody = jsonDecode(response.body);
        debugPrint('$responseBody');
        countries = responseBody.toList();
        log('countries: $countries');
      });

      debugPrint('Data:  $responseBody');
    } else {
      print("Server error please try again later");
    }
    setState(() {
      loading = false;
    });
    print('Api ok....');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.black87,
      //   child: Icon(
      //     Icons.question_mark,
      //     color: Colors.white,
      //   ),
      //   onPressed: null,
      // ),
      // drawer: UserAccountsDrawerHeader(
      //   accountEmail: Text('hamadhassan8@gmail.com'),
      //   accountName: Text('Hamad Hassan'),
      //   currentAccountPicture: Image.asset('assets/images/profile.jpg'),
      //   //currentAccountPictureSize: Size.square(80.0),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     color: Colors.amber,
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 10, 175),
        //centerTitle: true,
        title: const Text('University Data'),
        actions: [
          //Icon(Icons.favorite_outline),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        height: mediaQuery.height,
        width: mediaQuery.width,

        color: Colors.white10,
        // padding: EdgeInsets.symmetric(
        //   vertical: 20,
        //   horizontal: 20,
        // ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 10,
                  right: 10,
                ),
                color: Color.fromARGB(255, 219, 217, 217),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaQuery.width * 0.75,
                      height: mediaQuery.height * 0.1,
                      child: TextFormField(
                        controller: countryController,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black54),
                          //hintStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),
                          ),
                          //suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        getPopulationData(countryController.text.toString());
                      },
                      child: Container(
                        width: mediaQuery.width * 0.15,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              loading == true
                  ? CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : Container(
                      width: mediaQuery.width,
                      height: mediaQuery.height * 0.71,
                      //color: Color.fromARGB(255, 157, 157, 28),
                      color: Colors.white,
                      //color: Colors.white,
                      child: ListView.builder(
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 7,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black87,
                                  radius: 20,
                                  child: Text(
                                    '${countries[index]["alpha_two_code"]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${countries[index]["name"]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                    '${countries[index]["state-province"]}'),
                                trailing: Icon(
                                  Icons.apartment,
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
