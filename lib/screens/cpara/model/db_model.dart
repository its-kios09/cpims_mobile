// Models for interacting with db
import 'package:cpims_mobile/screens/cpara/model/sub_ovc_child.dart';
import 'package:cpims_mobile/utils/app_form_metadata.dart';

class CPARAChildQuestions {
  String ovc_cpims_id;
  String question_code;
  String answer_id;

  CPARAChildQuestions(
      {this.ovc_cpims_id = "", this.question_code = "", this.answer_id = ""});

  factory CPARAChildQuestions.fromJSON(Map<String, dynamic> json) {
    return CPARAChildQuestions(
        question_code: "${json['questionid']}",
        answer_id: "${json['answer']}",
        ovc_cpims_id: "${json['childID']}");
  }

  Map<String, dynamic> toJSON() {
    return {
      "ovc_cpims_id": ovc_cpims_id,
      "question_code": question_code,
      "answer_id": answer_id
    };
  }
}

class CPARADatabaseQuestions {
  final String question_code;
  final String answer_id;

  const CPARADatabaseQuestions({
    required this.question_code,
    required this.answer_id,
  });

  factory CPARADatabaseQuestions.fromJSON(Map<String, dynamic> json) {
    return CPARADatabaseQuestions(
        question_code: json['questionid'], answer_id: json['answer']);
  }

  Map<String, dynamic> toJSON() {
    return {question_code: answer_id};
  }
}

class CPARADatabase {
  int cpara_form_id;
  String ovc_cpims_id;
  String date_of_event;
  List<CPARADatabaseQuestions> questions;
  List<CPARAChildQuestions> childQuestions;
  AppFormMetaData appFormMetaData;
  List<SubOvcChild> listOfSubOvcs;

  CPARADatabase(
      {
        this.cpara_form_id = 0,
        this.ovc_cpims_id = "",
        this.date_of_event = "",
        this.questions = const [],
        this.childQuestions = const [],
      this.appFormMetaData = const AppFormMetaData(),
        this.listOfSubOvcs = const []
      });
}
