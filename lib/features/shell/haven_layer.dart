/// Depth layer within the unified Haven experience (PD-031, PD-036).
enum HavenLayer {
  home,
  money,
  plans,
}

extension HavenLayerX on HavenLayer {
  /// Relative depth for morph direction — higher means deeper.
  int get depth => switch (this) {
        HavenLayer.home => 0,
        HavenLayer.money => 1,
        HavenLayer.plans => 2,
      };
}
