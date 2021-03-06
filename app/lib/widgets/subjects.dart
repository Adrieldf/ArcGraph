import 'package:ArcGraph/models/evaluations/competence.dart';
import 'package:ArcGraph/models/evaluations/dimensionToEvaluate.dart';
import 'package:ArcGraph/models/evaluations/hability.dart';
import 'package:ArcGraph/models/files/fileHandler.dart';
import 'package:ArcGraph/widgets/hability_view.dart';
import 'package:ArcGraph/widgets/new_competence.dart';
// import 'package:ArcGraph/models/files/fileHandlerWeb.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class Subjects extends StatefulWidget {
  Function addNewSubject;

  Subjects(this.addNewSubject);

  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final FileHandler fileHandler = new FileHandler();

  final competences = new List<Competence>();

  final codeController = TextEditingController();
  final disciplineController = TextEditingController();
  final descriptionController = TextEditingController();
  final hourController = TextEditingController();
  final locationController = TextEditingController();

  bool codeFieldContainsError = false;
  bool disciplineFieldContainsError = false;
  bool descriptionFieldContainsError = false;
  bool hourFieldContainsError = false;
  bool locationFieldContainsError = false;

  void submitData() {
    setState(() {
      codeFieldContainsError = codeController.text.isEmpty;
      disciplineFieldContainsError = disciplineController.text.isEmpty;
      descriptionFieldContainsError = descriptionController.text.isEmpty;
      hourFieldContainsError = hourController.text.isEmpty;
      locationFieldContainsError = locationController.text.isEmpty;
    });

    if (codeController.text.isEmpty ||
        disciplineController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        hourController.text.isEmpty ||
        locationController.text.isEmpty) return;

    if (competences.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deve haver competências cadastradas."),
          );
        },
      );
      return;
    }

    final subject = Subject(
      disciplineController.text,
      disciplineController.text,
      "",
    );

    subject.location = locationController.text;
    subject.time = hourController.text;
    subject.competences = competences;

    widget.addNewSubject(subject);

    Navigator.of(context).pop();
  }

  void addNewCompetence(
    String name,
    List<Hability> habilities,
  ) {
    final competence = new Competence(
      name,
      habilities,
    );

    setState(() {
      competences.add(competence);
    });
  }

  void startAddNewCompetence(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return GestureDetector(
          onTap: () {},
          child: NewCompetence.function(addNewCompetence),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void startEditCompetence(
    BuildContext context,
    Competence competence,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return GestureDetector(
          onTap: () {},
          child: NewCompetence.competence(competence),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void importSubject() {
    fileHandler.import().then(
          (Subject subject) => {
            if (subject != null)
              {
                codeController.text = subject.register,
                disciplineController.text = subject.name,
                descriptionController.text = subject.name,
                hourController.text = subject.time,
                locationController.text = subject.location,
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disciplinas'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Importar csv:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () => importSubject(),
                        child: Icon(
                          Icons.search,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 6,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Disciplina",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withAlpha(200),
                        thickness: 1,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Código:',
                            errorText: codeFieldContainsError ? '!' : null),
                        controller: codeController,
                        onChanged: (value) {
                          setState(() {
                            codeFieldContainsError = value.isEmpty;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Disciplina:',
                            errorText:
                                disciplineFieldContainsError ? '!' : null),
                        controller: disciplineController,
                        onChanged: (value) {
                          setState(() {
                            disciplineFieldContainsError = value.isEmpty;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Descrição:',
                            errorText:
                                descriptionFieldContainsError ? '!' : null),
                        controller: descriptionController,
                        onChanged: (value) {
                          setState(() {
                            descriptionFieldContainsError = value.isEmpty;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Horário:',
                            errorText: hourFieldContainsError ? '!' : null),
                        controller: hourController,
                        onChanged: (value) {
                          setState(() {
                            hourFieldContainsError = value.isEmpty;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Local:',
                            errorText: locationFieldContainsError ? '!' : null),
                        controller: locationController,
                        onChanged: (value) {
                          setState(() {
                            locationFieldContainsError = value.isEmpty;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Competências",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withAlpha(200),
                        thickness: 1,
                      ),
                      Container(
                        child: competences.isEmpty
                            ? Text("Nenhuma competência cadastrada.")
                            : Column(
                                children: competences
                                    .map((competence) => GestureDetector(
                                          onLongPress: () =>
                                              startEditCompetence(
                                            context,
                                            competence,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    startEditCompetence(
                                                      context,
                                                      competence,
                                                    );
                                                  }),
                                              Text(
                                                competence.name,
                                              ),
                                              Spacer(flex: 2),
                                              IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      competences
                                                          .remove(competence);
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            shape: CircleBorder(),
                            onPressed: () => startAddNewCompetence(context),
                            child: Icon(
                              Icons.add,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => submitData(),
        label: Text("Finalizar"),
      ),
    );
  }
}
