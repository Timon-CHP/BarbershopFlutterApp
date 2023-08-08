import 'package:date_format/date_format.dart' as format_date;
import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/models/facility.dart';
import 'package:flutter_maihomie_app/core/models/product.dart';
import 'package:flutter_maihomie_app/core/models/stylist.dart';
import 'package:flutter_maihomie_app/core/models/time_slot.dart';
import 'package:flutter_maihomie_app/core/models/type_product.dart';
import 'package:flutter_maihomie_app/core/services/booking_service.dart';
import 'package:flutter_maihomie_app/core/state_models/base.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:geolocator/geolocator.dart';

class BookingModel extends BaseModel {
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final BookingService _bookingService = locator<BookingService>();
  StepBooking currentStep = StepBooking.selectFacility;
  bool _disposed = false;

  TimeSlot? currentTimeSlot;
  bool isAdvice = true;
  bool isTakeAPhoto = true;
  DateTime selectedDate = DateTime.now();
  Facility? selectedFacility;
  StylistRate? selectedStylist;
  int totalDuration = 30;
  Position? position;

  List<Facility> facilities = [];
  List<Product> selectedProducts = [];
  List<List<Product>> products = [];
  List<TypeProduct> typeProducts = [];
  List<TimeSlot> timeSlotsDefault = [];
  List<StylistRate>? stylists = [];

  ///Step Select Barbershop
  changeFacilities() async {
    position = await _bookingService.getCurrentLocation();
    facilities = await _bookingService.getFacility();
    if (position != null) {
      facilities.sort(
        (a, b) => Geolocator.distanceBetween(position!.latitude,
                position!.longitude, a.latitude ?? 0, a.longitude ?? 0)
            .compareTo(
          Geolocator.distanceBetween(position!.latitude, position!.longitude,
              b.latitude ?? 0, b.longitude ?? 0),
        ),
      );
    }
    notifyListeners();
  }

  Future changeSelectedFacility(Facility facility) async {
    selectedFacility = facility;

    notifyListeners();

    stylists = await _bookingService.getStylists(
      facilityId: facility.id ?? 0,
      date: DateTime.now(),
    );
  }

  ///Step Select Service
  Future changeTypeProduct() async {
    typeProducts = await _bookingService.getTypeProduct();
    await changeProducts();
  }

  changeProducts() async {
    for (var i = 0; i < typeProducts.length; i++) {
      final res =
          await _bookingService.getProduct(typeProductId: typeProducts[i].id);

      products.add(res);
    }

    notifyListeners();
  }

  void updateSelectedProduct(List<Product> selectedServices) {
    selectedProducts = selectedServices;

    totalDuration = 0;
    for (int i = 0; i < selectedServices.length; i++) {
      totalDuration += int.parse("${selectedServices[i].duration}");
    }

    notifyListeners();
  }

  selectedProduct(Product item) {
    if (!selectedProducts.contains(item)) {
      selectedProducts.removeWhere(
          (element) => item.typeProductId == element.typeProductId);
      selectedProducts.add(item);
    } else {
      selectedProducts.remove(item);
    }
    notifyListeners();
  }

  ///Step Select Stylist & Datetime
  Future changeSelectedDate(DateTime date) async {
    if (selectedDate == date) {
      return;
    }
    selectedDate = date;
    // change stylists
    var res = await _bookingService.getStylists(
      facilityId: selectedFacility != null ? selectedFacility!.id ?? 0 : 0,
      date: date,
    );

    selectedStylist = null;
    currentTimeSlot = null;
    stylists = res;

    for (var element in timeSlotsDefault) {
      element.isSelected = false;
    }
    notifyListeners();
  }

  Future changeSelectedStylist(StylistRate? stylist) async {
    selectedStylist = stylist;

    //TODO change time
    // initTimeSlots();

    List<TimeSlot> res = [];

    if (stylist != null) {
      res = await _bookingService.getTimeSlotSelected(
        stylistId: stylist.id ?? 0,
        date: format_date.formatDate(selectedDate, fDate),
      );
    }

    for (var element in timeSlotsDefault) {
      element.isSelected = false;
      for (int i = 0; i < res.length; i++) {
        if (res[i].id == element.id) {
          element.isSelected = true;
          res.removeAt(i);
        }
      }
    }

    currentTimeSlot = null;
    notifyListeners();
  }

  Future initTimeSlots() async {
    timeSlotsDefault = await _bookingService.getTimeSlot();
    notifyListeners();
  }

  changeCurrentTimeSlot({TimeSlot? timeSlot}) {
    if (timeSlot != currentTimeSlot) {
      currentTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  //Booking
  changeCurrentStep(StepBooking stepBooking) {
    currentStep = stepBooking;
    notifyListeners();
  }

  nextStep() {
    currentStep = StepBooking.values[currentStep.index + 1];
    notifyListeners();
  }

  backStep() {
    currentStep = StepBooking.values[currentStep.index - 1];
    notifyListeners();
  }

  changeAdvice(bool advice) {
    isAdvice = advice;
    notifyListeners();
  }

  changeTakeAPhoto(bool takeAPhoto) {
    isTakeAPhoto = !isTakeAPhoto;
    notifyListeners();
  }

  bool checkCompleted() {
    if (selectedProducts.isEmpty || selectedFacility == null) {
      return false;
    }

    if (currentTimeSlot == null) {
      return false;
    }
    return true;
  }

  Future complete({
    String notes = "",
  }) async {
    Map<String, dynamic> data = {
      "time_slot_id": currentTimeSlot!.id,
      "date": format_date.formatDate(selectedDate, fDate),
      "notes": notes,
      // "stylist_id": selectedStylist!.id ?? 0,
      'products': selectedProducts.map((e) => e.id).toList()
    };

    if (selectedStylist == null) {
      var stylistTemp = stylists!.first;

      for (var e in stylists!) {
        if (((e.communication ?? 5) + (e.skill ?? 5)) >
            ((stylistTemp.communication ?? 5) + (stylistTemp.skill ?? 5))) {
          stylistTemp = e;
        }
      }

      data['stylist_id'] = stylistTemp.id;
    } else {
      data['stylist_id'] = selectedStylist!.id ?? 0;
    }
    logger.d(data);
    return _bookingService.createNewTask(data: data);
  }

  void reset() {
    currentStep = StepBooking.selectFacility;
    selectedStylist = null;
    currentTimeSlot = null;
    isAdvice = true;
    isTakeAPhoto = true;
    _disposed = false;
    selectedFacility = null;

    selectedProducts = [];
    stylists = [];
    timeSlotsDefault = [];
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  changeDisposed() {
    _disposed = true;
  }
}

enum StepBooking { selectFacility, selectProduct, selectStylistAndDate }
