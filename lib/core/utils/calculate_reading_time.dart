int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp('r \s+')).length;

  // speed = distance/time

  // assuming average time to read a word is btw 200 - 300 sec

  final readingTime = wordCount / 220;
  return readingTime.ceil();
}
