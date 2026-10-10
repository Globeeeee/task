String errorMessage(Object e) {
  return e.toString().replaceFirst('Exception: ', '');
}
