import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gourmet_search/views/search/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'グルメ検索',
      theme: ThemeData(primarySwatch: Colors.orange), // 飲食店っぽい色
      home: const SearchPage(), // 検索画面を最初に表示
    );
  }
}
