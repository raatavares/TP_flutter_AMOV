import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/Local.dart';

class LocationDetailPage extends StatefulWidget {
  static const String routeName = '/locationDetail';

  const LocationDetailPage({super.key});

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  String? _error;
  Color likeButtonColor = Colors.grey;
  int initialLocationGradeValue = 0;
  bool isLiked = false;

  void incrementeLikes(String docName, bool dec) async {
    var db = FirebaseFirestore.instance;
    var document = db.collection('locations').doc(docName);
    var data = await document.get(const GetOptions(source: Source.server));
    if (data.exists) {
      var values = data['likes'] + 1;
      document.update({'likes': values}).then(
              (res) => setState(() { _error = null; }),
          onError: (e) => setState(() { _error = e.toString();})
      );
      if(dec){
        var values = data['dislikes'] - 1;
        if(values >= 0){
          document.update({'dislikes': values}).then(
                  (res) => setState(() { _error = null; }),
              onError: (e) => setState(() { _error = e.toString();})
          );
        }
      }

    } else {
      setState(() { _error = "Document doesn't exist";});
    }
  }

  void incrementeDislikes(String docName, bool dec) async {
    var db = FirebaseFirestore.instance;
    var document = db.collection('locations').doc(docName);
    var data = await document.get(const GetOptions(source: Source.server));
    if (data.exists) {
      var values = data['dislikes'] + 1;
      document.update({'dislikes': values}).then(
              (res) => setState(() { _error = null; }),
          onError: (e) => setState(() { _error = e.toString();})
      );
      if(dec){
        var values = data['likes'] - 1;
        if(values >= 0) {
          document.update({'likes': values}).then(
                  (res) =>
                  setState(() {
                    _error = null;
                  }),
              onError: (e) =>
                  setState(() {
                    _error = e.toString();
                  })
          );
        }
      }

    } else {
      setState(() { _error = "Document doesn't exist";});
    }
  }


  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Local location = args['location'];
    Function(String, int) changeLocationGradeFunction = args['changeLocationGradeFunction'];
    dynamic initialLocationGradeValue = args['initialLocationGradeValue'];
    if(initialLocationGradeValue == 1) {
      isLiked = true;
    } else if(initialLocationGradeValue == 2) {
      isLiked = false;
    }
    final storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(location.photoUrl!);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              location.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<String>(
            future: ref.getDownloadURL(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading image'));
              } else if (snapshot.hasData) {
                return SizedBox(
                  height: 200, // Defina a altura da imagem
                  width: double.infinity,
                  child: Image.network(
                    snapshot.data!,
                    fit: BoxFit.scaleDown,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Divider(),
          ),
          initialLocationGradeValue == 1 || initialLocationGradeValue == 2
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                      if(!isLiked) {
                        setState(() {
                          changeLocationGradeFunction(location.id, 1);
                          incrementeLikes(location.id, true);
                          isLiked = true;
                        });
                        showRatingChangedDialog(context);
                      }
                  },
                  icon: const Icon(Icons.thumb_up),
                  color: isLiked ? const Color(0xFF02458A) : Colors.grey,
                  iconSize: 56.0,
                ),
                const SizedBox(width: 16.0),
                Column(
                  children: [
                    Text('Likes: ${location.likes}   ', style: const TextStyle(fontSize: 16)),
                    Text('Dislikes: ${location.dislikes}   ', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  onPressed: () {
                    if(isLiked) {
                      setState(() {
                        changeLocationGradeFunction(location.id, 2);
                        incrementeDislikes(location.id, true);
                        isLiked = false;
                      });
                      showRatingChangedDialog(context);
                    }
                  },
                  color: !isLiked ? const Color(0xFF02458A) : Colors.grey,
                  icon: const Icon(Icons.thumb_down),
                  iconSize: 56.0,
                ),
              ],
            ),

          ): Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (!isLiked) {
                      setState(() {
                        changeLocationGradeFunction(location.id, 1);
                        incrementeLikes(location.id, true);
                        isLiked = true;
                      });
                      showRatingChangedDialog(context);
                    }
                  },
                  icon: const Icon(Icons.thumb_up),
                  color: Colors.grey,
                  iconSize: 56.0,
                ),
                const SizedBox(width: 16.0),
                Column(
                  children: [
                    Text('Likes: ${location.likes}', style: const TextStyle(fontSize: 16)),
                    Text('Dislikes: ${location.dislikes}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      changeLocationGradeFunction(location.id, 2);
                      incrementeDislikes(location.id, false);
                      isLiked = false;
                    });
                    showRatingChangedDialog(context);
                  },
                  icon: const Icon(Icons.thumb_down),
                  color: Colors.grey,
                  iconSize: 56.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    location.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Category:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    location.category!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 10),
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Created by: ${location.createdBy!}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void showRatingChangedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Rate changed!'),
        content: const Text('Rate changed with success'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
