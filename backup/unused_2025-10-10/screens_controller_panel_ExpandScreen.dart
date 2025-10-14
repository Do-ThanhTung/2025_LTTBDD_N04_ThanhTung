// Bản sao lưu của: lib/screens/controller/panel/ExpandScreen.dart
// Nội dung gốc đã được lưu giữ để đảm bảo an toàn
// Compatibility export for mixed-case imports
// ignore_for_file: file_names
export 'package:education/screens/controller/panel/expand_screen.dart';

import 'package:education/constants/icons.dart';
import 'package:education/models/ExpandScreen/translation_screen.dart';
import 'package:education/models/ExpandScreen/GameScreen.dart';
import 'package:education/models/ExpandScreen/StoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandScreen extends StatelessWidget {
  static List<String> items = [
    'Truyện ngắn',
    'Trò chơi',
    'Dịch văn bản',
  ];

  // Danh sách màn hình để điều hướng tới cho mỗi mục
  static List<Widget> screens = [
    const StoryScreen(),
    const GameScreen(),
    const TranslationScreen(),
    // Thêm các màn hình khác ở đây nếu cần
  ];

  const ExpandScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF98A77C),
                    Color(0xFFB6C99B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vừa học vừa chill'
                            '\nCàng học càng fun',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ứng dụng ngay kiến '
                            'vừa học \nvào đọc và phản xạ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(icStu),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Color(
                0xFF88976C,
              ), // Màu của mỗi mục (palette)
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 50,
                top: 50,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    items[index],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            // Điều hướng tới màn hình tương ứng từ danh sách màn hình
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screens[index],
              ),
            );
          },
        );
      },
    );
  }
}
