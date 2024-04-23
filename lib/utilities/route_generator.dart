import 'package:flutter/material.dart';
import 'package:lux_chain/screens/bottom%20bar/buy_screen.dart';
import 'package:lux_chain/screens/bottom%20bar/market_screen.dart';
import 'package:lux_chain/screens/bottom%20bar/sell_screen.dart';
import 'package:lux_chain/screens/bottom%20bar/wallet_screen.dart';
import 'package:lux_chain/screens/bottom%20bar/watch_screen.dart';
import 'package:lux_chain/screens/home_screen.dart';
import 'package:lux_chain/screens/model_page.dart';
import 'package:lux_chain/screens/setting_screen.dart';
import 'package:lux_chain/screens/wallet_timeline_screen.dart';
import 'package:lux_chain/screens/watch_tinder_screen.dart';
import 'package:lux_chain/utilities/frame.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recupera gli argomenti passati, se ci sono
    final args = settings.arguments;

    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case SettingScreen.id:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case WatchTinderScreen.id:
        return MaterialPageRoute(builder: (_) => const WatchTinderScreen());
      case BuyScreen.id:
        return MaterialPageRoute(builder: (_) => const BuyScreen());
      case SellScreen.id:
        return MaterialPageRoute(builder: (_) => const SellScreen());
      case WalletScreen.id:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case WalletTimelineScreen.id:
        return MaterialPageRoute(builder: (_) => const WalletTimelineScreen());
      case ModelScreen.id:
        return MaterialPageRoute(builder: (_) => const ModelScreen());
      case MarketScreen.id:
        return MaterialPageRoute(builder: (_) => const MarketScreen());
      case FrameScreen.id:
        return MaterialPageRoute(builder: (_) => const FrameScreen());
      case WatchScreen.id:
        if (args is int) {
          return MaterialPageRoute(builder: (_) => WatchScreen(watchID: args));
        }
        break;
      default:
        // Se la route non è stata trovata, restituisci una route di errore
        return _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    // Route di errore predefinita
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
