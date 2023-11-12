import 'package:cpims_mobile/providers/hiv_management_form_provider.dart';
import 'package:cpims_mobile/screens/cpara/widgets/cpara_details_widget.dart';
import 'package:cpims_mobile/screens/cpara/widgets/cpara_stable_widget.dart';
import 'package:cpims_mobile/screens/cpara/widgets/custom_radio_buttons.dart';
import 'package:cpims_mobile/screens/forms/hiv_management/models/hiv_management_form_model.dart';
import 'package:cpims_mobile/screens/forms/hiv_management/utils/hiv_management_form_status_provider.dart';
import 'package:cpims_mobile/screens/registry/organisation_units/widgets/steps_wrapper.dart';
import 'package:cpims_mobile/utils.dart';
import 'package:cpims_mobile/widgets/custom_text_field.dart';
import 'package:cpims_mobile/widgets/form_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ARTTherapyInfoWidget extends StatefulWidget {
  const ARTTherapyInfoWidget({
    super.key,
  });

  @override
  State<ARTTherapyInfoWidget> createState() => _ARTTherapyInfoWidgetState();
}

class _ARTTherapyInfoWidgetState extends State<ARTTherapyInfoWidget> {
  String dateHIVConfirmedPositive = '';
  String dateTreatmentInitiated = '';
  String baselineHEILoad = '';
  String dateStartedFirstLine = '';
  String arvsSubWithFirstLine = '';
  String arvsSubWithFirstLineDate = '';
  String switchToSecondLine = '';
  String switchToSecondLineDate = '';
  String switchToThirdLine = '';
  String switchToThirdLineDate = '';

  TextEditingController baselineHEILoadController = TextEditingController();

  void handleOnSave() {
    final formData = ARTTherapyHIVFormModel(
      dateHIVConfirmedPositive: dateHIVConfirmedPositive,
      dateTreatmentInitiated: dateTreatmentInitiated,
      baselineHEILoad: baselineHEILoad,
      dateStartedFirstLine: dateStartedFirstLine,
      arvsSubWithFirstLine: arvsSubWithFirstLine,
      arvsSubWithFirstLineDate: arvsSubWithFirstLineDate,
      switchToSecondLine: switchToSecondLine,
      switchToSecondLineDate: switchToSecondLineDate,
      switchToThirdLine: switchToThirdLine,
      switchToThirdLineDate: switchToThirdLineDate,
    );
    Provider.of<HIVManagementFormProvider>(context, listen: false)
        .updateARTTheraphyHIVModel(formData);

    final isComplete = areAllFieldsFilled();
    if (isComplete) {
      final formCompletionStatus = context.read<FormCompletionStatusProvider>();
      formCompletionStatus.setArtTherapyFormCompleted(true);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill in the required fields"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  bool areAllFieldsFilled() {
    // Define a list of required fields to check if they are filled in
    final requiredFields = [
      dateHIVConfirmedPositive,
      dateTreatmentInitiated,
      baselineHEILoad,
      dateStartedFirstLine,
      arvsSubWithFirstLine,
      switchToSecondLine,
      switchToThirdLine,
    ];

    // Check if any required field is empty
    return requiredFields.every((field) => field.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final artTherapyInfoFormData =
        Provider.of<HIVManagementFormProvider>(context).artTherapyFormModel;
    return StepsWrapper(
      title: '1. ARV Therapy Info',
      children: [
        FormSection(
          children: [
            const Text(
              '1) Date Confirmed HIV Positive',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DateTextField(
              label: artTherapyInfoFormData.dateHIVConfirmedPositive.isNotEmpty
                  ? artTherapyInfoFormData.dateHIVConfirmedPositive
                  : 'Date',
              enabled: true,
              onDateSelected: (date) {
                setState(() {
                  dateHIVConfirmedPositive = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '2a) Date Initiated on Treatment',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DateTextField(
              label: artTherapyInfoFormData.dateTreatmentInitiated.isNotEmpty
                  ? artTherapyInfoFormData.dateTreatmentInitiated
                  : 'Date',
              enabled: true,
              onDateSelected: (date) {
                setState(() {
                  dateTreatmentInitiated = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '2b) Baseline viral load for HEI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              initialValue: artTherapyInfoFormData.baselineHEILoad,
              onChanged: (String val) {
                baselineHEILoad=val;
                handleOnSave();
                // setState(() {
                //   baselineHEILoad = baselineHEILoadController.text;
                //   handleOnSave();
                // });
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '3) Date started on 1st Line',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DateTextField(
              label: artTherapyInfoFormData.dateStartedFirstLine.isNotEmpty
                  ? artTherapyInfoFormData.dateStartedFirstLine
                  : 'Date',
              enabled: true,
              onDateSelected: (date) {
                setState(() {
                  dateStartedFirstLine = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '4) Substitution of ARVs within 1st Line Regimen',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomRadioButton(
              isNaAvailable: false,
              option: artTherapyInfoFormData.arvsSubWithFirstLine.isNotEmpty
                  ? convertingStringToRadioButtonOptions(
                      artTherapyInfoFormData.arvsSubWithFirstLine)
                  : null,
              optionSelected: (options) {
                setState(() {
                  arvsSubWithFirstLine =
                      convertingRadioButtonOptionsToString(options);
                  if (arvsSubWithFirstLine == 'No') {
                    arvsSubWithFirstLineDate = '';
                  }
                  handleOnSave();
                });
              },
            ),
            DateTextField(
              label: artTherapyInfoFormData.arvsSubWithFirstLineDate.isNotEmpty
                  ? artTherapyInfoFormData.arvsSubWithFirstLineDate
                  : 'If Yes, Date',
              enabled: arvsSubWithFirstLine == "Yes",
              onDateSelected: (date) {
                setState(() {
                  arvsSubWithFirstLineDate = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '5) Switch to 2nd Line (or Substitute within 2nd Line)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomRadioButton(
              isNaAvailable: false,
              option: artTherapyInfoFormData.switchToSecondLine.isNotEmpty
                  ? convertingStringToRadioButtonOptions(
                      artTherapyInfoFormData.switchToSecondLine)
                  : null,
              optionSelected: (RadioButtonOptions? options) {
                setState(() {
                  switchToSecondLine =
                      convertingRadioButtonOptionsToString(options);
                  if (switchToSecondLine == 'No') {
                    switchToSecondLineDate = '';
                  }
                  handleOnSave();
                });
              },
            ),
            DateTextField(
              label: artTherapyInfoFormData.switchToSecondLineDate.isNotEmpty
                  ? artTherapyInfoFormData.switchToSecondLineDate
                  : 'If Yes, Date',
              enabled: switchToSecondLine == "Yes",
              onDateSelected: (date) {
                setState(() {
                  switchToSecondLineDate = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        FormSection(
          children: [
            const Text(
              '6) Switch to 3rd Line (or Substitute within 3nd Line)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomRadioButton(
              isNaAvailable: false,
              option: artTherapyInfoFormData.switchToThirdLine.isNotEmpty
                  ? convertingStringToRadioButtonOptions(
                      artTherapyInfoFormData.switchToThirdLine)
                  : null,
              optionSelected: (RadioButtonOptions? options) {
                setState(() {
                  switchToThirdLine =
                      convertingRadioButtonOptionsToString(options);
                  if (switchToThirdLine == 'No') {
                    switchToThirdLineDate = '';
                  }
                  handleOnSave();
                });
              },
            ),
            DateTextField(
              label: artTherapyInfoFormData.switchToThirdLineDate.isNotEmpty
                  ? artTherapyInfoFormData.switchToThirdLineDate
                  : 'If Yes, Date',
              enabled: switchToThirdLine == "Yes",
              onDateSelected: (date) {
                setState(() {
                  switchToThirdLineDate = formattedDate(date!);
                  handleOnSave();
                });
              },
              identifier: DateTextFieldIdentifier.dateOfAssessment,
            ),
          ],
        ),
      ],
    );
  }
}
