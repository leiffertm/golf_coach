import 'dart:convert';
import 'package:flutter/services.dart';
import 'enums.dart';
import 'models.dart';

class CustomDistancesLoader {
  static Map<Club, ClubYardageRange>? _cachedDistances;
  static Set<Club>? _cachedSelectedClubs;
  
  /// Loads custom club distances from the JSON asset file.
  /// Returns a map of clubs to their custom yardage ranges.
  /// Clubs with null values in the JSON are skipped.
  static Future<Map<Club, ClubYardageRange>> loadCustomDistances() async {
    if (_cachedDistances != null) {
      return _cachedDistances!;
    }
    
    final result = await _loadFromJson();
    _cachedDistances = result.$1;
    _cachedSelectedClubs = result.$2;
    return _cachedDistances!;
  }
  
  /// Returns the set of clubs that should be selected based on having valid distances.
  static Future<Set<Club>> getSelectedClubs() async {
    if (_cachedSelectedClubs != null) {
      return _cachedSelectedClubs!;
    }
    
    final result = await _loadFromJson();
    _cachedDistances = result.$1;
    _cachedSelectedClubs = result.$2;
    return _cachedSelectedClubs!;
  }
  
  static Future<(Map<Club, ClubYardageRange>, Set<Club>)> _loadFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/custom_club_distances.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final Map<Club, ClubYardageRange> customDistances = {};
      final Set<Club> selectedClubs = {};
      
      for (final entry in jsonData.entries) {
        final clubName = entry.key;
        final clubData = entry.value as Map<String, dynamic>?;
        
        if (clubData == null) continue;
        
        final min = clubData['min'] as int?;
        final max = clubData['max'] as int?;
        
        // Convert string club name to Club enum
        final club = _stringToClub(clubName);
        if (club == null) continue;
        
        // If club has valid distances, add to both maps
        if (min != null && max != null) {
          customDistances[club] = ClubYardageRange(min: min, max: max);
          selectedClubs.add(club);
        }
      }
      
      return (customDistances, selectedClubs);
    } catch (e) {
      // If loading fails, return empty collections (will fall back to defaults)
      return (<Club, ClubYardageRange>{}, <Club>{});
    }
  }
  
  /// Converts a string club name to a Club enum value.
  static Club? _stringToClub(String clubName) {
    return switch (clubName) {
      'driver' => Club.driver,
      'w3' => Club.w3,
      'w5' => Club.w5,
      'h3' => Club.h3,
      'h4' => Club.h4,
      'i2' => Club.i2,
      'i3' => Club.i3,
      'i4' => Club.i4,
      'i5' => Club.i5,
      'i6' => Club.i6,
      'i7' => Club.i7,
      'i8' => Club.i8,
      'i9' => Club.i9,
      'pw' => Club.pw,
      'gw' => Club.gw,
      'sw' => Club.sw,
      'lw' => Club.lw,
      'hlw' => Club.hlw,
      _ => null,
    };
  }
  
  /// Clears the cached distances (useful for testing or reloading).
  static void clearCache() {
    _cachedDistances = null;
    _cachedSelectedClubs = null;
  }
}
