import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_app/services/serviceSample.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Application',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Basic Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RegistrationModel registrationModel = RegistrationModel.getEmptyValue();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  APIService _service = APIService();

  InputBorder _outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
  );

  void _incrementCounter() {
    setState(() {
      registrationModel = RegistrationModel.getEmptyValue();
    });
  }

  @override
  void initState() {
    super.initState();

    _service.loadAsset().then((value) {
      setState(() => registrationModel = RegistrationModel.fromJson(json.decode(value)));
    });

    //Service call through base request
    _service.getValues().then(
      (value) {
        final data = json.decode(value);
        UserInfo info = UserInfo.fromJson(data);
        final dataValues = info.toJson();
        print(dataValues);
      },
    ).catchError(
      (onError) => print(onError),
    );

    //Normal Service call
    _service
        .getPlaceHolders()
        .then(
          (value) => print(value),
        )
        .catchError(
          (onError) => print(onError),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _requiredValidator(String input, String inputLabel) {
    if (input == null || input.isEmpty) {
      return "$inputLabel is required";
    }
    return null;
  }

  submitEvent() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(json.encode(RegistrationModel.getObjectString(registrationModel)));
      print(json.encode(registrationModel.toJson()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  borderOnForeground: true,
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 3.0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Text(
                              "Registration",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          ContainerWithPadding(
                            child: Divider(
                              height: 2,
                              thickness: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          ContainerWithPadding(
                            child: TextFormField(
                              controller: TextEditingController(text: registrationModel.userName),
                              maxLength: 5,
                              decoration: InputDecoration(
                                counterText: "", //<--- Setting counter text to empty to remove that maxlength hint
                                contentPadding: EdgeInsets.all(15),
                                labelText: "User Name",
                                focusedBorder: _outlineBorder,
                                border: _outlineBorder,
                              ),
                              validator: (value) => _requiredValidator(value, "User Name"),
                              onSaved: (value) => registrationModel.userName = value,
                              //onChanged: (value)=> registrationModel.userName = value,
                              //autovalidate: true,
                            ),
                          ),
                          ContainerWithPadding(
                            child: TextFormField(
                              controller: TextEditingController(text: registrationModel.organization),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Organization",
                                focusedBorder: _outlineBorder,
                                border: _outlineBorder,
                              ),
                              validator: (value) => _requiredValidator(value, "Organization"),
                              onSaved: (value) => registrationModel.organization = value,
                            ),
                          ),
                          ContainerWithPadding(
                            child: TextFormField(
                              controller: TextEditingController(text: registrationModel.email),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Email",
                                focusedBorder: _outlineBorder,
                                border: _outlineBorder,
                              ),
                              validator: (value) {
                                return _requiredValidator(value, "Email");
                              },
                              onSaved: (value) => registrationModel.email = value,
                            ),
                          ),
                          ContainerWithPadding(
                            child: TextFormField(
                              controller: TextEditingController(text: registrationModel.password),
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Password",
                                focusedBorder: _outlineBorder,
                                border: _outlineBorder,
                              ),
                              validator: (value) => _requiredValidator(value, "Password"),
                              onSaved: (value) => registrationModel.password = value,
                            ),
                          ),
                          ContainerWithPadding(
                            child: DropdownButtonFormField(
                              value: registrationModel.accountType,
                              items: [
                                DropdownMenuItem(child: Text("New"), value: "new"),
                                DropdownMenuItem(
                                  child: Text("Existing"),
                                  value: "existing",
                                )
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Account Type",
                                focusedBorder: _outlineBorder,
                                border: _outlineBorder,
                              ),
                              onChanged: (String value) {},
                              validator: (value) => _requiredValidator(value, "Account Type"),
                              onSaved: (value) => registrationModel.accountType = value,
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: submitEvent,
                              child: Text("Submit"),
                              color: Colors.teal[300],
                              elevation: 10.0,
                              textColor: Colors.grey[800],
                              shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

//Use this link to create 'dart' class based on the 'json' object [https://javiercbk.github.io/json_to_dart/]
class RegistrationModel {
  String userName;
  String organization;
  String email;
  String password;
  String accountType;

  RegistrationModel({this.userName, this.organization, this.email, this.password, this.accountType});

  factory RegistrationModel.getEmptyValue() {
    return RegistrationModel(userName: null, organization: null, password: null, accountType: null);
  }

  static Map<String, dynamic> getObjectString(RegistrationModel model) {
    return {"userName": model.userName, "organization": model.organization, "email": model.email, "password": model.password, "accountType": model.accountType};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['organization'] = this.organization;
    data['email'] = this.email;
    data['password'] = this.password;
    data['accountType'] = this.accountType;
    return data;
  }

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    organization = json['organization'];
    email = json['email'];
    password = json['password'];
    accountType = json['accountType'];
  }
}

class ContainerWithPadding extends StatelessWidget {
  final Widget child;
  final double allSidePadding;

  const ContainerWithPadding({Key key, this.child, this.allSidePadding = 10}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(allSidePadding),
      child: child,
    );
  }
}
