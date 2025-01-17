import 'dart:async';

import 'package:app/constants/config.dart';
import 'package:app/models/insights.dart';
import 'package:app/models/kya.dart';
import 'package:app/models/measurement.dart';
import 'package:app/models/notification.dart';
import 'package:app/models/place_details.dart';
import 'package:app/models/site.dart';
import 'package:app/models/user_details.dart';
import 'package:app/utils/distance.dart';
import 'package:app/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/enum_constants.dart';

class DBHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    await createDefaultTables(_database!);
    return _database!;
  }

  Future<void> clearAccount() async {
    try {
      final db = await database;
      await db.delete(Kya.dbName());
      await db.delete(UserNotification.dbName());
      await db.delete(PlaceDetails.dbName());
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> clearFavouritePlaces() async {
    try {
      final db = await database;
      await db.delete(PlaceDetails.dbName());
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> createDefaultTables(Database db) async {
    var prefs = await SharedPreferences.getInstance();
    var createDatabases = prefs.getBool(Config.prefReLoadDb) ?? true;

    var batch = db.batch();

    if (createDatabases) {
      batch
        ..execute(Measurement.dropTableStmt())
        ..execute(Site.dropTableStmt())
        ..execute(PlaceDetails.dropTableStmt())
        ..execute(UserNotification.dropTableStmt())
        ..execute(Insights.dropTableStmt())
        ..execute(Kya.dropTableStmt());
      await prefs.setBool(Config.prefReLoadDb, false);
    }

    batch
      ..execute(Measurement.createTableStmt())
      ..execute(Site.createTableStmt())
      ..execute(PlaceDetails.createTableStmt())
      ..execute(UserNotification.createTableStmt())
      ..execute(Insights.createTableStmt())
      ..execute(Kya.createTableStmt());

    await batch.commit(noResult: true, continueOnError: true);
  }

  Future<List<PlaceDetails>> getFavouritePlaces() async {
    try {
      final db = await database;

      var res = await db.query(PlaceDetails.dbName());

      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return PlaceDetails.fromJson(res[i]);
            })
          : <PlaceDetails>[];
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');

      return <PlaceDetails>[];
    }
  }

  Future<List<Insights>> getInsights(String siteId, Frequency frequency) async {
    try {
      final db = await database;

      var res = await db.query(Insights.dbName(),
          where: 'siteId = ? and frequency = ?',
          whereArgs: [siteId, frequency.getName()]);

      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return Insights.fromJson(res[i]);
            })
          : <Insights>[];
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return <Insights>[];
    }
  }

  Future<List<Kya>> getKyas() async {
    try {
      final db = await database;

      var res = await db.query(Kya.dbName());

      if (res.isEmpty) {
        return [];
      }

      var collections = groupBy(res, (Map obj) => obj['id']);
      var kyaList = <Kya>[];
      for (var key in collections.keys) {
        if (collections.containsKey(key)) {
          var kya = Kya.fromDbJson(collections[key]);
          if (kya.id.isNotEmpty) {
            kyaList.add(kya);
          }
        }
      }
      return kyaList;
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return <Kya>[];
    }
  }

  Future<List<Measurement>> getLatestMeasurements() async {
    try {
      final db = await database;

      var res = await db.query(Measurement.measurementsDb());

      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return Measurement.fromJson(Measurement.mapFromDb(res[i]));
            })
          : <Measurement>[]
        ..sort((siteA, siteB) => siteA.site.name
            .toLowerCase()
            .compareTo(siteB.site.name.toLowerCase()));
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return <Measurement>[];
    }
  }

  Future<Measurement?> getMeasurement(String siteId) async {
    try {
      final db = await database;

      var res = await db.query(Measurement.measurementsDb(),
          where: 'id = ?', whereArgs: [siteId]);

      if (res.isEmpty) {
        return null;
      }
      return Measurement.fromJson(Measurement.mapFromDb(res.first));
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return null;
    }
  }

  Future<List<Measurement>> getMeasurements(List<String> siteIds) async {
    try {
      final db = await database;

      var res = [];

      for (var siteId in siteIds) {
        var siteRes = await db.query(Measurement.measurementsDb(),
            where: 'id = ?', whereArgs: [siteId]);

        res.addAll(siteRes);
      }

      if (res.isEmpty) {
        return [];
      }
      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return Measurement.fromJson(Measurement.mapFromDb(res[i]));
            })
          : <Measurement>[];
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return [];
    }
  }

  Future<Measurement?> getNearestMeasurement(
      double latitude, double longitude) async {
    try {
      Measurement? nearestMeasurement;
      var nearestMeasurements = <Measurement>[];

      double distanceInMeters;

      await getLatestMeasurements().then((measurements) => {
            for (var measurement in measurements)
              {
                distanceInMeters = metersToKmDouble(Geolocator.distanceBetween(
                    measurement.site.latitude,
                    measurement.site.longitude,
                    latitude,
                    longitude)),
                if (distanceInMeters < Config.maxSearchRadius.toDouble())
                  {
                    measurement.site.distance = distanceInMeters,
                    nearestMeasurements.add(measurement)
                  }
              },
            if (nearestMeasurements.isNotEmpty)
              {
                nearestMeasurement = nearestMeasurements.first,
                for (var m in nearestMeasurements)
                  {
                    if (nearestMeasurement!.site.distance > m.site.distance)
                      {nearestMeasurement = m}
                  },
              }
          });

      return nearestMeasurement;
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return null;
    }
  }

  Future<List<Measurement>> getRegionSites(Region region) async {
    try {
      final db = await database;

      var res = await db.query(Measurement.measurementsDb(),
          where: 'region = ?', whereArgs: [region.getName().trim()]);

      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return Measurement.fromJson(Measurement.mapFromDb(res[i]));
            })
          : <Measurement>[];
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return <Measurement>[];
    }
  }

  Future<List<UserNotification>> getUserNotifications() async {
    try {
      final db = await database;

      var res = await db.query(UserNotification.dbName());

      return res.isNotEmpty
          ? List.generate(res.length, (i) {
              return UserNotification.fromJson(res[i]);
            })
          : <UserNotification>[]
        ..sort(
            (x, y) => DateTime.parse(x.time).compareTo(DateTime.parse(y.time)));
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
      return <UserNotification>[];
    }
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), Config.dbName),
      version: 1,
      onCreate: (db, version) {
        createDefaultTables(db);
      },
      // onUpgrade: (db, oldVersion, newVersion){
      //   createDefaultTables(db);
      // },
    );
  }

  Future<void> insertFavPlace(PlaceDetails placeDetails) async {
    try {
      final db = await database;

      try {
        var jsonData = placeDetails.toJson();
        await db.insert(
          PlaceDetails.dbName(),
          jsonData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (exception, stackTrace) {
        debugPrint('$exception\n$stackTrace');
      }
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> insertInsights(List<Insights> insights, List<String> siteIds,
      {bool reloadDatabase = false}) async {
    try {
      final db = await database;

      if (insights.isEmpty) {
        return;
      }
      var batch = db.batch();

      if (reloadDatabase) {
        batch.delete(Insights.dbName());
      } else {
        for (var siteId in siteIds) {
          batch.delete(Insights.dbName(),
              where: 'siteId = ?', whereArgs: [siteId]);
        }
      }

      for (var row in insights) {
        try {
          var jsonData = row.toJson();
          batch.insert(Insights.dbName(), jsonData,
              conflictAlgorithm: ConflictAlgorithm.replace);
        } catch (exception, stackTrace) {
          debugPrint('$exception\n$stackTrace');
        }
      }
      await batch.commit(noResult: true, continueOnError: true);
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> insertKyas(List<Kya> kyas) async {
    try {
      final db = await database;

      if (kyas.isEmpty) {
        return;
      }
      var batch = db.batch()..delete(Kya.dbName());

      for (var kya in kyas) {
        try {
          var kyaJson = kya.parseKyaToDb();
          for (var jsonBody in kyaJson) {
            batch.insert(
              Kya.dbName(),
              jsonBody,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        } catch (exception, stackTrace) {
          debugPrint('$exception\n$stackTrace');
        }
      }
      await batch.commit(noResult: true, continueOnError: true);
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> insertLatestMeasurements(List<Measurement> measurements) async {
    try {
      final db = await database;

      var batch = db.batch();

      if (measurements.isNotEmpty) {
        batch.delete(Measurement.measurementsDb());

        for (var measurement in measurements) {
          try {
            var jsonData = Measurement.mapToDb(measurement);
            batch.insert(
              Measurement.measurementsDb(),
              jsonData,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          } catch (exception, stackTrace) {
            debugPrint('$exception\n$stackTrace');
          }
        }

        await batch.commit(noResult: true, continueOnError: true);
      }
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> insertUserNotifications(
      List<UserNotification> notifications, BuildContext context) async {
    try {
      final db = await database;

      if (notifications.isEmpty) {
        return;
      }

      var batch = db.batch()..delete(UserNotification.dbName());

      for (var notification in notifications) {
        var jsonData = notification.toJson();
        batch.insert(
          UserNotification.dbName(),
          jsonData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true, continueOnError: true);
      Provider.of<NotificationModel>(context, listen: false)
          .addAll(notifications);
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> removeFavPlace(PlaceDetails placeDetails) async {
    try {
      final db = await database;

      try {
        await db.delete(
          PlaceDetails.dbName(),
          where: 'placeId = ?',
          whereArgs: [placeDetails.placeId],
        );
      } catch (exception, stackTrace) {
        debugPrint('$exception\n$stackTrace');
      }
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> setFavouritePlaces(List<PlaceDetails> placeDetails) async {
    try {
      final db = await database;

      if (placeDetails.isNotEmpty) {
        var batch = db.batch()..delete(PlaceDetails.dbName());

        for (var place in placeDetails) {
          try {
            var jsonData = place.toJson();
            batch.insert(
              PlaceDetails.dbName(),
              jsonData,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          } catch (exception, stackTrace) {
            debugPrint('$exception\n$stackTrace');
          }
        }
        await batch.commit(noResult: true, continueOnError: true);
      }
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<bool> updateFavouritePlace(PlaceDetails placeDetails) async {
    final db = await database;

    var res = await db.query(PlaceDetails.dbName(),
        where: 'placeId = ?', whereArgs: [placeDetails.placeId]);

    if (res.isEmpty) {
      await insertFavPlace(placeDetails);
      return true;
    } else {
      await removeFavPlace(placeDetails);
      return false;
    }
  }

  Future<bool> updateFavouritePlacesDetails(
      List<PlaceDetails> placesDetails) async {
    final db = await database;
    var batch = db.batch();
    try {
      for (var favPlace in placesDetails) {
        batch.update(PlaceDetails.dbName(), {'siteId': favPlace.siteId},
            where: 'placeId = ?', whereArgs: [favPlace.placeId]);
      }
      await batch.commit(continueOnError: true, noResult: true);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> updateKya(Kya kya) async {
    final db = await database;

    await db.update(Kya.dbName(), {'progress': kya.progress},
        where: 'id = ?', whereArgs: [kya.id]);
  }
}

class SharedPreferencesHelper {
  SharedPreferences? _sharedPreferences;

  Future<void> clearPreferences() async {
    if (_sharedPreferences == null) {
      await initialize();
    }
    if (_sharedPreferences!.containsKey('notifications')) {
      await _sharedPreferences!.remove('notifications');
    }
    if (_sharedPreferences!.containsKey('aqShares')) {
      await _sharedPreferences!.remove('aqShares');
    }
    if (_sharedPreferences!.containsKey('location')) {
      await _sharedPreferences!.remove('location');
    }
    if (_sharedPreferences!.containsKey('alerts')) {
      await _sharedPreferences!.remove('alerts');
    }
  }

  Future<String> getOnBoardingPage() async {
    if (_sharedPreferences == null) {
      await initialize();
    }
    var page =
        _sharedPreferences!.getString(Config.prefOnBoardingPage) ?? 'welcome';

    return page;
  }

  Future<UserPreferences> getPreferences() async {
    if (_sharedPreferences == null) {
      await initialize();
    }
    var notifications = _sharedPreferences!.getBool('notifications') ?? false;
    var location = _sharedPreferences!.getBool('location') ?? false;
    var alerts = _sharedPreferences!.getBool('alerts') ?? false;
    var aqShares = _sharedPreferences!.getInt('aqShares') ?? 0;

    return UserPreferences(notifications, location, alerts, aqShares);
  }

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> updateOnBoardingPage(OnBoardingPage currentBoardingPage) async {
    if (_sharedPreferences == null) {
      await initialize();
    }
    await _sharedPreferences!
        .setString(Config.prefOnBoardingPage, currentBoardingPage.getName());
  }

  Future<void> updatePreference(String key, dynamic value, String type) async {
    try {
      if (_sharedPreferences == null) {
        await initialize();
      }
      if (type == 'bool') {
        await _sharedPreferences!.setBool(key, value);
      } else if (type == 'double') {
        await _sharedPreferences!.setDouble(key, value);
      } else if (type == 'int') {
        await _sharedPreferences!.setInt(key, value);
      } else {
        await _sharedPreferences!.setString(key, value);
      }
    } catch (exception, stackTrace) {
      debugPrint('$exception\n$stackTrace');
    }
  }

  Future<void> updatePreferences(UserPreferences userPreferences) async {
    if (_sharedPreferences == null) {
      await initialize();
    }
    await _sharedPreferences!
        .setBool('notifications', userPreferences.notifications);
    await _sharedPreferences!.setBool('location', userPreferences.location);
    await _sharedPreferences!.setBool('alerts', userPreferences.alerts);
    await _sharedPreferences!.setInt('aqShares', userPreferences.aqShares);
  }
}
