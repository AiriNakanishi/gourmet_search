import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gourmet_search/constants/app_color.dart';
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
      title: 'kawaii Gourmet Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: AppColor.brand.secondary, // 優しいピンク
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          foregroundColor: AppColor.text.appBarTitle,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.text.appBarTitle,
          ),
        ),
      ), //食店っぽい色
      home: const SearchPage(), // 検索画面を最初に表示
    );
  }
}
