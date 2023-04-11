import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_cooker/utils/constants.dart';

import '../../utils/color_utils.dart';
import '../../utils/custom_button.dart';

List<String> ingredients = [];

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreen();
}

class _BarcodeScannerScreen extends State<BarcodeScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: stringToColorInHex(Constants.backgroundColorHex),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: [
              Container(
                  margin: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.05, 0, 0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: customButton(
                          context, "SCAN BARCODE", _scanBarcode, 0.9)))
            ]),
            Row(children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      scrollDirection: Axis.vertical,
                      child: Column(children: _createIngredientsFields())))
            ]),
            Row(children: [
              Column(children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: customButton(context, "CANCEL", () {
                          Navigator.pop(context);
                        }, 0.4)))
              ]),
              Column(children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child:
                            customButton(context, "ADD TO LIST", () {}, 0.4)))
              ]),
            ])
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanBarcode();
        },
        backgroundColor: stringToColorInHex(Constants.backgroundColorHex),
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Future _scanBarcode() async {
    String scanResult = '';
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "Cancel", false, ScanMode.BARCODE);
    } on PlatformException {
      _showToast("Error: Failed to get platform version");
    }

    if (!mounted) {
      return;
    }

    if (scanResult.isNotEmpty && scanResult != "-1") {
      try {
        String productName = await _fetchProductName(scanResult);
        setState(() {
          if (ingredients.contains(productName)) {
            _showToast("Product $productName already added");
          } else {
            setState(() {
              ingredients.add(productName);
            });
          }
        });
      } catch (ex) {
        _showToast(ex.toString().replaceFirst(RegExp(r"Exception: "), ""));
      }
    }
  }

  Future<String> _fetchProductName(String eanCode) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://world.openfoodfacts.org/api/v2/search?code=$eanCode&fields=product_name"));
      if (response.statusCode != 200) {
        throw Exception("Incorrect response. ${response.body}");
      }

      Map<String, dynamic> responseParsed = jsonDecode(response.body);
      if (responseParsed["count"] == 0) {
        throw Exception("No results for provided barcode");
      }

      final product = responseParsed["products"][0]["product_name"];
      return _translate(product);
    } catch (ex) {
      return Future.error(ex.toString());
    }
  }

  Future<String> _translate(String product) async {
    try {
      final translator = GoogleTranslator();
      return (await translator.translate(product, to: 'en')).toString();
    } catch (ex) {
      return Future.error(ex.toString());
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  List<Widget> _createIngredientsFields() {
    return List<Widget>.generate(
        ingredients.length,
        (index) => (SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.12,
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                color: const Color.fromRGBO(255, 255, 255, 0.4),
                child: Row(children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.77,
                    child: Text(ingredients[index],
                        style: const TextStyle(fontSize: 20)),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: IconButton(
                          onPressed: () =>
                              _removeIngredient(ingredients[index]),
                          icon: const Icon(Icons.delete,
                              color: Colors.black, size: 30)))
                ])))));
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      ingredients.remove(ingredient);
    });
  }
}
