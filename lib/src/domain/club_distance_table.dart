import 'enums.dart';

class ClubDistanceTable {
  static (int, int) range(Club club, SkillLevel skill) {
    final base = switch (club) {
      Club.driver => (230, 280),
      Club.w3 => (210, 240),
      Club.w5 => (195, 225),
      Club.h3 => (190, 215),
      Club.h4 => (180, 205),
      Club.i3 => (190, 205),
      Club.i4 => (180, 195),
      Club.i5 => (170, 185),
      Club.i6 => (160, 175),
      Club.i7 => (150, 165),
      Club.i8 => (140, 155),
      Club.i9 => (130, 145),
      Club.pw => (115, 130),
      Club.gw => (100, 115),
      Club.sw => (80, 100),
      Club.lw => (60, 85),
    };
    final adj = switch (skill) {
      SkillLevel.beginner => (-20, -10),
      SkillLevel.intermediate => (0, 0),
      SkillLevel.advanced => (5, 10),
      SkillLevel.plus => (10, 15),
    };
    return (base.$1 + adj.$1, base.$2 + adj.$2);
  }
}
