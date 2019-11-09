import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qrscanner/src/models/scan_model.dart';
export 'package:qrscanner/src/models/scan_model.dart';
class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._() ; //Constructor privado

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path,'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        ); 
      }
    );
  }

  //CREAR REGISTROS
  nuevoScanRaw(ScanModel nuevoScan) async{
    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into ScansDB (id, tipo, valor) "
      "VALUES ('${nuevoScan.id}', '${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );

    return res;
  }

  nuevoScan(ScanModel nuevoScan) async{
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  // SELECT - OBTENER INFORMACION
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans',where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan)=>ScanModel.fromJson(scan) ).toList() 
                          : [];
    return list; 
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("Select * from Scans Where tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan)=>ScanModel.fromJson(scan) ).toList() 
                          : [];
    return list; 
  }

  //Actualizar Registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id= ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  //ELIMINAR REGISTROS
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id= ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }
  
  
 }