import 'package:flutter/material.dart';

import '../../../../Models/case_load_model.dart';

class Form1bCardItem extends StatefulWidget {
  const Form1bCardItem(
      {super.key, required this.caseLoadModel, required this.allCaseLoadData});
  final CaseLoadModel caseLoadModel;
  final List<CaseLoadModel> allCaseLoadData;

  @override
  State<Form1bCardItem> createState() => _Form1bCardItemState();
}

class _Form1bCardItemState extends State<Form1bCardItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final children = widget.allCaseLoadData
        .where((element) =>
    element.caregiverCpimsId == widget.caseLoadModel.caregiverCpimsId)
        .toList();
    return Column(
      children: [
        GestureDetector(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.caseLoadModel.ovcFirstName} ${widget.caseLoadModel.ovcSurname}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          const Text(
                            'CPIMS ID: ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${widget.caseLoadModel.cpimsId}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Caregiver: ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          '${widget.caseLoadModel.caregiverNames}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Icon(isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Age: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(calculateAge(widget.caseLoadModel.dateOfBirth!))
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(widget.caseLoadModel.sex!),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String calculateAge(String date) {
  final dob = DateTime.parse(date);
  final now = DateTime.now();
  final difference = now.difference(dob);
  final age = difference.inDays / 365;
  return age.toStringAsFixed(0);
}

String formatSex(String sex) {
  return sex.toLowerCase() == "male" ? "M" : "F";
}