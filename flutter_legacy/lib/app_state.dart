import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _PagsRide = prefs.getString('ff_PagsRide') ?? _PagsRide;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _dashboardVersion = '0.0.1345 BETA';
  String get dashboardVersion => _dashboardVersion;
  set dashboardVersion(String value) {
    _dashboardVersion = value;
  }

  List<EventKitStruct> _kits = [];
  List<EventKitStruct> get kits => _kits;
  set kits(List<EventKitStruct> value) {
    _kits = value;
  }

  void addToKits(EventKitStruct value) {
    kits.add(value);
  }

  void removeFromKits(EventKitStruct value) {
    kits.remove(value);
  }

  void removeAtIndexFromKits(int index) {
    kits.removeAt(index);
  }

  void updateKitsAtIndex(
    int index,
    EventKitStruct Function(EventKitStruct) updateFn,
  ) {
    kits[index] = updateFn(_kits[index]);
  }

  void insertAtIndexInKits(int index, EventKitStruct value) {
    kits.insert(index, value);
  }

  String _PagsRide = 'dashboard';
  String get PagsRide => _PagsRide;
  set PagsRide(String value) {
    _PagsRide = value;
    prefs.setString('ff_PagsRide', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
