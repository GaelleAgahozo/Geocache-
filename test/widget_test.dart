// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocaching_app/compass.dart';
import 'package:geocaching_app/location_items.dart';

import 'package:geocaching_app/main.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  // full test of app
  testWidgets('Run app, choose a location, and look at the compass', 
  (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // ensure that there is at least one location to choose
    expect(find.byType(LocationItem), findsWidgets);
    // there should not be a compass on the screen
    expect(find.byKey(const Key('compass')), findsNothing);

    // tap on a LocationItem
    await tester.tap(find.text("North Pole"));
    await tester.pumpAndSettle();

    // there should be no more LocationItems onscreen
    expect(find.byType(LocationItem), findsNothing);
    // the compass should be on the new screen
    expect(find.byKey(const Key('compass')), findsOneWidget);

    // attempt to return to the list screen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // ensure that there is at least one location to choose
    expect(find.byType(LocationItem), findsWidgets);
    // there should not be a compass on the screen
    expect(find.byKey(const Key('compass')), findsNothing);
  });

  test('Compass magnetometer conversion method works as intended', () {
    // create a State object for testing
    CompassScreenState css = CompassScreenState();
    
    // test the conversion method
    // north
    double output = css.convertMagnetometerEventToHeading(MagnetometerEvent(0, 48.4, 0));
    expect(output, 0);
    // west
    output = css.convertMagnetometerEventToHeading(MagnetometerEvent(48.4, 0, 0));
    expect(output, -90);
    // south
    output = css.convertMagnetometerEventToHeading(MagnetometerEvent(0, -48.4, 0));
    expect(output < 0 ? -output : output, 180);
    // east
    output = css.convertMagnetometerEventToHeading(MagnetometerEvent(-48.4, 0, 0));
    expect(output, 90);

  });
}
