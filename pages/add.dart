import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'database_helper.dart';
import 'package:ft1/pages/custom_page_route.dart';
import 'history.dart';

Map<String, dynamic> data = {};

class AddPage extends StatefulWidget {
  final Map<String, dynamic> dataa;

  AddPage({required this.dataa, Key? key}) {
    key = key;
    data = dataa;
  }
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  String? _entryName = "";
  String dropdownvalue = data['sex'] == 'F' ? "Kobieta" : "Mężczyzna";
  List<String> dropdownitems = ['Mężczyzna', 'Kobieta'];
  Map<String, double> results = {
    "Leukocyty/WBC": 0.0,
    "Hemoglobina/HGB": 0.0,
    "MCV": 0.0,
    "MCHC": 0.0,
    "RDW-SD": 0.0,
    "PDW": 0.0,
    "P-LCR": 0.0,
    "Neutrofile/NEUT#": 0.0,
    "Limfocyty/LYMPH#": 0.0,
    "Monocyty/MONO#": 0.0,
    "Eoznofile/EO#": 0.0,
    "IG#": 0.0,
    "Bazofile/BASO#": 0.0,
    "NRBC#": 0.0,
    "Erytrocyty/RBC": 0.0,
    "Hematokryt/HCT": 0.0,
    "MCH": 0.0,
    "Płytki Krwi/PLT": 0.0,
    "RDW-CV": 0.0,
    "MPV": 0.0,
    "PCT": 0.0,
    "Neutrofile/NEUT%": 0.0,
    "Limfocyty/LYMPH%": 0.0,
    "Monocyty/MONO%": 0.0,
    "Eozynofile/EO%": 0.0,
    "IG%": 0.0,
    "Bazofile/BASO%": 0.0,
    "NRBC%": 0.0,
  };
  String? _validate(value) {
    if (value == null) {
      return 'Required!';
    }
    if (value.isNotEmpty &&
        double.tryParse(value
                .replaceAll(',', '.')
                .replaceAll(' ', '')
                .replaceAll('-', '')) ==
            null) {
      return 'Enter a number!';
    }
  }

  void _save() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _entryName,
      DatabaseHelper.columnDate: _dateTime.toString(),
      DatabaseHelper.columnSex: (dropdownvalue[0] == 'M' ? 'M' : 'F'),
    };
    results.forEach((k, v) {
      row["`" + k + "`"] = v;
    });
    DatabaseHelper helper = DatabaseHelper.instance;
    if (data['date'] == null) {
      await helper.insert(row);
    } else {
      row[DatabaseHelper.columnId] = data['id'];
      await helper.update(row);
      print(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var fields1 = <SizedBox>[];
    var fields2 = <SizedBox>[];
    int counter = 0;
    results.forEach((k, v) {
      counter++;
      if (counter < 15) {
        fields1.add(SizedBox(
            width: 180,
            child: TextFormField(
                initialValue: data[k] != null ? data[k].toString() : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: k),
                validator: _validate,
                onSaved: (value) {
                  if (value!.isNotEmpty) {
                    results[k] = double.parse(value
                        .toString()
                        .replaceAll(',', '.')
                        .replaceAll(' ', '')
                        .replaceAll('-', ''));
                  } else {
                    results.remove(k);
                  }
                },
                style: const TextStyle(
                  fontSize: 20.0,
                ))));
      } else {
        fields2.add(SizedBox(
            width: 180,
            child: TextFormField(
                initialValue: data[k] != null ? data[k].toString() : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: k),
                validator: _validate,
                onSaved: (value) {
                  if (value!.isNotEmpty) {
                    results[k] = double.parse(value
                        .toString()
                        .replaceAll(',', '.')
                        .replaceAll(' ', '')
                        .replaceAll('-', ''));
                  } else {
                    results.remove(k);
                  }
                },
                style: const TextStyle(
                  fontSize: 20.0,
                ))));
      }
    });

    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: data == null ? Text("Nowy wpis") : Text("Edycja wpisu"),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: fields1),
                        SizedBox(width: 10),
                        Column(children: fields2)
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 150,
                      child: CupertinoTheme(
                          data: CupertinoThemeData(
                              brightness:
                                  Theme.of(context).colorScheme.brightness),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: (data['date'] == null
                                ? DateTime.now()
                                : DateTime.parse(data['date'])),
                            maximumYear: 2100,
                            minimumYear: 2000,
                            onDateTimeChanged: (DateTime newDateTime) {
                              _dateTime = newDateTime;
                            },
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: dropdownitems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                      SizedBox(
                          width: 180,
                          child: TextFormField(
                              maxLength: 10,
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(labelText: "Tytuł"),
                              style: const TextStyle(
                                fontSize: 25.0,
                              ),
                              initialValue: (data['name'] ?? ""),
                              onSaved: (v) => _entryName = v)),
                    ],
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dodano wpis!')),
                          );
                          _save();
                          Navigator.pop(context);
                          if (data['date'] != null) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context)
                                .push(CustomPageRoute(child: HistoryPage()));
                          }
                        }
                      },
                      child: const Text('Zapisz'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(190, 0, 0, 1),
                        minimumSize: const Size(220, 50),
                      )),
                  const SizedBox(height: 50),
                ]))));
  }
}
