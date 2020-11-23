import 'package:flutter/material.dart';
import 'package:main_app/widgets/sideMenu_widget.dart';
import 'package:main_app/controllers/multipleLights_controller.dart';

import 'package:main_app/widgets/desconected_widget.dart';
import 'package:provider/provider.dart';
import 'package:main_app/controllers/connection_controller.dart';

class MultipleLights extends StatefulWidget {
  @override
  _MultipleLightsState createState() => _MultipleLightsState();
}

class _MultipleLightsState extends State<MultipleLights> {
  var controllers = new MultipleLightsController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  _displayDeltePopUp({context, void Function() delete}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF2e2e2e),
            content: Text("Deseja remover o este botão?", style: TextStyle(color: Colors.grey[100])),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 500,
                child: Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        child: new Text('NÃO', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: new Text('SIM', style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          delete();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              )

            ],
          );
        });
  }
  Widget _buildLightButton({String title, bool controller, void Function() onPressed, void Function() onLongPress}){
    return InkResponse(
      onLongPress: () => onLongPress(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text("$title", textAlign: TextAlign.center),
          ),
          RawMaterialButton(
            onPressed: () => {
              onPressed(),
            },
            fillColor: Colors.grey[700],
            child: Icon(
              controller ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 40.0,
              color: Colors.grey[50],
            ),
            padding: EdgeInsets.all(40.0),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFild({TextEditingController controller, String labelText, String hintText}){
    return TextFormField(
      enabled: true,
      validator: (s) {
        if (s.isEmpty)
          return "Digite o nome.";
        else
          return null;
      },
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[100], width: 2),
        ),
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color:  Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color:  Colors.grey[200],
        ),
      ),
      style: TextStyle(color: Colors.grey[300]),
    );
  }

  _buildAddPopUp(context) async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Color(0xFF2e2e2e),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextFild(
                      controller: _titleController,
                      labelText: "Nome da luz",
                      hintText: "Ex: Luz central",
                  ),
                ],
              ),
            ),
            actions: [
             Container(
               width: 500,
               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   FlatButton(
                     child: Text("CANCELAR", style: TextStyle(color: Colors.red, fontSize: 14)),
                     onPressed: ()  {
                       setState(() {
                         _titleController.text = "";
                       });
                       Navigator.of(context).pop();
                     },
                   ),
                   FlatButton(
                     child: new Text('SALVAR', style: TextStyle(color: Colors.blue, fontSize: 14)),
                     onPressed: () {
                       if (_formKey.currentState.validate()) {
                         setState(() {
                           controllers.add(_titleController.text);
                           _titleController.text = "";
                         });
                         Navigator.of(context).pop();
                       }
                     },
                   )
                 ],
               ),
             )
            ],
          );
        }
    );
  }
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool connected = Provider.of<ConnectionController>(context).connected;
    const sizedBoxSpace = SizedBox(height: 24);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          drawer: MenuDrawer(),
          appBar: AppBar(
            title: Text("Multiple Lights"),
            centerTitle: true,
            actions: connected ? null :[
              Desconected(),
            ],
          ),
          body: GridView.count(
            primary: false,
            padding: EdgeInsets.all(15),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              for(var controller in controllers.lightsMap)
                _buildLightButton(
                    title: controller['Title'],
                    controller: controller['LightState'],
                    onPressed: () => setState(() {
                      controller['LightState'] = !controller['LightState'];
                    }),
                    onLongPress: () => _displayDeltePopUp(
                        context: context,
                        delete: () => setState(() {
                          controllers.remove(controller['Title']);
                        }),
                    ),
                ),
              FlatButton(
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _buildAddPopUp(context);
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),
        )
    );
  }
}
