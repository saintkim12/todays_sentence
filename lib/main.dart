import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<StatefulWidget> {
  String? sentence;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _onGenerateButtonClicked());
  }

  _onGenerateButtonClicked() async {
    try {
      final res = await http.get(
          Uri.parse('https://korean-advice-open-api.vercel.app/api/advice'));
      if (res.statusCode == 200) {
        Map<String, String> data = jsonDecode(res.body);
        // {
        //   author: "마더 테레사",
        //   authorProfile: "카톨릭 수녀, 자선가",
        //   message: "사랑은 집에서부터 시작됩니다. 먼저 당신의 가족을 사랑하세요."
        // }
        String author = data['author'] ?? '-';
        String authorProfile = data['authorProfile'] ?? '-';
        String message = data['message'] ?? '-';
        setState(() {
          sentence = '$message \n($author, $authorProfile)';
        });
      } else {
        throw Exception('statusCode: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('$e');
      // 'Error occured.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(children: [
          Text(sentence ?? 'Hello World!'),
          OutlinedButton(
              onPressed: () {
                _onGenerateButtonClicked();
              },
              child: const Text('Regenerate'))
        ])),
      ),
    );
  }
}
