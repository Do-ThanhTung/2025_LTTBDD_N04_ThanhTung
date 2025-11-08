import 'package:education/core/constants/icons.dart';
import 'package:education/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_screen.dart';
import 'story_screen.dart';
import 'translation_screen.dart';

class ExpandScreen extends StatelessWidget {
  static List<String> items = [
    // These will be replaced at build time with localized labels
    'story_short',
    'game',
    'translation',
  ];

  // Danh sách màn hình để điều hướng tới cho mỗi mục
  static List<Widget> screens = [
    const StoryScreen(),
    const GameScreen(),
    const TranslationScreen(),
    // Thêm các màn hình khác ở đây nếu cần
  ];

  const ExpandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(children: [
          Container(
            padding: const EdgeInsets.only(
                top: 50, left: 20, right: 20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .primary,
                  Theme.of(context)
                      .colorScheme
                      .primary
                      .withAlpha((0.7 * 255).round()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.t(
                            context,
                            'expand_header_title',
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.t(
                            context,
                            'expand_header_subtitle',
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const Image(
                        image: AssetImage(icStu)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildListView(),
          ),
        ]),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((0.8 * 255).round()),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 50,
                  top: 50,
                  left: 20,
                  right: 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.t(
                      context,
                      items[index],
                    ),
                    style: const TextStyle(
                        color: Colors.white),
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
