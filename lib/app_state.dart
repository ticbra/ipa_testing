import 'package:flutter/material.dart';
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
      _LoginUsername = prefs.getString('ff_LoginUsername') ?? _LoginUsername;
    });
    _safeInit(() {
      _LoginPassword = prefs.getString('ff_LoginPassword') ?? _LoginPassword;
    });
    _safeInit(() {
      _UserLoggedIn = prefs.getInt('ff_UserLoggedIn') ?? _UserLoggedIn;
    });
    _safeInit(() {
      _SignUpUsername = prefs.getString('ff_SignUpUsername') ?? _SignUpUsername;
    });
    _safeInit(() {
      _usertoken = prefs.getString('ff_usertoken') ?? _usertoken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _user = '';
  String get user => _user;
  set user(String value) {
    _user = value;
  }

  String _token = '';
  String get token => _token;
  set token(String value) {
    _token = value;
  }

  String _statusregistration = '';
  String get statusregistration => _statusregistration;
  set statusregistration(String value) {
    _statusregistration = value;
  }

  String _LoginUsername = '';
  String get LoginUsername => _LoginUsername;
  set LoginUsername(String value) {
    _LoginUsername = value;
    prefs.setString('ff_LoginUsername', value);
  }

  String _LoginPassword = '';
  String get LoginPassword => _LoginPassword;
  set LoginPassword(String value) {
    _LoginPassword = value;
    prefs.setString('ff_LoginPassword', value);
  }

  int _UserLoggedIn = 0;
  int get UserLoggedIn => _UserLoggedIn;
  set UserLoggedIn(int value) {
    _UserLoggedIn = value;
    prefs.setInt('ff_UserLoggedIn', value);
  }

  String _SignUpUsername = '';
  String get SignUpUsername => _SignUpUsername;
  set SignUpUsername(String value) {
    _SignUpUsername = value;
    prefs.setString('ff_SignUpUsername', value);
  }

  String _usertoken = '';
  String get usertoken => _usertoken;
  set usertoken(String value) {
    _usertoken = value;
    prefs.setString('ff_usertoken', value);
  }

  String _disabledDateCalendar = '';
  String get disabledDateCalendar => _disabledDateCalendar;
  set disabledDateCalendar(String value) {
    _disabledDateCalendar = value;
  }

  String _firstDayCalendar = '';
  String get firstDayCalendar => _firstDayCalendar;
  set firstDayCalendar(String value) {
    _firstDayCalendar = value;
  }

  String _lastDayCalendar = '';
  String get lastDayCalendar => _lastDayCalendar;
  set lastDayCalendar(String value) {
    _lastDayCalendar = value;
  }

  String _services = '';
  String get services => _services;
  set services(String value) {
    _services = value;
  }

  String _bookings = '';
  String get bookings => _bookings;
  set bookings(String value) {
    _bookings = value;
  }

  double _priceEur = 0.0;
  double get priceEur => _priceEur;
  set priceEur(double value) {
    _priceEur = value;
  }

  double _priceHrk = 0.0;
  double get priceHrk => _priceHrk;
  set priceHrk(double value) {
    _priceHrk = value;
  }

  int _durationMin = 0;
  int get durationMin => _durationMin;
  set durationMin(int value) {
    _durationMin = value;
  }

  String _footerDuration = '';
  String get footerDuration => _footerDuration;
  set footerDuration(String value) {
    _footerDuration = value;
  }

  String _bookServices = '';
  String get bookServices => _bookServices;
  set bookServices(String value) {
    _bookServices = value;
  }

  String _bookDate = '';
  String get bookDate => _bookDate;
  set bookDate(String value) {
    _bookDate = value;
  }

  String _bookTime = '     ';
  String get bookTime => _bookTime;
  set bookTime(String value) {
    _bookTime = value;
  }

  String _bookLang = '';
  String get bookLang => _bookLang;
  set bookLang(String value) {
    _bookLang = value;
  }

  List<int> _bookServicesList = [];
  List<int> get bookServicesList => _bookServicesList;
  set bookServicesList(List<int> value) {
    _bookServicesList = value;
  }

  void addToBookServicesList(int value) {
    bookServicesList.add(value);
  }

  void removeFromBookServicesList(int value) {
    bookServicesList.remove(value);
  }

  void removeAtIndexFromBookServicesList(int index) {
    bookServicesList.removeAt(index);
  }

  void updateBookServicesListAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    bookServicesList[index] = updateFn(_bookServicesList[index]);
  }

  void insertAtIndexInBookServicesList(int index, int value) {
    bookServicesList.insert(index, value);
  }

  int _bookEmployee = 0;
  int get bookEmployee => _bookEmployee;
  set bookEmployee(int value) {
    _bookEmployee = value;
  }

  String _bookStatus = '';
  String get bookStatus => _bookStatus;
  set bookStatus(String value) {
    _bookStatus = value;
  }

  bool _boolDisabled = false;
  bool get boolDisabled => _boolDisabled;
  set boolDisabled(bool value) {
    _boolDisabled = value;
  }

  int _intButtonsCount = 0;
  int get intButtonsCount => _intButtonsCount;
  set intButtonsCount(int value) {
    _intButtonsCount = value;
  }

  bool _boolEmployeeChanged = false;
  bool get boolEmployeeChanged => _boolEmployeeChanged;
  set boolEmployeeChanged(bool value) {
    _boolEmployeeChanged = value;
  }

  String _serviceNames = '';
  String get serviceNames => _serviceNames;
  set serviceNames(String value) {
    _serviceNames = value;
  }

  List<String> _bookNamesList = [];
  List<String> get bookNamesList => _bookNamesList;
  set bookNamesList(List<String> value) {
    _bookNamesList = value;
  }

  void addToBookNamesList(String value) {
    bookNamesList.add(value);
  }

  void removeFromBookNamesList(String value) {
    bookNamesList.remove(value);
  }

  void removeAtIndexFromBookNamesList(int index) {
    bookNamesList.removeAt(index);
  }

  void updateBookNamesListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    bookNamesList[index] = updateFn(_bookNamesList[index]);
  }

  void insertAtIndexInBookNamesList(int index, String value) {
    bookNamesList.insert(index, value);
  }

  double _priceToEur = 0.0;
  double get priceToEur => _priceToEur;
  set priceToEur(double value) {
    _priceToEur = value;
  }

  double _totalPriceEur = 0.0;
  double get totalPriceEur => _totalPriceEur;
  set totalPriceEur(double value) {
    _totalPriceEur = value;
  }

  bool _returnToReservation = false;
  bool get returnToReservation => _returnToReservation;
  set returnToReservation(bool value) {
    _returnToReservation = value;
  }

  int _countAvailableEmployees = 0;
  int get countAvailableEmployees => _countAvailableEmployees;
  set countAvailableEmployees(int value) {
    _countAvailableEmployees = value;
  }

  bool _boolCount = false;
  bool get boolCount => _boolCount;
  set boolCount(bool value) {
    _boolCount = value;
  }

  bool _boolTime = false;
  bool get boolTime => _boolTime;
  set boolTime(bool value) {
    _boolTime = value;
  }

  bool _boolReservation = false;
  bool get boolReservation => _boolReservation;
  set boolReservation(bool value) {
    _boolReservation = value;
  }

  bool _notReservation = false;
  bool get notReservation => _notReservation;
  set notReservation(bool value) {
    _notReservation = value;
  }

  String _bookDayName = '';
  String get bookDayName => _bookDayName;
  set bookDayName(String value) {
    _bookDayName = value;
  }

  bool _bothDisabled = false;
  bool get bothDisabled => _bothDisabled;
  set bothDisabled(bool value) {
    _bothDisabled = value;
  }

  bool _boolEnabledDate = false;
  bool get boolEnabledDate => _boolEnabledDate;
  set boolEnabledDate(bool value) {
    _boolEnabledDate = value;
  }

  bool _boolDateChanged = false;
  bool get boolDateChanged => _boolDateChanged;
  set boolDateChanged(bool value) {
    _boolDateChanged = value;
  }

  bool _isHovering = false;
  bool get isHovering => _isHovering;
  set isHovering(bool value) {
    _isHovering = value;
  }

  bool _boolWaiting = false;
  bool get boolWaiting => _boolWaiting;
  set boolWaiting(bool value) {
    _boolWaiting = value;
  }

  bool _boolUrgent = false;
  bool get boolUrgent => _boolUrgent;
  set boolUrgent(bool value) {
    _boolUrgent = value;
  }

  bool _modeSpecial = false;
  bool get modeSpecial => _modeSpecial;
  set modeSpecial(bool value) {
    _modeSpecial = value;
  }

  bool _isNewHovering = false;
  bool get isNewHovering => _isNewHovering;
  set isNewHovering(bool value) {
    _isNewHovering = value;
  }

  bool _clearSelectedEmployee = false;
  bool get clearSelectedEmployee => _clearSelectedEmployee;
  set clearSelectedEmployee(bool value) {
    _clearSelectedEmployee = value;
  }

  bool _returnToFirst = false;
  bool get returnToFirst => _returnToFirst;
  set returnToFirst(bool value) {
    _returnToFirst = value;
  }

  bool _boolLogin = false;
  bool get boolLogin => _boolLogin;
  set boolLogin(bool value) {
    _boolLogin = value;
  }

  bool _boolRegistration = false;
  bool get boolRegistration => _boolRegistration;
  set boolRegistration(bool value) {
    _boolRegistration = value;
  }

  String _userProfileName = '';
  String get userProfileName => _userProfileName;
  set userProfileName(String value) {
    _userProfileName = value;
  }

  bool _availableEmployeeReg = false;
  bool get availableEmployeeReg => _availableEmployeeReg;
  set availableEmployeeReg(bool value) {
    _availableEmployeeReg = value;
  }

  bool _isSelectedNew = false;
  bool get isSelectedNew => _isSelectedNew;
  set isSelectedNew(bool value) {
    _isSelectedNew = value;
  }

  bool _isDisabledEmployee = false;
  bool get isDisabledEmployee => _isDisabledEmployee;
  set isDisabledEmployee(bool value) {
    _isDisabledEmployee = value;
  }

  bool _listReservationBoolean = false;
  bool get listReservationBoolean => _listReservationBoolean;
  set listReservationBoolean(bool value) {
    _listReservationBoolean = value;
  }

  String _modeSpecialCount = '';
  String get modeSpecialCount => _modeSpecialCount;
  set modeSpecialCount(String value) {
    _modeSpecialCount = value;
  }

  String _modeUrgentCount = '';
  String get modeUrgentCount => _modeUrgentCount;
  set modeUrgentCount(String value) {
    _modeUrgentCount = value;
  }

  String _modeWaitingCount = '';
  String get modeWaitingCount => _modeWaitingCount;
  set modeWaitingCount(String value) {
    _modeWaitingCount = value;
  }

  int _reservationId = 0;
  int get reservationId => _reservationId;
  set reservationId(int value) {
    _reservationId = value;
  }

  int _idreservation = 0;
  int get idreservation => _idreservation;
  set idreservation(int value) {
    _idreservation = value;
  }

  bool _modeSpecialOffer = false;
  bool get modeSpecialOffer => _modeSpecialOffer;
  set modeSpecialOffer(bool value) {
    _modeSpecialOffer = value;
  }

  bool _boolSpecial = false;
  bool get boolSpecial => _boolSpecial;
  set boolSpecial(bool value) {
    _boolSpecial = value;
  }

  String _usernameProfil = '';
  String get usernameProfil => _usernameProfil;
  set usernameProfil(String value) {
    _usernameProfil = value;
  }

  String _NameProfil = '';
  String get NameProfil => _NameProfil;
  set NameProfil(String value) {
    _NameProfil = value;
  }

  String _LastNameProfil = '';
  String get LastNameProfil => _LastNameProfil;
  set LastNameProfil(String value) {
    _LastNameProfil = value;
  }

  String _TelephoneProfile = '';
  String get TelephoneProfile => _TelephoneProfile;
  set TelephoneProfile(String value) {
    _TelephoneProfile = value;
  }

  String _priceBack = '';
  String get priceBack => _priceBack;
  set priceBack(String value) {
    _priceBack = value;
  }

  bool _newSpecial = false;
  bool get newSpecial => _newSpecial;
  set newSpecial(bool value) {
    _newSpecial = value;
  }

  String _specialUrl = '';
  String get specialUrl => _specialUrl;
  set specialUrl(String value) {
    _specialUrl = value;
  }

  bool _displayReservation = false;
  bool get displayReservation => _displayReservation;
  set displayReservation(bool value) {
    _displayReservation = value;
  }

  bool _buttonVisible = false;
  bool get buttonVisible => _buttonVisible;
  set buttonVisible(bool value) {
    _buttonVisible = value;
  }

  int _CountWords = 0;
  int get CountWords => _CountWords;
  set CountWords(int value) {
    _CountWords = value;
  }

  String _ChangedPassword = '';
  String get ChangedPassword => _ChangedPassword;
  set ChangedPassword(String value) {
    _ChangedPassword = value;
  }

  String _ChangedNewPassword = '';
  String get ChangedNewPassword => _ChangedNewPassword;
  set ChangedNewPassword(String value) {
    _ChangedNewPassword = value;
  }

  int _CountChangedPassword = 0;
  int get CountChangedPassword => _CountChangedPassword;
  set CountChangedPassword(int value) {
    _CountChangedPassword = value;
  }

  int _CountCurrentPasswordLength = 0;
  int get CountCurrentPasswordLength => _CountCurrentPasswordLength;
  set CountCurrentPasswordLength(int value) {
    _CountCurrentPasswordLength = value;
  }

  bool _currentPasswordShow = false;
  bool get currentPasswordShow => _currentPasswordShow;
  set currentPasswordShow(bool value) {
    _currentPasswordShow = value;
  }

  bool _newPasswordShow = false;
  bool get newPasswordShow => _newPasswordShow;
  set newPasswordShow(bool value) {
    _newPasswordShow = value;
  }

  bool _repeatPasswordShow = false;
  bool get repeatPasswordShow => _repeatPasswordShow;
  set repeatPasswordShow(bool value) {
    _repeatPasswordShow = value;
  }

  bool _newPasswordCheckIcon = false;
  bool get newPasswordCheckIcon => _newPasswordCheckIcon;
  set newPasswordCheckIcon(bool value) {
    _newPasswordCheckIcon = value;
  }

  String _newPasswordField = '';
  String get newPasswordField => _newPasswordField;
  set newPasswordField(String value) {
    _newPasswordField = value;
  }

  bool _currentPasswordCheckIcon = false;
  bool get currentPasswordCheckIcon => _currentPasswordCheckIcon;
  set currentPasswordCheckIcon(bool value) {
    _currentPasswordCheckIcon = value;
  }

  bool _repeatPasswordCheckIcon = false;
  bool get repeatPasswordCheckIcon => _repeatPasswordCheckIcon;
  set repeatPasswordCheckIcon(bool value) {
    _repeatPasswordCheckIcon = value;
  }

  String _StatusProfile = '';
  String get StatusProfile => _StatusProfile;
  set StatusProfile(String value) {
    _StatusProfile = value;
  }

  bool _StatusPasswordRecovery = false;
  bool get StatusPasswordRecovery => _StatusPasswordRecovery;
  set StatusPasswordRecovery(bool value) {
    _StatusPasswordRecovery = value;
  }

  String _StatusRecovery = '';
  String get StatusRecovery => _StatusRecovery;
  set StatusRecovery(String value) {
    _StatusRecovery = value;
  }

  int _intRecoveryCount = 0;
  int get intRecoveryCount => _intRecoveryCount;
  set intRecoveryCount(int value) {
    _intRecoveryCount = value;
  }

  bool _boolStatusRecovery = false;
  bool get boolStatusRecovery => _boolStatusRecovery;
  set boolStatusRecovery(bool value) {
    _boolStatusRecovery = value;
  }

  bool _boolFirstTime = false;
  bool get boolFirstTime => _boolFirstTime;
  set boolFirstTime(bool value) {
    _boolFirstTime = value;
  }

  int _intUsernameCount = 0;
  int get intUsernameCount => _intUsernameCount;
  set intUsernameCount(int value) {
    _intUsernameCount = value;
  }

  int _intPasswordCount = 0;
  int get intPasswordCount => _intPasswordCount;
  set intPasswordCount(int value) {
    _intPasswordCount = value;
  }

  String _StatusLogin = '';
  String get StatusLogin => _StatusLogin;
  set StatusLogin(String value) {
    _StatusLogin = value;
  }

  String _cardId = '';
  String get cardId => _cardId;
  set cardId(String value) {
    _cardId = value;
  }

  String _OrderId = '';
  String get OrderId => _OrderId;
  set OrderId(String value) {
    _OrderId = value;
  }

  String _OrderUrl = '';
  String get OrderUrl => _OrderUrl;
  set OrderUrl(String value) {
    _OrderUrl = value;
  }

  bool _cancelReservationBool = false;
  bool get cancelReservationBool => _cancelReservationBool;
  set cancelReservationBool(bool value) {
    _cancelReservationBool = value;
  }

  bool _boolReturnUserPage = false;
  bool get boolReturnUserPage => _boolReturnUserPage;
  set boolReturnUserPage(bool value) {
    _boolReturnUserPage = value;
  }

  bool _boolBookDate = false;
  bool get boolBookDate => _boolBookDate;
  set boolBookDate(bool value) {
    _boolBookDate = value;
  }

  bool _boolWaitingList = false;
  bool get boolWaitingList => _boolWaitingList;
  set boolWaitingList(bool value) {
    _boolWaitingList = value;
  }

  bool _boolAnimation = false;
  bool get boolAnimation => _boolAnimation;
  set boolAnimation(bool value) {
    _boolAnimation = value;
  }

  bool _boolSyncDate = false;
  bool get boolSyncDate => _boolSyncDate;
  set boolSyncDate(bool value) {
    _boolSyncDate = value;
  }

  String _emailRecovery = '';
  String get emailRecovery => _emailRecovery;
  set emailRecovery(String value) {
    _emailRecovery = value;
  }

  bool _statusProfileNewTrue = false;
  bool get statusProfileNewTrue => _statusProfileNewTrue;
  set statusProfileNewTrue(bool value) {
    _statusProfileNewTrue = value;
  }

  int _CountWordsUsername = 0;
  int get CountWordsUsername => _CountWordsUsername;
  set CountWordsUsername(int value) {
    _CountWordsUsername = value;
  }

  int _CountWordsPassword = 0;
  int get CountWordsPassword => _CountWordsPassword;
  set CountWordsPassword(int value) {
    _CountWordsPassword = value;
  }

  bool _boolCountWordsUsername = false;
  bool get boolCountWordsUsername => _boolCountWordsUsername;
  set boolCountWordsUsername(bool value) {
    _boolCountWordsUsername = value;
  }

  bool _boolCountWordsPassword = false;
  bool get boolCountWordsPassword => _boolCountWordsPassword;
  set boolCountWordsPassword(bool value) {
    _boolCountWordsPassword = value;
  }

  String _stringCountWordsPassword = '';
  String get stringCountWordsPassword => _stringCountWordsPassword;
  set stringCountWordsPassword(String value) {
    _stringCountWordsPassword = value;
  }

  bool _boolCpolorUsername = false;
  bool get boolCpolorUsername => _boolCpolorUsername;
  set boolCpolorUsername(bool value) {
    _boolCpolorUsername = value;
  }

  bool _boolColorPassword = false;
  bool get boolColorPassword => _boolColorPassword;
  set boolColorPassword(bool value) {
    _boolColorPassword = value;
  }

  String _emailRecoveryNew = '';
  String get emailRecoveryNew => _emailRecoveryNew;
  set emailRecoveryNew(String value) {
    _emailRecoveryNew = value;
  }

  int _intFirstNameCount = 0;
  int get intFirstNameCount => _intFirstNameCount;
  set intFirstNameCount(int value) {
    _intFirstNameCount = value;
  }

  bool _boolFirstName = false;
  bool get boolFirstName => _boolFirstName;
  set boolFirstName(bool value) {
    _boolFirstName = value;
  }

  String _stringFirstNameRegistration = '';
  String get stringFirstNameRegistration => _stringFirstNameRegistration;
  set stringFirstNameRegistration(String value) {
    _stringFirstNameRegistration = value;
  }

  int _intLastNameCount = 0;
  int get intLastNameCount => _intLastNameCount;
  set intLastNameCount(int value) {
    _intLastNameCount = value;
  }

  String _stringLastNameRegistration = '';
  String get stringLastNameRegistration => _stringLastNameRegistration;
  set stringLastNameRegistration(String value) {
    _stringLastNameRegistration = value;
  }

  bool _boolLastName = false;
  bool get boolLastName => _boolLastName;
  set boolLastName(bool value) {
    _boolLastName = value;
  }

  int _intphoneCount = 0;
  int get intphoneCount => _intphoneCount;
  set intphoneCount(int value) {
    _intphoneCount = value;
  }

  bool _boolPhone = false;
  bool get boolPhone => _boolPhone;
  set boolPhone(bool value) {
    _boolPhone = value;
  }

  String _StringPhoneRegistration = '';
  String get StringPhoneRegistration => _StringPhoneRegistration;
  set StringPhoneRegistration(String value) {
    _StringPhoneRegistration = value;
  }

  int _countEmailRegistration = 0;
  int get countEmailRegistration => _countEmailRegistration;
  set countEmailRegistration(int value) {
    _countEmailRegistration = value;
  }

  bool _boolEmailRegistration = false;
  bool get boolEmailRegistration => _boolEmailRegistration;
  set boolEmailRegistration(bool value) {
    _boolEmailRegistration = value;
  }

  String _stringEmailRegistration = '';
  String get stringEmailRegistration => _stringEmailRegistration;
  set stringEmailRegistration(String value) {
    _stringEmailRegistration = value;
  }

  int _countPasswordRegistration = 0;
  int get countPasswordRegistration => _countPasswordRegistration;
  set countPasswordRegistration(int value) {
    _countPasswordRegistration = value;
  }

  bool _boolPasswordRegistration = false;
  bool get boolPasswordRegistration => _boolPasswordRegistration;
  set boolPasswordRegistration(bool value) {
    _boolPasswordRegistration = value;
  }

  String _stringPasswordRegistration = '';
  String get stringPasswordRegistration => _stringPasswordRegistration;
  set stringPasswordRegistration(String value) {
    _stringPasswordRegistration = value;
  }

  int _countPasswordRepeatRegistration = 0;
  int get countPasswordRepeatRegistration => _countPasswordRepeatRegistration;
  set countPasswordRepeatRegistration(int value) {
    _countPasswordRepeatRegistration = value;
  }

  bool _boolPasswordRepeatRegistration = false;
  bool get boolPasswordRepeatRegistration => _boolPasswordRepeatRegistration;
  set boolPasswordRepeatRegistration(bool value) {
    _boolPasswordRepeatRegistration = value;
  }

  String _stringPasswordRepeatRegistration = '';
  String get stringPasswordRepeatRegistration =>
      _stringPasswordRepeatRegistration;
  set stringPasswordRepeatRegistration(String value) {
    _stringPasswordRepeatRegistration = value;
  }

  String _stringPasswordRepeatRegistrationNull = '';
  String get stringPasswordRepeatRegistrationNull =>
      _stringPasswordRepeatRegistrationNull;
  set stringPasswordRepeatRegistrationNull(String value) {
    _stringPasswordRepeatRegistrationNull = value;
  }

  String _stringPasswordForRegistration = '';
  String get stringPasswordForRegistration => _stringPasswordForRegistration;
  set stringPasswordForRegistration(String value) {
    _stringPasswordForRegistration = value;
  }

  String _stringEmailForRegistration = '';
  String get stringEmailForRegistration => _stringEmailForRegistration;
  set stringEmailForRegistration(String value) {
    _stringEmailForRegistration = value;
  }

  bool _boolNewRegistration = false;
  bool get boolNewRegistration => _boolNewRegistration;
  set boolNewRegistration(bool value) {
    _boolNewRegistration = value;
  }

  bool _boolPayedOrders = false;
  bool get boolPayedOrders => _boolPayedOrders;
  set boolPayedOrders(bool value) {
    _boolPayedOrders = value;
  }

  String _stringPayedOrders = '';
  String get stringPayedOrders => _stringPayedOrders;
  set stringPayedOrders(String value) {
    _stringPayedOrders = value;
  }

  String _stringHistoryPage = '';
  String get stringHistoryPage => _stringHistoryPage;
  set stringHistoryPage(String value) {
    _stringHistoryPage = value;
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
