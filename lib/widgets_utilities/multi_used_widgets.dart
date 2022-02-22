import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/modals/product_model.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/domicilio_tienda_opciones.dart';

class UsedWidgets {




  Widget addtocartWidget( BuildContext context ,Product product){

    return InkWell(
      onTap: (){  context.read<ShoppingCartProvider>().addproductToMap(product);
      Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text('Add to cart' ,style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),),

          Icon(Icons.add_shopping_cart_outlined, size: 50, color: Colors.blueGrey,)



        ],
      ),
    );
  }























  Widget  OpciocesPagoWidget({
    required BuildContext context ,
    void Function()? callbackEnLinea ,
    void Function()?callbackdataFono,
    void Function()?callbackefectivo,


  }

    ){
    return Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0)),
        child: ExpansionTile(
            title: Text(
              'Escoger una de las opciones ',
              style:
              TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            children: [
              ListTile(
                title: Text(
                  'Pagar en linea',
                  style: TextStyle(
                      fontSize: 18, color: Colors.blueGrey),
                ),
                onTap: callbackEnLinea,


              ),
              ListTile(
                  title: Text(
                    'Pagar con datafono',
                    style: TextStyle(
                        fontSize: 18, color: Colors.blueGrey),
                  ),
                  onTap: callbackdataFono

              ),

              ListTile(
                  title: Text(
                    'Pagar en effectivo',
                    style: TextStyle(
                        fontSize: 18, color: Colors.blueGrey),
                  ),
                  onTap: callbackefectivo

              ),












            ]));


  }























  Widget  OpciocesEntregaWidget({ required BuildContext context ,void Function()? callbackDomicilio ,  void Function()?callbackTienda} ){
    return Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0)),
        child: ExpansionTile(
            title: Text(
              'Escoger una de las opciones ',
              style:
              TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            children: [
              ListTile(
                title: Text(
                  'Engtrega a domicilio',
                  style: TextStyle(
                      fontSize: 18, color: Colors.blueGrey),
                ),
                onTap: callbackDomicilio,


              ),

              ListTile(
                  title: Text(
                    'Entraga a la tienda',
                    style: TextStyle(
                        fontSize: 18, color: Colors.blueGrey),
                  ),
                  onTap: callbackTienda

              ),


            ]));


  }






  Widget totalaPagarWidget( BuildContext context){


    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total a pagar ',
              style:
              TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
            Text(
              '${context.watch<ShoppingCartProvider>().productPriceTotal.toString()}\$',
              style: TextStyle(fontSize: 40),
            )
          ],
        ),
      ),
    );
  }










  Widget placeOrderwidget(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {

            Navigator.of(context).pushNamed(DomiclioOTiendaOpciones.id);
          },
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),),
            primary: Colors.green,
            onPrimary: Colors.black,),
          child: Text('Pedir un orden',style: TextStyle(fontSize: 20.0),),
        ),
      ),
    );
  }

  Widget buildListTile(
      {IconData? leadingIcon, VoidCallback? voidCallback, String? title}) {
    return ListTile(
      onTap: voidCallback,
      leading: Icon(
        leadingIcon,
        color: Colors.amberAccent,
      ),
      title: Text(
        title!,
        style: TextStyle(
            fontSize: 20, color: Colors.blueGrey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildRowNoSpaceScrollable({
    required String title,
    required String data,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
          Text(
            data,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildRowSpaceBetween({
    required String title,
    required String data,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
        Text(
          data,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }

  Widget buildSearchBar({required Function(String? value) callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: callback,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}




Widget buildplusMinusbtn( BuildContext context ,Product product , int quantity){

  return  Row(
    children: [
      InkWell(
          onTap: () {

            context.read<ShoppingCartProvider>().decreaseProductQty(product);
          },
          child: Icon(
            Icons.remove,
            color: Colors.white,
            size: 16,
          )),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding:
        EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white),
        child: Text(quantity.toString(),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      InkWell(
          onTap: () {

            context.read<ShoppingCartProvider>().addproductToMap(product);

          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          )),
    ],
  );

}









class cartproductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final int index;

  const cartproductCard(
      {Key? key,
      required this.product,
      required this.quantity,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        child: Row(
          children: [
            product.foto_producto == null
                ? CircleAvatar(
                    backgroundImage: AssetImage('assets/iconPlaceholder12.png'),
                    backgroundColor: Colors.transparent,
                    radius: 40.0,
                  )
                : CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(
                        'http://192.168.1.22/api_v_1/storage/app/public/notes/${product.foto_producto}'),
                    backgroundColor: Colors.transparent,
                  ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    product.nombre_producto.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${context.watch<ShoppingCartProvider>().productpricesubTotal[index]}\$',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),










Row(children: [

         Container(
           color: Colors.greenAccent,
           child: IconButton(
    onPressed: () {
      context.read<ShoppingCartProvider>().decreaseProductQty(product);
    },
    icon: Icon(Icons.remove),
  ),
         ),

  Text(quantity.toString()),

  IconButton(
    onPressed: () {
      context.read<ShoppingCartProvider>().increaseQty(product);
    },
    icon: Icon(Icons.add),
  ),


  IconButton(
    onPressed: () {
      context.read<ShoppingCartProvider>().deleteFromMap(product);
    },



    icon: Container(
        color: Colors.red,

        child: Icon(Icons.clear ,color: Colors.red,size: 32,)),
  ),





],),









          ],
        ),
      ),
    );
  }
}

class CartTotals extends StatelessWidget {
  const CartTotals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildTotalbars(
                title: 'Total a pagar',
                value: context
                    .watch<ShoppingCartProvider>()
                    .productPriceTotal.toString()
                    ,
                color: Colors.blue,
                fontwieght: FontWeight.bold,
              ),
              buildTotalbars(
                title: 'Precio sim impuestos',
                value: context
                    .watch<ShoppingCartProvider>()
                    .productPrecioSinImpuestoTotal
                    .toString(),
              ),
              buildTotalbars(
                title: 'Valor de impuestos',
                value: context
                    .watch<ShoppingCartProvider>()
                    .productValorImpuestoTotal
                    .toString(),
              ),
              buildTotalbars(
                title: 'valor de descuentos',
                value: context
                    .watch<ShoppingCartProvider>()
                    .productValorDescuentoTotal
                    .toString(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class buildTotalbars extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final FontWeight? fontwieght;
  const buildTotalbars(
      {Key? key,
      required this.title,
      required this.value,
      this.color,
      this.fontwieght})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: color,
            fontWeight: fontwieght,
          ),
        )
      ],
    );
  }































}
