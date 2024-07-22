import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class LoginCall {
  static Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
    String? token = '',
  }) async {
    final ffApiRequestBody = '''
{  "username": "$username",
  "password": "$password",
  "token": "$token"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Login',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RegistrationCall {
  static Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
    String? firstName = '',
    String? lastName = '',
    String? email = '',
    String? phone = '',
    String? privacyPolicy = '',
    String? newsletter = '',
    String? passwordRepeat = '',
  }) async {
    final ffApiRequestBody = '''
{
   "username":"$username",
   "password":"$password",
   "first_name":"$firstName",
   "last_name":"$lastName",
   "email":"$email",
   "phone":"$phone",
   "privacy_policy":"$privacyPolicy",
   "newsletter":"$newsletter",
   "password_repeat":"$passwordRepeat"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Registration',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/registration',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UserCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'User',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/api/v1/user/$userToken',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CalendarDatesCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'CalendarDates',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/availability',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? something(dynamic response) => getJsonField(
        response,
        r'''$.booking.services[:]''',
        true,
      ) as List?;
}

class AvaillabilityFirstCall {
  static Future<ApiCallResponse> call({
    String? bookings = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'AvaillabilityFirst',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/availability',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BookingCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
    List<int>? bookServicesList,
    int? bookEmployee,
    String? bookDate = '',
    String? bookTime = '',
    String? bookLang = '',
  }) async {
    final bookServices = _serializeList(bookServicesList);

    final ffApiRequestBody = '''
{
  "services":$bookServices,
  "employee": "$bookEmployee",
  "date": "$bookDate",
  "time": "$bookTime",
  "lang": "$bookLang"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Booking',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/book',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic bookingPath(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class ProfilCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Profil',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/profile',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BookingsCountCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'bookingsCount',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/bookings?mode=count',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReservationDetailsCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
    int? id,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'ReservationDetails',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/bookings/$id',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
        'id': id,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FCMTokenCall {
  static Future<ApiCallResponse> call({
    String? token = '',
    String? title = '',
    String? body = '',
  }) async {
    final ffApiRequestBody = '''
{
  "to": "$token",
  "notification": {
    "title": "$title",
    "body": "$body",
    "badge": 1,
    "sound": "Default",
    "image": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'FCMToken',
      apiUrl: 'https://fcm.googleapis.com/fcm/send',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'key=AAAAj8aGxGY:APA91bG2eX3A5kyFcs0mbIXICXP2rukDuqvLeG8td1JYdPtMDZhgSOimWWlQh28oJBNAT5wR3vxn_PVsx776J8oiA0XwmBYacS4F4mwTPoU7miGY59AWn-m7EH3id1cqftecj8b3d11z',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PutNotificationCall {
  static Future<ApiCallResponse> call({
    String? token = '',
    int? id,
  }) async {
    final ffApiRequestBody = '''
{token:"$token"id:$id}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PutNotification',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$token/notifications/$id?read=true',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PutProfilePersonCall {
  static Future<ApiCallResponse> call({
    String? token = '',
    String? firstName = '',
    String? lastName = '',
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
   "token":"$token",
   "first_name":"$firstName",
   "last_name":"$lastName",
   "phone":"$phone"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Put Profile Person',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$token/profile',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PutProfilePasswordCall {
  static Future<ApiCallResponse> call({
    String? token = '',
    String? currentPassword = '',
    String? newPassword = '',
  }) async {
    final ffApiRequestBody = '''
{
  "token": "$token",
  "current_password": "$currentPassword",
  "new_password": "$newPassword"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Put Profile Password',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$token/profile',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PasswordRecoveryCall {
  static Future<ApiCallResponse> call({
    String? email = '',
  }) async {
    final ffApiRequestBody = '''
{
   "email":"$email"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PasswordRecovery',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/recovery',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetCardsCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GetCards',
      apiUrl:
          'https://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$token/cards',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'token': token,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteReservationCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
    String? id = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'DeleteReservation',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/bookings/$id',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {
        'user_token': userToken,
        'id': id,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class OrdersCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Orders',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/orders',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BookingHistoryCall {
  static Future<ApiCallResponse> call({
    String? userToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'BookingHistory',
      apiUrl:
          'http://gentlemensshop.hr.dev.enter-internet.com/mobile-app/api/v1/user/$userToken/bookings?history',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'user_token': userToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
