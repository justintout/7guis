import 'package:flutter/material.dart';

class CrudPage extends StatefulWidget {
  CrudPage({Key key}) : super(key: key);

  final title = "Counter";
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {

  Key _formKey = GlobalKey<FormState>();
  String filterPrefix = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  List<_Entry> entries = [_Entry("Hans", "Emil"), _Entry("Max", "Mustermann"), _Entry("Roman", "Tisch")];
  List<_Entry> get filteredEntries {
    if (filterPrefix == "") {
      return entries;
    }
    return entries.where((e) => e.surname.startsWith(filterPrefix)).toList();
  }
  int selectedIndex;

  @override
  Widget build(BuildContext context) {

    _nameController.text = selectedIndex == null
       ? ""
       : entries[selectedIndex].name;
      
    _surnameController.text = selectedIndex == null 
      ? ""
      : entries[selectedIndex].surname;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("Filter prefix:"),
                      Flexible(
                        child: TextField(
                          maxLines: 1,
                          onChanged: (v) {
                            debugPrint(v);
                            setState(() {
                              filterPrefix = v;
                            });
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              Flexible(
                flex: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [            
                    Flexible(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: filteredEntries.length,
                            itemBuilder: (_, i) {
                              return ListTile(
                                title: Text("${entries[i].surname}, ${entries[i].name}"),
                                selected: i == selectedIndex,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ),    
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Name"
                            ),
                            controller: _nameController
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Surname"
                            ),
                            controller: _surnameController
                          )
                        ]
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Flexible(
                flex: 5,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text("Create"),
                        onPressed: create
                      ),
                      ElevatedButton(
                        child: Text("Update"),
                        onPressed: selectedIndex == null
                          ? null 
                          : update,
                      ),
                      ElevatedButton(
                        child: Text("Delete"),
                        onPressed: selectedIndex == null 
                          ? null
                          : delete
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  create() {
    setState(() {  
      entries.add(_Entry(_nameController.text, _surnameController.text));
    });
    _nameController.clear();
    _surnameController.clear();
  }

  update() {
    setState(() {
      entries[selectedIndex]
        ..name = _nameController.text
        ..surname = _surnameController.text;
      selectedIndex = null;
    });
  }

  delete() {
    setState(() {
      entries.removeAt(selectedIndex);
      selectedIndex = null;
    });
  }

}

class _Entry {
  String name, surname;

  _Entry(this.name, this.surname);

  Widget get tile {
    return ListTile(
      title: Text("$surname, $name"),
      onTap: () {
        
      }
    );
  }
}