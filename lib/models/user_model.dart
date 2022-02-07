class UserModel {
  String id;
  String email, phoneNumber, password, role;

  String firstName, lastName, profilePhoto;
  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.profilePhoto,
    this.password,
    this.role,
    this.firstName,
    this.lastName,
  });
}
