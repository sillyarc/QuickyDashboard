import '/flutter_flow/flutter_flow_util.dart';
import 'realizandoatask_widget.dart' show RealizandoataskWidget;
import 'package:flutter/material.dart';

class RealizandoataskModel extends FlutterFlowModel<RealizandoataskWidget> {
  ///  Local state fields for this component.

  List<String> fotos = [];
  void addToFotos(String item) => fotos.add(item);
  void removeFromFotos(String item) => fotos.remove(item);
  void removeAtIndexFromFotos(int index) => fotos.removeAt(index);
  void insertAtIndexInFotos(int index, String item) =>
      fotos.insert(index, item);
  void updateFotosAtIndex(int index, Function(String) updateFn) =>
      fotos[index] = updateFn(fotos[index]);

  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadData93q87 = false;
  FFUploadedFile uploadedLocalFile_uploadData93q87 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData93q87 = '';

  bool isDataUploading_uploadData792 = false;
  FFUploadedFile uploadedLocalFile_uploadData792 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData792 = '';

  bool isDataUploading_uploadData99465 = false;
  FFUploadedFile uploadedLocalFile_uploadData99465 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData99465 = '';

  bool isDataUploading_uploadData8746 = false;
  FFUploadedFile uploadedLocalFile_uploadData8746 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData8746 = '';

  bool isDataUploading_uploadData98vhiy = false;
  FFUploadedFile uploadedLocalFile_uploadData98vhiy =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData98vhiy = '';

  // State field(s) for Checkbox widget.
  Map<String, bool> checkboxValueMap = {};
  List<String> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
