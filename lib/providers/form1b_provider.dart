import 'package:cpims_mobile/services/form_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
import '../Models/form_1_model.dart';
import '../screens/forms/form1b/model/critical_events_form1b_model.dart';
import '../screens/forms/form1b/model/health_form1b_model.dart';
import '../screens/forms/form1b/utils/FinalServicesForm1bModel.dart';
import '../screens/forms/form1b/utils/MasterServicesForm1bModel.dart';
import '../screens/forms/form1b/utils/SafeForm1bModel.dart';
import '../screens/forms/form1b/utils/StableForm1bModel.dart';
import '../widgets/custom_toast.dart';

class Form1bProvider extends ChangeNotifier {

  Form1bProvider() {
    // Fetch data immediately when the provider is created
    fetchLocalDbData();
  }


  final HealthFormData _formData = HealthFormData(
      selectedServices: [],
      selectedDate: DateTime.now(),
      domainId: '1234'
  );
  final StableFormData _stableFormData = StableFormData(
      selectedServices: [],
      domainId: ""
  );
  final SafeFormData _safeFormData = SafeFormData(
      selectedServices: [],
      domainId: ""
  );
  final FinalServicesFormData _finalServicesFormData = FinalServicesFormData(
      masterServicesList: [],
      dateOfEvent: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ovc_cpims_id: "",
  );
  final CriticalEventDataForm1b _criticalEventDataForm1b = CriticalEventDataForm1b(
    selectedEvents: [],
      selectedDate: DateTime.now(),
  );

  HealthFormData get formData => _formData;
  StableFormData get stableFormData => _stableFormData;
  SafeFormData get safeFormData => _safeFormData;
  CriticalEventDataForm1b get criticalEventDataForm1b => _criticalEventDataForm1b;
  FinalServicesFormData get finalServicesFormData => _finalServicesFormData;



  void setSelectedHealthServices(List<ValueItem> selectedServices, String domainId) {
    _formData.selectedServices.clear(); // Clear the current list
    _formData.selectedServices.addAll(selectedServices);
    _formData.domainId = domainId;
    notifyListeners();
  }
  void setSelectedSafeFormDataServices(List<ValueItem> selectedServices, String domainId) {
    _safeFormData.selectedServices.clear(); // Clear the current list
    _safeFormData.selectedServices.addAll(selectedServices);
    _safeFormData.domainId = domainId;
    notifyListeners();
  }
  void setSelectedStableFormDataServices(List<ValueItem> selectedServices, String domainId) {
    _stableFormData.selectedServices.clear(); // Clear the current list
    _stableFormData.selectedServices.addAll(selectedServices);
    _stableFormData.domainId = domainId;
    notifyListeners();
  }
  void setSelectedDate(DateTime selectedDate) {
     // CustomToastWidget.showToast(selectedDate);
    _formData.selectedDate = selectedDate;
    notifyListeners();
  }
  //setting up data for crticial events
  void setCriticalEventsSelectedDate(DateTime selectedDate) {
    // CustomToastWidget.showToast(selectedDate);
    _criticalEventDataForm1b.selectedDate = selectedDate;
    notifyListeners();
  }
  void setCriticalEventsSelectedEvents(List<ValueItem> selectedEvents){
    _criticalEventDataForm1b.selectedEvents.clear();
    _criticalEventDataForm1b.selectedEvents.addAll(selectedEvents);
    notifyListeners();
  }



  //these are methods to be worked on just before our form is saved
  void setFinalFormDataOvcId(String ovc_cpims_id) {
    _finalServicesFormData.ovc_cpims_id = ovc_cpims_id;
    // CustomToastWidget.showToast(_finalServicesFormData.ovc_cpims_id);
    notifyListeners();
  }
  void setFinalFormDataDOE(DateTime dateOfEvent){
    //we get the date as date time and save it as a string in yyyy-mm--dd
    _finalServicesFormData.dateOfEvent = DateFormat('yyyy-MM-dd').format(dateOfEvent);
    notifyListeners();
  }
  void setFinalFormDataServices(List<MasterServicesFormData> masterServicesList){
    _finalServicesFormData.masterServicesList = masterServicesList;
    notifyListeners();
  }
  List<Form1CriticalEventsModel> getFinalCriticalEventsFormData(){
    List<Form1CriticalEventsModel> criticalEvents = generateCriticalEventsDS(criticalEventDataForm1b);
    print(criticalEvents);
    return criticalEvents;
  }


  List<Form1DataModel> _form1bDBData = [];
  List<Form1DataModel> get form1bDBData => _form1bDBData;
  Future<void> fetchLocalDbData() async {
    _form1bDBData = await Form1Service.getAllForms("form1b");
    notifyListeners();
  }




  Future<bool> saveForm1bData(HealthFormData healthFormData) async{
    List<MasterServicesFormData> masterServicesList = convertToMasterServicesFormData();
    //creating our data to be sent for saving
    setFinalFormDataServices(masterServicesList);
    setFinalFormDataOvcId(_finalServicesFormData.ovc_cpims_id);
    setFinalFormDataDOE(formData.selectedDate);
    List<Form1CriticalEventsModel> criticalEventsFormData = getFinalCriticalEventsFormData();



    List<Form1ServicesModel> servicesList = [];

    for (MasterServicesFormData masterFormData in finalServicesFormData.masterServicesList ?? []) {
      Form1ServicesModel entry = Form1ServicesModel(domainId: masterFormData.domainId, serviceId: masterFormData.selectedServiceId);
      servicesList.add(entry);
    }

    List<Form1CriticalEventsModel> criticalEventsList = [];
    for (var criticalEvent in criticalEventsFormData) {
      Form1CriticalEventsModel entry = Form1CriticalEventsModel(
          eventId: criticalEvent.eventId,
          eventDate: criticalEvent.eventDate
      );
      criticalEventsList.add(entry);
    }


    Form1DataModel toDbData = Form1DataModel(
        ovcCpimsId: finalServicesFormData.ovc_cpims_id,
        dateOfEvent: finalServicesFormData.dateOfEvent,
        services: servicesList,
      criticalEvents: criticalEventsList
    );
    // print("ourData${toDbData}");
    // print("criticalEventsDataForm1b${getFinalCriticalEventsFormData()}");

    print("form1b payload:==========>$criticalEventsList");

    bool isFormSaved = await Form1Service.saveFormLocal("form1b", toDbData);
    if(isFormSaved == true){
      CustomToastWidget.showToast("Saving...");
      resetFormData();
      notifyListeners();
    }

     return isFormSaved;
  }

  //converting the various services from the domains into one Services list with domain id and service id
  List<MasterServicesFormData> convertToMasterServicesFormData() {
    List<MasterServicesFormData> masterServicesList = [];
    HealthFormData healthFormData = formData;
    //convert the healthy form data
    for (ValueItem serviceItem in healthFormData.selectedServices) {
      masterServicesList.add(
        MasterServicesFormData(
          selectedServiceId: serviceItem.value,
          domainId: healthFormData.domainId,
          // dateOfEvent: DateFormat('yyyy-MM-dd').format(healthFormData.selectedDate),
        ),
      );
    }
    // Convert StableFormData selected services
    for (ValueItem serviceItem in stableFormData.selectedServices) {
      masterServicesList.add(
        MasterServicesFormData(
          selectedServiceId: serviceItem.value,
          domainId: stableFormData.domainId,
          // dateOfEvent: DateFormat('yyyy-MM-dd').format(healthFormData.selectedDate),
        ),
      );
    }
    // Convert SafeFormData selected services
    for (dynamic serviceItem in safeFormData.selectedServices) {
      masterServicesList.add(
        MasterServicesFormData(
          selectedServiceId: serviceItem.value,
          domainId: safeFormData.domainId,
          // dateOfEvent: DateFormat('yyyy-MM-dd').format(healthFormData.selectedDate),
        ),
      );
    }

    return masterServicesList;
  }

  List<Form1CriticalEventsModel> generateCriticalEventsDS(CriticalEventDataForm1b criticalEventDataForm1b) {
    List<Form1CriticalEventsModel> eventsList = [];

    for (int i = 0; i < criticalEventDataForm1b.selectedEvents.length; i++) {
      final eventId = criticalEventDataForm1b.selectedEvents[i].value;
      final eventDate = DateFormat('yyyy-MM-dd').format(criticalEventDataForm1b.selectedDate);

      eventsList.add(
        Form1CriticalEventsModel(eventId: eventId!, eventDate: eventDate)
      );
    }

    return eventsList;
  }

  List<Map<String, dynamic>> form1bFetchedData = [];
  Future<void> fetchSavedDataFromDb() async {
    try {
      List<Map<String, dynamic>> updatedForm1Rows = await Form1Service.getAllForms("form1b");

      form1bFetchedData = updatedForm1Rows;

      print(form1bFetchedData);
      notifyListeners();
    } catch (e) {
      print("Error fetching form1b data: $e");
    }
  }


  void resetFormData() {
    _formData.selectedServices.clear();
    _formData.selectedDate = DateTime.now();
    _formData.domainId = '1234';

    _stableFormData.selectedServices.clear();
    _stableFormData.domainId = '';

    _safeFormData.selectedServices.clear();
    _safeFormData.domainId = '';

    _finalServicesFormData.masterServicesList.clear();
    _finalServicesFormData.dateOfEvent = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _finalServicesFormData.ovc_cpims_id = '';

    _criticalEventDataForm1b.selectedEvents.clear();
    _criticalEventDataForm1b.selectedDate = DateTime.now();

    notifyListeners();
  }
}



