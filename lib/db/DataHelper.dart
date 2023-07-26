import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/ModelChallengeExerciseList.dart';
import '../models/ModelChallengesMainCat.dart';
import '../models/ModelCompleteChallenge.dart';
import '../models/ModelExerciseDetail.dart';
import '../models/ModelExerciseList.dart';
import '../models/ModelFitnessWorkout.dart';
import '../models/ModelHistory.dart';
import '../models/ModelLastCompleteData.dart';
import '../models/ModelMainCategory.dart';
import '../models/ModelSeasonal.dart';
import '../models/ModelWorkoutExerciseList.dart';
import '../models/ModelYogaList.dart';
import '../models/ModelYogaStyle.dart';

class DataHelper {
  static final _databaseName = "flutter_workout_ui_db.db";
  static final _databaseVersion = 1;
  static String dbPath = "";

  DataHelper._privateConstructor();

  static final DataHelper instance = DataHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase(false);
    }

    return _database!;
  }

  Future<Database> _initDatabase(bool fromUpdate) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    dbPath = path;
    var exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else if (fromUpdate) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path,
        version: _databaseVersion,
        readOnly: false,
        onUpgrade: _onUpgrade,
        onCreate: _onCreate,
        singleInstance: true);
  }

  void _onCreate(db, version) {
    print("getVersionCreate---$version");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var resultsGetFirst = await db.query("complete_challenge_data");
    var resultsGetFirstHis = await db.query("tbl_history");
    print(
        "getVersion---$oldVersion---$newVersion--${resultsGetFirst.isNotEmpty}");
    if (oldVersion < newVersion) {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, _databaseName);
      dbPath = path;
      var exists = await databaseExists(path);
      try {
        if (exists) {}

        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);

      List<ModelCompleteChallenge>? list = resultsGetFirst.isNotEmpty
          ? resultsGetFirst
              .map((c) => ModelCompleteChallenge.fromMap(c))
              .toList()
          : null;
      List<ModelHistory>? listHistory = resultsGetFirstHis.isNotEmpty
          ? resultsGetFirstHis.map((c) => ModelHistory.fromMap(c)).toList()
          : null;

      try {
        if (list != null && list.isNotEmpty) {
          var buffer = new StringBuffer();

          list.forEach((element) {
            if (buffer.isNotEmpty) {
              buffer.write(",\n");
            }
            buffer.write("(");
            buffer.write(element.week);
            buffer.write(", ");
            buffer.write(element.day);
            buffer.write(", ");
            buffer.write(element.challengeId);
            buffer.write(")");
          });
          await db.delete("complete_challenge_data");
          await db.rawInsert(
              "INSERT Into complete_challenge_data (week,day,challenge_id)"
              " VALUES ${buffer.toString()}");
        }
        if (listHistory != null && listHistory.isNotEmpty) {
          var buffer = new StringBuffer();

          listHistory.forEach((element) {
            if (buffer.isNotEmpty) {
              buffer.write(",\n");
            }
            buffer.write("('");
            buffer.write(element.title);
            buffer.write("', '");
            buffer.write(element.startTime);
            buffer.write("', ");
            buffer.write(element.totalDuration);
            buffer.write(", '");
            buffer.write(element.kCal);
            buffer.write("', '");
            buffer.write(element.date);
            buffer.write("')");
          });
          await db.delete("tbl_history");
          await db.rawInsert(
              "INSERT Into tbl_history (title,start_time,total_duration,kcal,date)"
              " VALUES ${buffer.toString()}");
        }
      } catch (e) {
        print(e);
      }
    }
  }
  //
  // Future<List<ModelMainCategory>> getAllMainCategory() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_main_category");
  //   List<ModelMainCategory>? list = results.isNotEmpty
  //       ? results.map((c) => ModelMainCategory.fromMap(c)).toList()
  //       : null;
  //   return list!;
  // }
  //
  // Future<List<ModelChallengesMainCat>?> getAllChallengesList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_challenges_list");
  //   List<ModelChallengesMainCat>? list = results.isNotEmpty
  //       ? results.map((c) => ModelChallengesMainCat.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }
  //
  // Future<List<ModelExerciseList>?> getAllExerciseByMainCategory(int id) async {
  //   Database database = await instance.database;
  //   var results = await database
  //       .query("tbl_exercise_list", where: "main_cat_id=?", whereArgs: [id]);
  //   List<ModelExerciseList>? list = results.isNotEmpty
  //       ? results.map((c) => ModelExerciseList.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }

  // Future<List<ModelYogaStyle>?> getAllYogaStyleList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_yoga_style_workout");
  //   List<ModelYogaStyle>? list = results.isNotEmpty
  //       ? results.map((c) => ModelYogaStyle.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }

  // Future<List<ModelFitnessWorkout>?> getAllPopularWorkoutList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_popular_workout");
  //   List<ModelFitnessWorkout>? list = results.isNotEmpty
  //       ? results.map((c) => ModelFitnessWorkout.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }

  // Future<List<ModelFitnessWorkout>?> getAllTopPicksList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_top_picks");
  //   List<ModelFitnessWorkout>? list = results.isNotEmpty
  //       ? results.map((c) => ModelFitnessWorkout.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }

  // Future<List<ModelFitnessWorkout>?> getAllFitnessList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_body_fitness");
  //   List<ModelFitnessWorkout>? list = results.isNotEmpty
  //       ? results.map((c) => ModelFitnessWorkout.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }
  //
  // Future<List<ModelSeasonal>?> getAllSeasonalWorkoutsList() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_seasonal_yoga");
  //   List<ModelSeasonal>? list = results.isNotEmpty
  //       ? results.map((c) => ModelSeasonal.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }
  //


  // Future<List<ModelHistory>?> calculateTotalWorkout() async {
  //   Database database = await instance.database;
  //   var results = await database.query("tbl_history");
  //   List<ModelHistory>? list = results.isNotEmpty
  //       ? results.map((c) => ModelHistory.fromMap(c)).toList()
  //       : null;
  //   return list;
  // }
  //
  //




}
