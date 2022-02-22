import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';

import 'opcionces_pago.dart';


class DomiclioOTiendaOpciones extends StatelessWidget {
  const DomiclioOTiendaOpciones({Key? key}) : super(key: key);
  static const String id = '/ domiclioOTiendaOpciones';



  @override
  Widget build(BuildContext context) {




    return Container(
        color: Colors.greenAccent,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Escoger la manera de pedir'),
          ),
          body: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UsedWidgets().totalaPagarWidget(context),
                UsedWidgets().OpciocesEntregaWidget(
                  context: context,
                  callbackDomicilio: (){Navigator.of(context).pushNamed( OpcionesDePago.id);},
                   callbackTienda: (){Navigator.of(context).pushNamed( OpcionesDePago.id);}),










              ],
            ),
          ),
        ));
  }
}
