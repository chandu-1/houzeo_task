import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final callLogsProvider = Provider((ref) => CallLogsRepository());

class CallLogsRepository {
  Future<void> call(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
  
}
