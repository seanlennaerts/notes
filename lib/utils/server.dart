import 'dart:io';
import 'dart:async';

Future<InternetAddress> getIpAddress() async {
  for (var interface in await NetworkInterface.list()) {
    if (interface.name == 'en0') {
      return InternetAddress(interface.addresses[0].address);
    }
  }
  return null;
}
