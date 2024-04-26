import 'package:flutter/material.dart';
import 'package:lux_chain/screens/wallet_specs_screen.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';

class WalletScreen extends StatefulWidget {
  static const String id = 'WalletScreen';
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<List<WalletWatch>> futureWatches;
  late Future<WalletData> futureWalletData;

  @override
  void initState() {
    super.initState();
    futureWatches = getUserWalletWatches(1);
    futureWalletData = getWalletData(1);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
            padding: EdgeInsets.only(
                right: width * 0.05, left: width * 0.05, top: height * 0.01),
            child: FutureBuilder<WalletData>(
              future: futureWalletData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  WalletData walletData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Wallet value',
                            style: TextStyle(fontSize: width * 0.05),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          const Icon(Icons.visibility),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WalletSpecsScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatter.format(
                                    walletData.inShares + walletData.liquidity),
                                style: TextStyle(
                                    color: Colors.black87,
                                    height: 1,
                                    fontSize: width * 0.1,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Text(
                                '€',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  height: 1,
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                width: width * 0.01,
                              )),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Colors.lightGreen),
                                child: Text('${walletData.rate}%'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'In collezioni: ${formatter.format(walletData.inShares)} €',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      Text(
                        'Liquidi: ${formatter.format(walletData.liquidity)} €',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: Row(
                          children: [
                            Icon(
                              Icons.archive,
                              size: width * 0.08,
                            ),
                            Icon(
                              Icons.timelapse,
                              size: width * 0.08,
                            ),
                            Icon(
                              Icons.store,
                              size: width * 0.08,
                            ),
                            Icon(
                              Icons.star,
                              size: width * 0.08,
                            ),
                            Expanded(child: SizedBox(width: width * 0.08)),
                            Icon(Icons.arrow_outward_rounded,
                                size: width * 0.08),
                            Icon(Icons.filter, size: width * 0.08),
                            Icon(Icons.search, size: width * 0.08),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: FutureBuilder<List<WalletWatch>>(
                                future: futureWatches,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData) {
                                    List<WalletWatch> walletWatches =
                                        snapshot.data!;
                                    return Column(
                                      children: walletWatches.map(
                                        (watch) {
                                          return CustomBottomBigCard(
                                            watchID: watch.watchid,
                                            screenWidth: width,
                                            imgUrl: getDownloadURL(watch.imageuri),
                                            reference:
                                                watch.modeltype.reference,
                                            modelName:
                                                watch.modeltype.model.modelname,
                                            brandName:
                                                watch.modeltype.model.brandname,
                                            serialNumber:
                                                watch.watchid.toString(),
                                            valoreAttuale: watch.actualprice,
                                            initialPrice:
                                                watch.initialprice,
                                            quotePossedute: watch.owned,
                                            quoteTotali: watch.numberofshares,
                                            controvalore: 0,
                                            increaseRate: watch.increaseRate,
                                          );
                                        },
                                      ).toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Gestisci il caso in cui si verifica un errore
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Gestisci il caso in cui non ci sono dati disponibili
                                    return const SizedBox(); // Placeholder widget when no data is available
                                  }
                                })),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  // Gestisci il caso in cui si verifica un errore
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Gestisci il caso in cui non ci sono dati disponibili
                  return const SizedBox(); // Placeholder widget when no data is available
                }
              },
            )),
      ),
    );
  }
}

class CustomBottomBigCard extends StatelessWidget {
  const CustomBottomBigCard({
    Key? key,
    required this.watchID,
    required this.screenWidth,
    required this.imgUrl,
    required this.reference,
    required this.modelName,
    required this.brandName,
    required this.serialNumber,
    required this.valoreAttuale,
    required this.initialPrice,
    required this.quotePossedute,
    required this.quoteTotali,
    required this.controvalore,
    required this.increaseRate,
  }) : super(key: key);

  final int watchID;
  final double screenWidth;
  final Future<String> imgUrl;
  final String reference;
  final String modelName;
  final String brandName;
  final String serialNumber;
  final int quotePossedute;
  final int quoteTotali;
  final double controvalore;
  final double initialPrice;
  final double valoreAttuale;
  final double increaseRate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(WatchScreen.id, arguments: watchID),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(3, 3), // Shadow position
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: imgUrl,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.only(right: 0),
                          alignment: Alignment.center,
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.contain,
                            width: screenWidth * 0.22,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('Image not found');
                      }
                    },
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      color: (increaseRate > 0) ? Colors.lightGreen : Colors.red,
                    ),
                    child: Text('$increaseRate%'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text(
                  modelName,
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: screenWidth * 0.055,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text('Reference: $reference'),
                SizedBox(height: screenWidth * 0.02),
                Text('Quote Possedute: $quotePossedute/$quoteTotali'),
                Text('Controvalore: $controvalore €'),
                Text('Valore iniziale: $initialPrice €'),
                Text('Valore attuale: $valoreAttuale €'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

