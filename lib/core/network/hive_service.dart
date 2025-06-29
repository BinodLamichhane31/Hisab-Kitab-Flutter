import 'package:hisab_kitab/app/constant/hive/hive_table_constant.dart';
import 'package:hisab_kitab/features/auth/data/model/user_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}hisab_kitab.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  //==================User Queries ============================
  //1. register user
  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var newUser = box.put(user.userId, user);
    box.close();
    return newUser;
  }

  //2. login user
  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    box.close();
    return user;
  }

  Future<void> clearAllBoxes() async {
    // List all your box names here that you want to clear
    List<String> boxNames = [
      HiveTableConstant.userBox,
      // add other box names here if you have more
    ];

    for (var boxName in boxNames) {
      var box = await Hive.openBox(boxName);
      await box.clear(); // clears all data in this box
      await box.close();
    }
  }
}
