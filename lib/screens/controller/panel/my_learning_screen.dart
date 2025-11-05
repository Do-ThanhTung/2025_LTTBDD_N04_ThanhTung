import 'package:flutter/material.dart';
import 'package:education/models/lesson.dart';

class MyLearningScreen extends StatelessWidget {
  const MyLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Learning')),
      body: ListView.builder(
        itemCount: lessonList.length,
        itemBuilder: (context, index) {
          final l = lessonList[index];
          return ListTile(
            leading: Icon(
              l.isCompleted
                  ? Icons.check_circle
                  : Icons.play_circle,
            ),
            title: Text(l.name),
            subtitle: Text(l.duration),
            trailing: l.isPlaying
                ? const Icon(Icons.equalizer)
                : null,
            onTap: () {
              // TODO: mở lesson player / mark completed
            },
          );
        },
      ),
    );
  }
}
