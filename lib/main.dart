import 'package:farm_track/model/insumo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool permissionGranted = false;

  @override
  void initState() {
    iniciaHive();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  late final Box box;
  Future<void> iniciaHive() async {
    // if (permissionGranted) {

    await Hive.initFlutter();
    Hive.registerAdapter(InsumoAdapter());
    box = await Hive.openBox('insumos');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Track',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Farm Track'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: Hive.openBox('insumos'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return _buldInputList();
              }
            } else {
              return const Scaffold();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addInsumo(context);
        },
        tooltip: 'Increment',
        child: const FaIcon(FontAwesomeIcons.plus),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  var boxList = [];
  ListView _buldInputList() {
    boxList = Hive.box('insumos').values.toList();

    return ListView.builder(
      itemCount: boxList.length,
      itemBuilder: (context, index) {
        String product = boxList[index].product ?? " ";
        String insumoDate = boxList[index].inputDate ?? " ";
        String insumoValue = boxList[index].value ?? " ";
        String insumoMesure = boxList[index].mesureType ?? " ";

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: index == 0
                ? const Border() // This will create no border for the first item
                : Border(
                    top: BorderSide(
                        width: 1,
                        color: Theme.of(context)
                            .primaryColor)), // This will create top borders for the rest
          ),
          child: ListTile(
              title: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(insumoValue),
                      const Text("-"),
                      Text(insumoMesure),
                      const Text("-"),
                      Text(product),
                    ],
                  ),
                  Text(
                    insumoDate,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
              leading: const Icon(Icons.event),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteInsum(index);
                      setState(() {
                        boxList = Hive.box('insumos').values.toList();
                      });
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  final _inNames = [
    'Leite',
    'Milho',
    'Algodão',
  ];
  var _inNameinitial = 'Leite';

  final _inMesure = [
    'Litros',
    'Kilos',
    'Gramas',
  ];
  var _inMesureInitial = 'Litros';
  var _iniValue = "0";

  void addInsumo(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Adicionar'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Produto',
                              icon: FaIcon(FontAwesomeIcons.cow),
                            ),
                            value: _inNameinitial,
                            onChanged: (String? newItem) {
                              setState(() {
                                _inNameinitial = newItem ?? "Erro";
                                // print(_inNameinitial);
                              });
                            },
                            onSaved: (String? newItem) {
                              setState(() {
                                _inNameinitial = newItem ?? "Erro";
                                // print(_inNameinitial);
                              });
                            },
                            items: _inNames.map((String eninsumo) {
                              return DropdownMenuItem<String>(
                                  value: eninsumo,
                                  child: Text(eninsumo.toString()));
                            }).toList()),
                        DropdownButtonFormField<String>(
                          value: _inMesureInitial,
                          decoration: const InputDecoration(
                            labelText: 'Medida',
                            icon: FaIcon(FontAwesomeIcons.ruler),
                          ),
                          items: _inMesure.map((String eninsumomes) {
                            return DropdownMenuItem<String>(
                                value: eninsumomes,
                                child: Text(eninsumomes.toString()));
                          }).toList(),
                          onChanged: (String? newItem) {
                            setState(() {
                              _inMesureInitial = newItem ?? "Erro";
                              // print(_inNameinitial);
                            });
                          },
                          onSaved: (String? newItem) {
                            setState(() {
                              _inMesureInitial = newItem ?? "Erro";
                              // print(_inNameinitial);
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Valor',
                            icon: Icon(Icons.numbers),
                          ),
                          validator: (value) {
                            if (value == null || value == '' || value == '0') {
                              return 'Valor Obrigatório';
                            }
                            _iniValue = value;
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState!.validate()) {
                        DateTime now = DateTime.now();
                        Hive.box('insumos').add(Insumo(
                            value: _iniValue,
                            product: _inNameinitial,
                            mesureType: _inMesureInitial,
                            inputDate:
                                DateFormat('dd/MM/yyyy – kk:mm').format(now)));
                        Navigator.pop(context);
                        setState(() {
                          boxList = Hive.box('insumos').values.toList();
                        });
                      }
                    }
                  })
            ],
          );
        });
  }

  Future<void> deleteInsum(int index) async {
    await Hive.box('insumos').deleteAt(index);
  }
}
