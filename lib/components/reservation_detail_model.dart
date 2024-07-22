import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'reservation_detail_widget.dart' show ReservationDetailWidget;
import 'package:flutter/material.dart';

class ReservationDetailModel extends FlutterFlowModel<ReservationDetailWidget> {
  ///  Local state fields for this component.

  int? reservationID;

  String? reservationDate;

  String? reservationName;

  String? reservationPrice;

  String? reservationDuration;

  String? employeeName;

  String? employeeImage;

  String? reservationType = '';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (ReservationDetails)] action in ReservationDetail widget.
  ApiCallResponse? apiResulti10;
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
