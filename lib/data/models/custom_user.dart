class CustomUser {
  String id;
  String name;
  String phone;
  bool isPro;
  bool isNewUser;
  List<String> favorites;

  CustomUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.isPro,
    required this.isNewUser,
    required this.favorites,
  });

  void clear() {
    id = '';
    name = '';
    phone = '';
    isPro = false;
    isNewUser = true;
    favorites.clear();
  }
}
