import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FoodDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }


  

  Future<Database> _initDb() async {
    // 1. الحصول على مسار قواعد البيانات على الجهاز
    String databasePath = await getDatabasesPath();
    // 2. تحديد اسم الملف food.db
    String path = join(databasePath, 'food.db');
    // 3. فتح (أو إنشاء) القاعدة بالإصدار 1
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // تَرْكِيب الجدول عند أول إنشاء للقاعدة
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE allfood (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        name     TEXT    NOT NULL,
        price    REAL    NOT NULL,
        notes    TEXT
      )
    ''');
    print('⚙️ onCreate: جدول allfood تم إنشاؤه');
  }




  // إذا احتجت لتعديل بنية الجدول عند رفع الإصدار مستقبلاً
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('⚙️ onUpgrade: من الإصدار $oldVersion إلى $newVersion');
    // مثال: إذا كان oldVersion = 1 و newVersion = 2، يمكنك إضافة عمود جديد:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE allfood ADD COLUMN category TEXT;');
    // }
  }

  // عمليات CRUD عامة باستخدام SQL خام:
  Future<List<Map>> readData(String sql) async {
    final database = await db;
    return await database!.rawQuery(sql);
  }

  Future<int> insertData(String sql) async {
    final database = await db;
    return await database!.rawInsert(sql);
  }

  Future<int> updateData(String sql) async {
    final database = await db;
    return await database!.rawUpdate(sql);
  }

  Future<int> deleteData(String sql) async {
    final database = await db;
    return await database!.rawDelete(sql);
  }
}
