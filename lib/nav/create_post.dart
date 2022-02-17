import 'package:flutter/material.dart';

import '../database.dart';

class Write extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  final description = TextEditingController();

  _WriteState();

  bool _flag = true;
  bool _isLoading = false;
  DatabaseServices databaseServices = DatabaseServices();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   title: Text(
      //   '',
      //     style: GoogleFonts.mulish(fontSize: 15),
      //   ),
      // ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: formKey,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            controller: description,
                            decoration: InputDecoration(
                              labelText: 'write',
                              labelStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 380,
                        right: 0,
                        left: 00,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _flag ? Colors.blue : Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                await databaseServices
                                    .addPost(description.text);
                              } else {
                                setState(() => _flag = !_flag);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: Text(
                              'Submit',
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
