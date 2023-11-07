import 'package:cpims_mobile/Models/form_1_model.dart';
import 'package:cpims_mobile/screens/cpara/cpara_util.dart';
import 'package:cpims_mobile/screens/cpara/model/cpara_model.dart';
import 'package:cpims_mobile/screens/cpara/model/detail_model.dart';
import 'package:cpims_mobile/screens/cpara/model/health_model.dart';
import 'package:cpims_mobile/screens/cpara/model/ovc_model.dart';
import 'package:cpims_mobile/screens/cpara/model/safe_model.dart';
import 'package:cpims_mobile/screens/cpara/model/schooled_model.dart';
import 'package:cpims_mobile/screens/cpara/model/stable_model.dart';
import 'package:flutter/foundation.dart';
import '../../../Models/case_load_model.dart';
import '../widgets/ovc_sub_population_form.dart';

class CparaProvider extends ChangeNotifier {
  CparaModel? cparaModel;
  DetailModel? detailModel;
  HealthModel? healthModel = HealthModel();
  StableModel? stableModel;
  SafeModel? safeModel;
  SchooledModel? schooledModel;
  CaseLoadModel? caseLoadModel;
  List<CaseLoadModel> children = [];
  CparaOvcSubPopulation? cparaOvcSubPopulation;


  // Calculate schooled benchmark
  int schooledBenchmark() {
    int schooledBenchmark = 0;

    if (schooledModel?.question1 == "Yes" &&
            schooledModel?.question2 == "Yes" &&
            schooledModel?.question3 == "Yes" &&
            schooledModel?.question4 == "Yes" ||
        schooledModel?.question4 == "N/A") {
      schooledBenchmark = 1;
    } else {
      schooledBenchmark = 0;
    }
    return schooledBenchmark;
  }

  // Calculate healthy benchmark
  int healthyBenchmark() {
    int finalScore = 0;
    int benchmark1 = 0;
    int benchmark2 = 0;
    int benchmark3 = 0;
    int benchmark4 = 0;

    List<String> firstListOfQuestions = [];
    List<String> secondListOfQuestions = [];
    List<String> thirdListOfQuestions = [];

    // enos implementation to avoid early initialization
    for (HealthChild child in healthModel?.childrenQuestions ?? []) {
      // childQuestions.add(child.question1 ?? "No");
      firstListOfQuestions.add(child.question1);
      secondListOfQuestions.add(child.question2);
      thirdListOfQuestions.add(child.question3);
    }

// Health BenchMark 1 result
    if (healthModel?.question1 == "Yes" &&
        (healthModel?.question2 == "Yes" || healthModel?.question2 == "N/A") &&
        (healthModel?.question3 == "Yes" || healthModel?.question3 == "N/A") &&
        healthModel?.question4 == "Yes" &&
        (healthModel?.question5 == "Yes" || healthModel?.question5 == "N/A")) {
      benchmark1 = 1;
      print("Benchmark 1: $benchmark1");
    } else {
      benchmark1 = 0;
      print("Benchmark 1 1: $benchmark1");
    }

// Health BenchMark 2 result
    if (healthModel?.question6 == "Yes" &&
        (healthModel?.question7 == "Yes" || healthModel?.question7 == "N/A") &&
        healthModel?.question8 == "Yes" &&
        healthModel?.question9 == "Yes" &&
        (healthModel?.question10 == "Yes" ||
            healthModel?.question10 == "N/A") &&
        healthModel?.question11 == "Yes" &&
        healthModel?.question12 == "Yes" &&
        (healthModel?.question13 == "Yes" ||
            healthModel?.question13 == "N/A") &&
        healthModel?.question14 == "Yes") {
      benchmark2 = 1;
      print("Benchmark 2: $benchmark2");
    } else {
      benchmark2 = 0;
      print("Benchmark 2 2: $benchmark2");
    }

// Health BenchMark 3 result
    debugPrint("#######################################");
    debugPrint("HEALTHY BENCHMARK 3:");
    debugPrint("#######################################");
    // If there are children
    if (healthModel?.childrenQuestions != null &&
        healthModel!.childrenQuestions!.isNotEmpty) {
      debugPrint("The list of children is not empty");
      debugPrint(healthModel!.childrenQuestions.toString());
      // Are the answers of all children yes
      if (overallChildrenBenchmark(childrenOptions: firstListOfQuestions)
                  .toLowerCase() ==
              "yes" &&
          overallChildrenBenchmark(childrenOptions: secondListOfQuestions)
                  .toLowerCase() ==
              "yes" &&
          overallChildrenBenchmark(childrenOptions: thirdListOfQuestions)
                  .toLowerCase() ==
              "yes") {
        // Benchmark is 1
        benchmark3 = 1;
        print("Benchmark 3: $benchmark3");
      }
      // Else benchmark is 0
      else {
        debugPrint("The list of children is not empty and some are not yes");
        debugPrint(healthModel!.childrenQuestions.toString());
        benchmark3 = 0;
        print("Benchmark 3 3: $benchmark3");
      }
    }
    // Else if there are no children
    else {
      if (healthModel?.childrenQuestions == null) {
        debugPrint("The list is null");
      } else {
        debugPrint("The list of children is empty");
      }
      // Benchmark value is one
      benchmark3 = 1;
      print("Benchmark 3 3: $benchmark3");
    }

    // Health BenchMark 1 result
    if (healthModel?.question15 == "Yes" &&
        healthModel?.question16 == "Yes" &&
        (healthModel?.question17 == "N/A" ||
            healthModel?.question17 == "Yes") &&
        healthModel?.question18 == "Yes") {
      benchmark4 = 1;
      print("Benchmark 4: $benchmark4");
    } else {
      benchmark4 = 0;
      print("Benchmark 4 4: $benchmark4");
    }

    finalScore = benchmark1 + benchmark2 + benchmark3 + benchmark4;
    if (finalScore == 4) {
      finalScore = 4;
    } else if (finalScore == 3) {
      finalScore = 3;
    } else if (finalScore == 2) {
      finalScore = 2;
    } else if (finalScore == 1) {
      finalScore = 1;
    } else if (finalScore == 0) {
      finalScore = 0;
    }
    return finalScore;
  }

// Calculate stable benchmark
  int stableBenchMark() {
    int stableBenchmark = 0;
    if ((stableModel?.question1 == "Yes" || stableModel?.question1 == "N/A") &&
        (stableModel?.question2 == "Yes" || stableModel?.question2 == "N/A") &&
        (stableModel?.question3 == "Yes")) {
      stableBenchmark = 1;
    } else {
      stableBenchmark = 0;
    }
    return stableBenchmark;
  }

// Calculate safe benchmark
  int safeBenchMark() {
    int schooledBenchmark = 44;
    int benchmark1 = 0;
    int benchmark2 = 0;
    int benchmark3 = 0;

    List<String> childQuestions = [];

    for (SafeChild child in safeModel?.childrenQuestions ?? []) {
      childQuestions.add(child.question1 ?? "No");
    }

    // bool isAllChildrenYes = overallChildrenBenchmark(childrenOptions: childQuestions).toLowerCase() == "yes";

    // if (safeModel?.overallQuestion1 == "No" ||
    //     safeModel?.question1 == "Yes" &&
    //         safeModel?.question2 == "Yes" &&
    //         // safeModel?.question3 == "Yes" &&
    //         safeModel?.question4 == "Yes" &&
    //         safeModel?.question5 == "Yes" &&
    //         overallChildrenBenchmark(childrenOptions: childQuestions)
    //                 .toLowerCase() ==
    //             "yes") {
    //   benchmark1 = 1;
    // } else {
    //   benchmark1 = 0;
    // }

    // Benchmark 1: 1 if 6.4 and 6.5 are yes
    if (safeModel?.question3 == "Yes" && safeModel?.question4 == "Yes") {
      debugPrint("Safe model question 3 is ${safeModel?.question3}");
      debugPrint("Safe has a benchmark of 1");
      debugPrint(safeModel.toString());
      benchmark1 = 1;
    } else {
      debugPrint(safeModel.toString());
      debugPrint("Safe has a benchmark of 0");
      benchmark1 = 0;
    }

// Safe Benchmark 2 result
    if (safeModel?.question5 == "Yes" && safeModel?.question6 == "Yes") {
      debugPrint("Safe benchmark 2 is 1");
      benchmark2 = 1;
    } else {
      debugPrint("Safe benchmark 2 is 0");
      benchmark2 = 0;
    }

// Safe Benchmark 3 result
    if (safeModel?.question7 == "Yes") {
      benchmark3 = 1;
    } else {
      benchmark3 = 0;
    }

    schooledBenchmark = benchmark1 + benchmark2 + benchmark3;
    if (schooledBenchmark == 3) {
      schooledBenchmark = 3;
    } else if (schooledBenchmark == 2) {
      schooledBenchmark = 2;
    } else if (schooledBenchmark == 1) {
      schooledBenchmark = 1;
    } else if (schooledBenchmark == 0) {
      schooledBenchmark = 0;
    }
    return schooledBenchmark;
  }

// Calculate final benchmark
  int finalScore() {
    int finalBenchmarkScore = schooledBenchmark() +
        healthyBenchmark() +
        stableBenchMark() +
        safeBenchMark();

    return finalBenchmarkScore;
  }

// update cpara model
  void updateCparaModel(CparaModel cparaModel) {
    this.cparaModel = cparaModel;
    notifyListeners();
  }

  // update detail model
  void updateDetailModel(DetailModel detailModel) {
    this.detailModel = detailModel;
    notifyListeners();
  }

  // update health model
  void updateHealthModel(HealthModel healthModel) {
    this.healthModel = healthModel;
    notifyListeners();
  }

  // update stable model
  void updateStableModel(StableModel stableModel) {
    this.stableModel = stableModel;
    notifyListeners();
  }

  // update safe model
  void updateSafeModel(SafeModel safe) {
    safeModel = safe;
    notifyListeners();
  }

  // update safe model
  void updateCparaOvcModel(CparaOvcSubPopulation cparaOvcSubPopulation) {
    this.cparaOvcSubPopulation = cparaOvcSubPopulation;
    notifyListeners();
  }

  // initialize cpara ovc questions
  void updateCparaOvcQuestions() {
    List<CparaOvcChild> cparaOvcChildren = [];
    List<CparaOvcChild> cparaOvcChildrenExisting =
        cparaOvcSubPopulation?.childrenQuestions ?? [];
    // List<CaseLoadModel> models = children;
    if (cparaOvcChildrenExisting.isEmpty) {
      for (CaseLoadModel model in children) {
        cparaOvcChildren.add(
          CparaOvcChild(
            ovcId: model.cpimsId ?? "",
            question1: "Orphans (double or Child headed)",
            question2: "At Risk Adolescent Girls andYoung Women (AGYW)?",
            answer1: false,
            answer2: false,
            name: "${model.ovcFirstName} ${model.ovcSurname}",
          ),
        );
      }
      CparaOvcSubPopulation current =
          CparaOvcSubPopulation(childrenQuestions: cparaOvcChildren);
      cparaOvcSubPopulation = current;
    }
    notifyListeners();
  }

  // update schooled model
  void updateSchooledModel(SchooledModel schooledModel) {
    this.schooledModel = schooledModel;
    notifyListeners();
  }

  void updateCaseLoadModel(CaseLoadModel caseLoadModel) {
    this.caseLoadModel = caseLoadModel;
    notifyListeners();
  }

  void updateChildren(List<CaseLoadModel> allChildren) {
    children = allChildren
        .where((element) =>
            element.caregiverNames == caseLoadModel?.caregiverNames)
        .toList();
    notifyListeners();

    // Initialize health children in here
    healthModel ??= HealthModel();
    healthModel!.childrenQuestions = [];

    for (CaseLoadModel model in children) {
      DateTime birthDate = DateTime.parse(model.dateOfBirth!);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      if (age >= 10 && age <= 17) {
        healthModel!.childrenQuestions!.add(HealthChild(
            id: "${model.cpimsId}",
            question1: "",
            question2: "",
            question3: "",
            name: "${model.ovcFirstName} ${model.ovcSurname}"));
      }
    }
    notifyListeners();
  }

  void clearCparaProvider() {
    cparaModel = null;
    detailModel = null;
    healthModel = null;
    stableModel = null;
    safeModel = null;
    schooledModel = null;
    cparaOvcSubPopulation = null;
    notifyListeners();
  }
}
