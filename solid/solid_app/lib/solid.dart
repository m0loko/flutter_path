// open closed responible
abstract interface class PostNotificationRepostory {
  void postNotification(String type);
}

class EmailNotificationRepostory implements PostNotificationRepostory {
  @override
  void postNotification(String type) {
    print('im email');
  }
}

class PhoneNotfication implements PostNotificationRepostory {
  @override
  void postNotification(String type) {
    print('im phone');
  }
}

class FacebookNotificationRepostoryImpl implements PostNotificationRepostory {
  @override
  void postNotification(String type) {
    print('im facebook');
  }
}
