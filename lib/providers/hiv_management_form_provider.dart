import 'package:cpims_mobile/Models/case_load_model.dart';
import 'package:cpims_mobile/providers/db_provider.dart';
import 'package:cpims_mobile/screens/forms/hiv_management/models/hiv_management_form_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';

class HIVManagementFormProvider extends ChangeNotifier {
  ARTTherapyHIVFormModel _artTherapyFormModel = ARTTherapyHIVFormModel();

  ARTTherapyHIVFormModel get hIVManagementFormModel => _artTherapyFormModel;

  HIVVisitationFormModel _hivVisitationFormModel = HIVVisitationFormModel();

  HIVVisitationFormModel get hIVVisitationFormModel => _hivVisitationFormModel;

  final CaseLoadModel _caseLoadModel = CaseLoadModel();
  CaseLoadModel get caseLoadModel => _caseLoadModel;

  // update artTherapy Info Model
  void updateARTTheraphyHIVModel(ARTTherapyHIVFormModel formModel) {
    _artTherapyFormModel = formModel;
    notifyListeners();
    if (kDebugMode) {
      print(_artTherapyFormModel.toJson());
    }
  }

  void updateHIVVisitationModel(HIVVisitationFormModel formModel) {
    _hivVisitationFormModel = formModel;
    notifyListeners();
    if (kDebugMode) {
      print(_hivVisitationFormModel.toJson());
    }
  }

  // clear form data
  void clearForms() {
    _artTherapyFormModel = ARTTherapyHIVFormModel();
    _hivVisitationFormModel = HIVVisitationFormModel();
    notifyListeners();
  }

  // submit form
  Future<void> submitHIVManagementForm(String? cpimsID,uuid,startTimeInterview,formType, {required BuildContext context}) async {
    try {
      final formData = {
        'ovc_cpims_id': cpimsID,
        ..._artTherapyFormModel.toJson(),
        ..._hivVisitationFormModel.toJson(),
      };

      // Loop through the formData map and apply modifications
      // formData.forEach((key, value) {
      //   if (value is String) {
      //     // Combine values with 2 or more characters into one
      //     formData[key] = value.split(' ').where((s) => s.length > 1).join(' ');
      //     if (kDebugMode) {
      //       print(formData[value]);
      //     }
      //
      //     // Combine the first words before "if"
      //     formData[key] = formData[key]
      //         .split(' ')
      //         .map((value) =>
      //             value.contains('if') ? value.split('if')[0] : value)
      //         .join(' ');
      //     if (kDebugMode) {
      //       print(formData[value]);
      //     }
      //   } else {
      //     if (kDebugMode) {
      //       print("Hello");
      //     }
      //   }
      // });
      if (kDebugMode) {
        print(formData);
      }

      if (kDebugMode) {
        print(_hivVisitationFormModel.nutritionalSupport);
      }

      formData.forEach((key, value) {
        if (value == "Yes") {
          formData[key] = convertBooleanStringToDBBoolen("Yes");
        } else if (value == "No") {
          formData[key] = convertBooleanStringToDBBoolen("No");
        }
      });

      if (kDebugMode) {
        print(_hivVisitationFormModel.nutritionalSupport);
      }

      // save data locally
      await LocalDb.instance.insertHMFFormData(
        cpimsID!,
        _artTherapyFormModel,
        _hivVisitationFormModel,
        uuid,
        startTimeInterview,
        formType,
        context: context
      );

      //reset form Data
      clearForms();
    } catch (e) {
      rethrow;
    }
  }
}
