class StringUtils {
  ///判断 文本为空
  static bool isNoEmpty(String text) {
    return null != text && text.isNotEmpty;
  }

  ///判断 文本不为空
  static bool isEmpty(String text) {
    return null == text || text.isEmpty;
  }
}
