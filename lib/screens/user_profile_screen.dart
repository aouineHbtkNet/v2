import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simo_v_7_0_1/providers/shared_preferences_provider.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/user-cataloge.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';
import 'package:simo_v_7_0_1/widgets_utilities/statefulWidget_textFormField.dart';

class UserProfileScreen extends StatelessWidget {
  static const String id = '/UserProfileScreen';
  String? valueX;

  final _formX = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(valueX);
    final provider =
        Provider.of<SharedPrefrencedProvider>(context, listen: false);
    provider.getInstanceOfSP();
    int? userId = context.watch<SharedPrefrencedProvider>().userId;
    String? userName = context.watch<SharedPrefrencedProvider>().userName;
    String? userEmail = context.watch<SharedPrefrencedProvider>().userEmail;

    return userId == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(UserCatalogue.id, (route) => false);
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text('Cuenta de usuario'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        UsedWidgets().buildRowSpaceBetween(
                            title: 'ID', data: userId.toString()),
                        UsedWidgets().buildRowSpaceBetween(
                            title: 'Nombre', data: userName ?? ''),
                        UsedWidgets().buildRowSpaceBetween(
                            title: 'Email', data: userEmail ?? ''),
                        Form(
                          key: _formX,
                          child: Column(
                            children: [
                              TextFormFieldWidget(
                                callback: (value) {
                                  valueX = value;
                                },
                                callback2: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Este campo es obligatorio';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_formX.currentState!.validate()) {
                                _formX.currentState!.save();
                              }
                            },
                            icon: Icon(Icons.graphic_eq_outlined))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
