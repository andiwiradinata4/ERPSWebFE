class Password {
  final int userId;
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;
  final String code;
  final bool isForget;

  Password(
      {required this.userId,
        this.oldPassword = '',
        this.newPassword = '',
        this.confirmNewPassword = '',
        required this.code,
        this.isForget = false});

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "old_password": oldPassword,
    "new_password": newPassword,
    "confirm_new_password": confirmNewPassword,
    "code": code
  };
}
