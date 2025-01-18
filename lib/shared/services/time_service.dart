class TimeService {
  Stream<DateTime> get curTimeStream =>
      Stream.periodic(const Duration(seconds: 5), (_) {
        final now = DateTime.now();
        return now;
      });
}
