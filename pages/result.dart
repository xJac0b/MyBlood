import 'package:flutter/material.dart';
import 'custom_page_route.dart';
import 'add.dart';

class Trio<T1, T2, T3> {
  final T1 a;
  final T2 b;
  final T3 c;
  Trio(this.a, this.b, this.c);
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;
  Pair(this.a, this.b);
}

class ResultPage extends StatefulWidget {
  Map<String, dynamic> data;

  ResultPage(this.data, {Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Widget> fields = [];
  bool verify = false;
  Map<String, Pair<Pair<double, double>, Pair<double, double>>> results = {
    "Leukocyty/WBC": Pair(Pair(4.0, 10.0), Pair(4.0, 10.0)),
    "Hemoglobina/HGB": Pair(Pair(14.0, 18.0), Pair(12.0, 16.0)),
    "MCV": Pair(Pair(77.0, 95.0), Pair(77.0, 95.0)),
    "MCHC": Pair(Pair(32.0, 36.0), Pair(32.0, 36.0)),
    "RDW-SD": Pair(Pair(37.0, 54.0), Pair(37.0, 54.0)),
    "PDW": Pair(Pair(9.2, 16.8), Pair(9.2, 16.8)),
    "P-LCR": Pair(Pair(13.0, 43.0), Pair(13.0, 43.0)),
    "Neutrofile/NEUT#": Pair(Pair(2.5, 5.0), Pair(2.5, 5.0)),
    "Limfocyty/LYMPH#": Pair(Pair(1.5, 3.5), Pair(1.5, 3.5)),
    "Monocyty/MONO#": Pair(Pair(0.2, 0.8), Pair(0.2, 0.8)),
    "Eoznofile/EO#": Pair(Pair(0.04, 0.4), Pair(0.04, 0.4)),
    "IG#": Pair(Pair(0.00, 0.03), Pair(0.00, 0.04)),
    "Bazofile/BASO#": Pair(Pair(0.02, 0.10), Pair(0.02, 0.10)),
    "NRBC#": Pair(Pair(0.000, 0.014), Pair(0.000, 0.015)),
    "Erytrocyty/RBC": Pair(Pair(4.10, 6.20), Pair(3.70, 5.10)),
    "Hematokryt/HCT": Pair(Pair(40.0, 54.0), Pair(37.0, 47.0)),
    "MCH": Pair(Pair(27.0, 34.0), Pair(27.0, 34.0)),
    "Płytki Krwi/PLT": Pair(Pair(150.0, 450.0), Pair(150.0, 450.0)),
    "RDW-CV": Pair(Pair(11.2, 14.1), Pair(11.2, 14.1)),
    "MPV": Pair(Pair(9.0, 12.6), Pair(9.0, 12.6)),
    "PCT": Pair(Pair(0.16, 0.34), Pair(0.16, 0.34)),
    "Neutrofile/NEUT%": Pair(Pair(45.0, 70.0), Pair(45.0, 70.0)),
    "Limfocyty/LYMPH%": Pair(Pair(20.0, 45.0), Pair(20.0, 45.0)),
    "Monocyty/MONO%": Pair(Pair(4.0, 10.0), Pair(4.0, 10.0)),
    "Eozynofile/EO%": Pair(Pair(1.0, 5.0), Pair(1.0, 5.0)),
    "IG%": Pair(Pair(0.0, 0.61), Pair(0.0, 0.61)),
    "Bazofile/BASO%":
        Pair(Pair(double.minPositive, 1.0), Pair(double.minPositive, 1.0)),
    "NRBC%": Pair(Pair(0.000, 0.026), Pair(0.000, 0.026)),
  };

  void _verify() {
    setState(() {
      verify = !verify;
    });
  }

  @override
  Widget build(BuildContext context) {
    fields = [
      Icon(
        widget.data['sex'] == 'M' ? Icons.male : Icons.female,
        color: Colors.green,
        size: 30.0,
      )
    ];
    fields.add(Padding(
        padding: EdgeInsets.only(left: 8.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          widget.data['name'] != ""
              ? Text("Badanie: " + widget.data['name'],
                  style: const TextStyle(fontSize: 25))
              : SizedBox(),
          Text(
              "Data: " +
                  widget.data['date']
                      .substring(0, widget.data['date'].indexOf(' ')),
              style: const TextStyle(fontSize: 25)),
        ])));
    fields.add(SizedBox(height: 20));
    widget.data.forEach((k, v) {
      if (k != 'name' && k != 'date' && k != 'id' && v != null && k != 'sex') {
        fields.add(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                SizedBox(width: 8),
                Text(k + ": ",
                    style: TextStyle(
                      fontSize: 20,
                      color: (verify
                          ? (widget.data['sex'] == 'M'
                              ? (v >= results[k]?.a.a && v <= results[k]?.a.b
                                  ? Colors.green
                                  : Colors.red)
                              : (v >= results[k]?.b.a && v <= results[k]?.b.b
                                  ? Colors.green
                                  : Colors.red))
                          : (Theme.of(context).colorScheme.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black)),
                      fontWeight: FontWeight.bold,
                    )),
                Text(v.toString(), style: TextStyle(fontSize: 20)),
                Text(
                    (verify
                        ? (widget.data['sex'] == 'M'
                            ? (" (" +
                                    results[k]!.a.a.toString() +
                                    " - " +
                                    results[k]!.a.b.toString()) +
                                ")"
                            : (" (" +
                                    results[k]!.b.a.toString() +
                                    " - " +
                                    results[k]!.b.b.toString()) +
                                ")")
                        : ""),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ))
              ]),
              const SizedBox(height: 6),
              Divider(color: Color.fromRGBO(100, 100, 100, 1.0), height: 1),
              const SizedBox(height: 6),
            ]));
      }
    });

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Wyniki"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .push(CustomPageRoute(child: AddPage(dataa: widget.data))),
            ),
            IconButton(
              icon: verify ? Icon(Icons.remove) : Icon(Icons.verified),
              onPressed: _verify,
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: fields)));
  }
}
