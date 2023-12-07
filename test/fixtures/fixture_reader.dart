import 'dart:io';

String fixture({required String name}) =>
    File('test/fixtures/$name').readAsStringSync();
