import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;

  ProductPage(this.title, this.imageUrl, this.price, this.description);

  Widget _buildAddressPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Torget, Östersund ',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.green),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }
  // _showWarningDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Are you sure?'),
  //           content: Text('This action cannot be undone!'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('DISCRAD'),
  //               onPressed: () {
  //                 Navigator.pop(context); // Close dialog
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('CONTINUE'),
  //               onPressed: () {
  //                 Navigator.pop(context); // Close Dialog
  //                 Navigator.pop(
  //                     context, true); // Close the page and return true
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false); // Allows to leave page.
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset(imageUrl),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(title),
              ),
              _buildAddressPriceRow(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                ),
              )

              // Container(
              //   padding: EdgeInsets.all(10.0),
              //   child: RaisedButton(
              //     color: Theme.of(context).errorColor,
              //     child: Text('Delete'),
              //     onPressed: () => _showWarningDialog(context),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
