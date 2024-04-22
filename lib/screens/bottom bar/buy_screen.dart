import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lux_chain/utilities/size_config.dart';

class BuyScreen extends StatefulWidget {
  static const String id = 'BuyScreen';
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final double _sellPrice = 800.0;
  final int _shareOnSale = 5;
  final int _shareSelected = 36;
  final double _moneyInTheWallet = 6345.45;

  var formatter = NumberFormat("#,##0.00", "en_US");

  doesTheUserHaveEnoughMoney() {
    return (_shareSelected <= _shareOnSale &&
            (_shareSelected * _sellPrice) <= _moneyInTheWallet)
        ? true
        : false;
  }

  buyShares() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Buy',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  alignment: Alignment.center, // This is needed
                  child: Padding(
                    padding: EdgeInsets.all(heigh * 0.02),
                    child: Image.asset(
                      'assets/images/o1.jpg',
                      fit: BoxFit.contain,
                      height: heigh * 0.27,
                    ),
                  ),
                ),
                Text(
                  'Nome corto'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black38,
                      height: 1,
                      fontSize: width * 0.07,
                      fontFamily: 'Bebas'),
                ),
                Text(
                  'Nome lungo con descrizione'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.08,
                      fontFamily: 'Bebas'),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Colors.lightGreen),
                  child: const Text('+ 2.3%'),
                ),
                SizedBox(
                  height: heigh * 0.02,
                ),
                const Text('Prezzo di listino: 119 990€'),
                const Text('Numero di quote: 200'),
                const Text('Prezzo medio: 780€'),
                const Text('Miglior prezzo di vendita: 800€'),
                const Text('Numero di quote in vendita: 5'),
                SizedBox(
                  height: heigh * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      height: heigh * 0.04,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'N° di quote',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                    ),
                    Text(
                      'Totale: ${formatter.format(_shareSelected * _sellPrice)}',
                      style: TextStyle(
                          fontSize: heigh * 0.023, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: doesTheUserHaveEnoughMoney()
                          ? () => buyShares()
                          : null,
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(width * 0.25, width * 0.08))),
                      child: const Text(
                        'Buy',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}