import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sample_blog_app/nav/homepage.dart';
void main()async {
   const keyApplicationId = 'H4ILLQpog0eVkAHtD8lerFsBEoySvFX9F0FiGTlF';
 const keyClientKey = 'CgYIK6rGYOEif4tenWTLcGGaAeGsXlYbscfoT2hT';
 const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
