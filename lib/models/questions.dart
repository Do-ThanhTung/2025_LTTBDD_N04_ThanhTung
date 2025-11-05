/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

Questions questionsFromJson(String str) => Questions.fromJson(json.decode(str));

String questionsToJson(Questions data) => json.encode(data.toJson());

class Questions {
    Questions({
        required this.question,
        required this.answers,
        required this.correctAnswerIndex,
    });

    String question;
    List<String> answers;
    int correctAnswerIndex;

    factory Questions.fromJson(Map<dynamic, dynamic> json) => Questions(
        question: json["question"],
        answers: List<String>.from(json["answers"].map((x) => x)),
        correctAnswerIndex: json["correctAnswerIndex"],
    );

    Map<dynamic, dynamic> toJson() => {
        "question": question,
        "answers": List<dynamic>.from(answers.map((x) => x)),
        "correctAnswerIndex": correctAnswerIndex,
    };
}
