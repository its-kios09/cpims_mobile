import 'dart:convert';
import 'package:cpims_mobile/services/form_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
import '../Models/form1_data_basemodel.dart';
import '../Models/form_1a.dart';

class CriticalFormData {
  late List<ValueItem> selectedEvents;
  late DateTime selectedDate;

  CriticalFormData({required this.selectedEvents, required this.selectedDate});
}

class ServiceFormData {
  late List<ValueItem> selectedDomain;
  late List<ValueItem> selectedService;
  late DateTime selectedEventDate;

  ServiceFormData(
      {required this.selectedDomain,
        required this.selectedEventDate,
        required this.selectedService});
}

class Form1AProvider extends ChangeNotifier {
  // <<<<<<<<<<<critical events >>>>>>>>>>>>>>>>>>>>>>>>>>>>
  final CriticalFormData _criticalFormData =
  CriticalFormData(selectedEvents: [], selectedDate: DateTime.now());

  // <<<<<<<<<<<< Service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  final ServiceFormData _serviceFormData = ServiceFormData(
      selectedDomain: [],
      selectedEventDate: DateTime.now(),
      selectedService: []);

//<<<<<<<<<<<<<<<<<<<<<Critical events >>>>>>>>>>>>>>>>>>>>>

  CriticalFormData get criticalFormData => _criticalFormData;

  ServiceFormData get serviceFormData => _serviceFormData;

  // <<<<<<<<<<<<<<<Set Methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  // <<<<<<<<<<<<<<<Critical methods >>>>>>>>>>>>>>>>>>>>>>>>
  void setSelectedEvents(List<ValueItem> selectedEvents) {
    _criticalFormData.selectedEvents.clear();
    _criticalFormData.selectedEvents.addAll(selectedEvents);
    notifyListeners();
  }

  void setEventSelectedDate(DateTime selectedDate) {
    criticalFormData.selectedDate = selectedDate;
    notifyListeners();
  }

  // <<<<<<<<<<<<<<<<<<<<Services >>>>>>>>>>>>>>>>>>>>>>>>>>>
  // <<<<<<<<<<<<<<<Domain >>>>>>>>>>>>>>>>>>>>>>>>>>>

  void setSelectedDomain(List<ValueItem> selectedDomain) {
    _serviceFormData.selectedDomain.clear();
    _serviceFormData.selectedDomain.addAll(selectedDomain);
    notifyListeners();
  }

  void setSelectedSubDomain(List<ValueItem> selectedService) {
    _serviceFormData.selectedService.clear();
    _serviceFormData.selectedService.addAll(selectedService);
    notifyListeners();
  }

  void setServiceSelectedDate(DateTime selectedEventDate) {
    _serviceFormData.selectedEventDate = selectedEventDate;
  }

  // <<<<<<<<<<<<<<<Submit critical >>>>>>>>>>>>>>>>>>>
  void submitCriticalData() {
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(_criticalFormData.selectedDate);

    List<Map<String, dynamic>> criticalEvents = [];
    Map<String, dynamic> criticalEvent = {};
    for (var valueItem in _criticalFormData.selectedEvents) {
      criticalEvent["event_date"] = formattedDate;
      criticalEvent["event_id"] = valueItem.value;
      criticalEvents.add(criticalEvent);
      eventData = criticalEvents;
      print(criticalEvents);
    }
  }

  // <<<<<<<<<<<<<Submit Services >>>>>>>>>>>>>>>>>>>>>>>
  void submitServicesData() {
    List<Map<String, dynamic>> service_of_domains = [];
    for (var valueItem in _serviceFormData.selectedDomain) {
      String domainId = valueItem.value ?? '';
      for (var serviceItem in _serviceFormData.selectedService) {
        String serviceId = serviceItem.value ?? '';
        Map<String, dynamic> item = {
          'domainId': domainId,
          'serviceId': serviceId,
        };
        service_of_domains.add(item);
        print(service_of_domains);
        services = service_of_domains;
        print(domainId);
      }
    }
  }

  List<Map<String, dynamic>> eventData = [];
  List<Map<String, dynamic>> services = [];

  // <<<<<<<<<<initializes >>>>>>>>>>>>>>>>>>>
  // List<Form1ServicesModel> servicesList = [];

  void submitCriticalServices() {
    String dateOfEvent = DateFormat('yyyy-MM-dd').format(
        _criticalFormData.selectedDate);

    List<Form1ServicesModel> servicesList = [];
    List<Form1ACriticalEventsModel> eventsList = [];

    for (var event in eventsList) {
      Form1ACriticalEventsModel entry2 = Form1ACriticalEventsModel(
        eventId: event.eventId,
        eventDateId: event.eventDateId,
      );
      eventsList.add(entry2);
      print(entry2);
    }

    for (var service in services) {
      Form1ServicesModel entry = Form1ServicesModel(
        domainId: service['domainId'],
        serviceId: service['serviceId'],
      );
      servicesList.add(entry);
      print(service);
    }

    Form1ADataModel toDbData = Form1ADataModel(
      ovcCpimsId: "ovc_123",
      dateOfEvent: dateOfEvent,
      services: servicesList,
      criticalEvents: eventsList,
    );

    print("ourData:- ${toDbData}");

    Form1Service.saveFormLocal("form1a", toDbData);

    Form1Service.getAllForms('form1a').then((forms) {
      print('Retrieved Form1A data: $forms');
    });

    notifyListeners();
  }
}
// <<<<<<<<<<<<< testing code >>>>>>>>>>>>>>>>


//    setSelectedEvents([]);
//     setSelectedDomain([]);
//     setSelectedSubDomain([]);
//     setEventSelectedDate(DateTime.now());
//     setServiceSelectedDate(DateTime.now());