import 'package:flutter/material.dart';

abstract class DatetimeService {
  /// convert Iso formate to duration formate
  ///    String isoDuration = "PT30M";
  ///    Duration? duration = parseISO8601Duration(isoDuration);
  ///    if (duration != null) {
  ///      print("Duration in minutes: ${duration.inMinutes}"); // Output: 30
  ///    } else {
  ///      print("Invalid ISO 8601 duration format");
  ///    }
  static Duration? parseISO8601Duration(String? isoString) {
    try {
      if (isoString == null || isoString.isEmpty) {
        // Return null if the input is null or empty
        return null;
      }

      // Regular expression to parse the ISO 8601 duration format
      final regex = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$');
      final match = regex.firstMatch(isoString);

      if (match != null) {
        final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
        final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
        final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

        // Return Duration object
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      } else {
        // If the format doesn't match, return null
        return null;
      }
    } catch (e) {
      // Handle any unexpected errors
      debugPrint('Error parsing ISO 8601 duration: ${e.toString()}');
      return null;
    }
  }
}
