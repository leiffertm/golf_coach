enum SkillLevel { beginner, intermediate, advanced, plus }
enum Club { driver, w3, w5, h3, h4, i3, i4, i5, i6, i7, i8, i9, pw, gw, sw, lw }
enum Trajectory { low, normal, high }
enum CurveShape { draw, straight, fade }
enum CurveMag { small, medium, large }

extension ClubLabel on Club {
  String get label => switch (this) {
        Club.driver => 'Driver',
        Club.w3 => '3W',
        Club.w5 => '5W',
        Club.h3 => '3H',
        Club.h4 => '4H',
        Club.i3 => '3i',
        Club.i4 => '4i',
        Club.i5 => '5i',
        Club.i6 => '6i',
        Club.i7 => '7i',
        Club.i8 => '8i',
        Club.i9 => '9i',
        Club.pw => 'PW',
        Club.gw => 'GW',
        Club.sw => 'SW',
        Club.lw => 'LW',
      };
}

enum Units { yards, meters }
enum GeneratorStrictness { relaxed, defaultStrict, strict }
