import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Location.dart';
import '../models/POI.dart';
import 'POIDetails.dart';


class POIPage extends StatefulWidget {
  const POIPage({super.key, required this.title});
  static const String routeName = '/POIPage';
  final String title;

  @override
  _PoiPageState createState() => _PoiPageState();
}

class _PoiPageState extends State<POIPage> {
  late Stream<List<POI>> PoiStream;
  bool orderByDistance = false;
  Map<String, dynamic>? allSharedPreferences;
  bool orderByAlphabetic = false;

  Future<Map<String, dynamic>> loadAllSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().fold<Map<String, dynamic>>(
        {},
            (Map<String, dynamic> accumulator, String key) {
          accumulator[key] = prefs.get(key);
          return accumulator;
        }
    );
  }


  Future<void> loadSharedPreferences() async {
    Map<String, dynamic> sharedPreferences = await loadAllSharedPreferences();
    setState(() {
      allSharedPreferences = sharedPreferences;
    });
  }

  /*int getDistance(Location location) {
    var _locationData =  location.getLocation();
    return 0;
  }*/

  void setSharedPreferences(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {

      await prefs.setString(key, value);
      allSharedPreferences?.clear();
      loadSharedPreferences();

    } else if (value is int) {

      await prefs.setInt(key, value);
      allSharedPreferences?.clear();
      loadSharedPreferences();

    }
  }

  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  Future<List<POI>> readPoiFromFirebase(String docName) async {
    List<POI> response = [];
    QuerySnapshot querySnapshot;
    var db = FirebaseFirestore.instance;

    try {
      querySnapshot = await db.collection('locations').doc(docName).collection('pointsOfInterest').get();

      querySnapshot.docs.forEach((document) {

        POI poi = POI(
          document.get('id') ?? '',
          document.get('name') ?? '',
          (document.get('latitude') ?? 0.0).toDouble(),
          (document.get('longitude') ?? 0.0).toDouble(),
          document.get('description') ?? '',
          document.get('photoUrl') ?? '',
          (document.get('likes') ?? 0).toInt(),
          (document.get('dislikes') ?? 0).toInt(),
          document.get('createdBy') ?? '',
          (document.get('grade') ?? 0.0).toDouble(),
          document.get('category') ?? '',
          document.get('locationId') ?? '',
        );
        response.add(poi);
      });
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching locations');
    }
    return response;
  }
  Stream<List<POI>> getPoiStream(String docName) async* {
    while (true) {
      try {
        final poi = await readPoiFromFirebase(docName);
        yield poi;
        await Future.delayed(Duration(
            seconds: 5));
      } catch (e) {
        print('Error fetching locations: $e');
        yield <POI>[];
        await Future.delayed(
            Duration(seconds: 5));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Location location = args['location'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF02458A),
        title: Text(
          location.name,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              // Vai para a página de consultar últimas 10 pesquisas
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(),
          Text(
            'Order by',
            style: TextStyle(
              fontSize: 18,

            ),
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: Text('Distance'),
                  value: orderByDistance,
                  onChanged: (value) {
                    setState(() {
                      orderByDistance = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: Text('Name'),
                  value: orderByAlphabetic,
                  onChanged: (value) {
                    setState(() {
                      orderByAlphabetic = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Divider(), // Adiciona um Divider abaixo da Row
          StreamBuilder<List<POI>>(
            stream: getPoiStream(location.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(snapshot.data![index].name),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context,
                                      POIDetailPage.routeName,
                                      arguments: {
                                        'location': location,
                                        'poi': snapshot.data![index],
                                        'changePoiGradeFunction': setSharedPreferences,
                                        'initialPoiGradeValue': allSharedPreferences?[snapshot.data![index].id] as int? ?? -1,
                                      }
                                  );
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },

          ),
        ],
      ),
    );
  }
}