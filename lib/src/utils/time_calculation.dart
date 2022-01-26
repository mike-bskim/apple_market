class TimeCalculation {
  static String getTimeDiff(DateTime createdDate) {
    DateTime _now = DateTime.now();
    Duration timeDiff = _now.difference(createdDate);
    if (timeDiff.inHours <= 1) {
      return '방금 전';
    } else if (timeDiff.inHours <= 24) {
      return '${timeDiff.inHours}시간 전';
    } else {
      return '${timeDiff.inDays}일 전';
    }
  }
}
