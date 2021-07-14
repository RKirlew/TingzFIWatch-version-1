import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';



void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TingzFiWatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:test(),

          );

  }
}
