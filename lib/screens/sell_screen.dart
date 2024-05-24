import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellScreen extends StatefulWidget {
  static const String id = 'SellScreen';
  final SellInfo sellInfo;

  const SellScreen({required this.sellInfo, super.key});

  @override
  // ignore: no_logic_in_create_state
  State<SellScreen> createState() => _SellScreenState(sellInfo: sellInfo);
}

class _SellScreenState extends State<SellScreen> {
  canSell() {
    return (_shareSelected <= sellInfo.numberOfShares && (_priceOfOneShare > 0))
        ? true
        : false;
  }

  handleSell() async {
    print("SELLING");
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;
    int userId = user.getInt('accountid') ?? 0;
    var result = await sellShares(
        userId, sellInfo.watchid, _shareSelected, _priceOfOneShare);
    if (result == APIStatus.success) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      //Se va tutto bene si chiude il messaggio di avviso e si torna al wallet
                      //TODO: bisognerebbe tornare alla scheramta delle proprie schare in vendita
                      Navigator.pushReplacementNamed(context, FrameScreen.id);
                    },
                    child: const Text('Close'),
                  ),
                ],
                title: const Text('Messaggio di info'),
                contentPadding: const EdgeInsets.all(20.0),
                content: Text('tutto bene'),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
                title: const Text('Messaggio di info'),
                contentPadding: const EdgeInsets.all(20.0),
                content: Text('tutto male'),
              ));
    }
  }

  final SellInfo sellInfo;
  int _shareSelected = 0;
  double _priceOfOneShare = 0;

  _SellScreenState({required this.sellInfo});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sell',
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
                  child: FutureBuilder<String>(
                    future: sellInfo.image,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit
                                .cover, // L'immagine si espanderà per riempire il contenitore
                          ),
                        );
                      } else {
                        return const Icon(Icons.error);
                      }
                    },
                  ),
                ),
                Text(
                  sellInfo.brandName,
                  style: TextStyle(
                      color: Colors.black38,
                      height: 1,
                      fontSize: width * 0.07,
                      fontFamily: 'Bebas'),
                ),
                Text(
                  sellInfo.modelName,
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.08,
                      fontFamily: 'Bebas'),
                ),
                SizedBox(
                  height: heigh * 0.02,
                ),
                Text('Actual Price: ${sellInfo.actualPrice} €'),
                Text('Shares: ${sellInfo.numberOfShares}'),
                Text('Owned shares: ${sellInfo.sharesOwned}'),
                SizedBox(
                  height: heigh * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      height: heigh * 0.04,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'N° shares',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _shareSelected = int.parse(value);
                            });
                          } else {
                            _shareSelected = 0;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      height: heigh * 0.04,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Price',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _priceOfOneShare = double.parse(value);
                            });
                          } else {
                            _priceOfOneShare = 0;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: canSell()
                          ? () => handleSell()
                          : () => {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(
                                                    context, FrameScreen.id);
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                          title:
                                              const Text('Info message'),
                                          contentPadding:
                                              const EdgeInsets.all(20.0),
                                          content: Text('Insufficient shares owned'),
                                        ))
                              },
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(width * 0.25, width * 0.08))),
                      child: const Text(
                        'Sell',
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
