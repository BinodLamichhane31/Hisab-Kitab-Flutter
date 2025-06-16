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
}
