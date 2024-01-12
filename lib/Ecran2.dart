import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Capital.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
class Ecran2 extends StatefulWidget {
  @override
  _Ecran2State createState() => _Ecran2State();
}

class _Ecran2State extends State<Ecran2> {
  List<Capital> capitals = [];

  @override
  void initState() {
    super.initState();
    // Charger les données du fichier JSON au démarrage
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {

     // Charger les données du fichier JSON
     String jsonString = await rootBundle.loadString('assets/Capital.json');
     Map<String, dynamic> data = json.decode(jsonString);
     print(data);
     if (!data.isEmpty) {
       setState(() {
         capitals = (data['capitals'] as List)
             .map((data) => Capital.fromJson(data))
             .toList();
       });
     }


    } catch (e) {
      print('Erreur lors du chargement du fichier JSON : $e');

    }
  }

/*  Future<void> saveJsonData(List<Capital> capital) async {
    try {
      // Enregistrer les données dans le fichier JSON
      String path="assets/Capital.json";
      setState(() {
    File(path).writeAsStringSync(json.encode({'capitals': capital}));
      });

    } catch (e) {
      print('Erreur saveJsonData de l\'enregistrement du fichier JSON : $e');
    }
  }*/
  Future<void> saveJsonData() async {
    try {
      // Obtenir le répertoire de documents de l'application
      final directory = await getApplicationDocumentsDirectory();

      final filePath = p.join(directory.path, 'Capital.json');
      final file = File(filePath);
      print("file"+file.toString());

      // Vérifier si le fichier existe
      if (!await file.exists()) {
        // S'il n'existe pas, le créer avec une structure JSON initiale
        await file.create(recursive: true);
        await file.writeAsString(json.encode({'capitals': []}));
      }

      // Enregistrer les données dans le fichier JSON
      await file.writeAsString(json.encode({'capitals': capitals}));
      print("bieeeeeeeeeeeeeennnnnnnnnnnnnnn"+capitals.toString());
    } catch (e) {
      print('Erreur saveJsonData de l\'enregistrement du fichier JSON : $e');
    }
  }
  Future<void> showAddCapitalPopup() async {

    TextEditingController nameController = TextEditingController();
    TextEditingController countryController = TextEditingController();
    TextEditingController populationController = TextEditingController();
    TextEditingController latController = TextEditingController();
    TextEditingController lngController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une capitale'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Pays'),
                ),
                TextField(
                  controller: populationController,
                  decoration: InputDecoration(labelText: 'Population'),
                ),
                TextField(
                  controller: latController,
                  decoration: InputDecoration(labelText: 'Latitude'),
                ),
                TextField(
                  controller: lngController,
                  decoration: InputDecoration(labelText: 'Longitude'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Ajoutez la nouvelle capitale à la liste et sauvegardez dans le fichier JSON
                Capital newCapital = Capital(
                  name: nameController.text,
                  country: countryController.text,
                  population: populationController.text,
                  lat: double.parse(latController.text),
                  lng: double.parse(lngController.text),
                );
        setState(() {
                capitals.add(newCapital);
                print(capitals);
        });

                saveJsonData();
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteCapitalPopup() async {
    loadJsonData();
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer une capitale'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nom de la capitale'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Supprimez la capitale de la liste et sauvegardez dans le fichier JSON
                setState(() {
                capitals.removeWhere((capital) => capital.name == nameController.text);
                });
                saveJsonData();
                Navigator.pop(context);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditCapitalPopup(String capitalName) async {
    Capital? selectedCapital = capitals.firstWhere((capital) => capital.name == capitalName, orElse: () => capitals[0]);

    if (selectedCapital == Null) {
      return;
    }

    TextEditingController countryController = TextEditingController(text: selectedCapital.country);
    TextEditingController populationController = TextEditingController(text: selectedCapital.population);
    TextEditingController latController = TextEditingController(text: selectedCapital.lat.toString());
    TextEditingController lngController = TextEditingController(text: selectedCapital.lng.toString());

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier une capitale'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Nom: $capitalName'),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Pays'),
                ),
                TextField(
                  controller: populationController,
                  decoration: InputDecoration(labelText: 'Population'),
                ),
                TextField(
                  controller: latController,
                  decoration: InputDecoration(labelText: 'Latitude'),
                ),
                TextField(
                  controller: lngController,
                  decoration: InputDecoration(labelText: 'Longitude'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Mettez à jour les informations de la capitale et sauvegardez dans le fichier JSON
                setState(() {
                selectedCapital.country = countryController.text;
                selectedCapital.population = populationController.text;
                selectedCapital.lat = double.parse(latController.text);
                selectedCapital.lng = double.parse(lngController.text);
                });
                saveJsonData();
                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Capitales'),
      ),
      body: ListView.builder(
        itemCount: capitals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(capitals[index].name),
            subtitle: Text('Population: ${capitals[index].population}'),
            onTap: () {
              showEditCapitalPopup(capitals[index].name);
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: showAddCapitalPopup,
              child: Text('Ajouter'),
            ),
            ElevatedButton(
              onPressed: showDeleteCapitalPopup,
              child: Text('Supprimer'),
            ),
            ElevatedButton(
              onPressed: () {
                loadJsonData();
              },
              child: Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}

class CityDetailScreen extends StatefulWidget {
  final Capital capital;

  CityDetailScreen({required this.capital});

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.capital.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Country: ${widget.capital.country}'),
            Text('Population: ${widget.capital.population}'),
            // Ajoutez les autres informations de la capitale
          ],
        ),
      ),
    );
  }
}