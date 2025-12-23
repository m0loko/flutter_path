import 'package:crypto_app/features/crypto_coin/crypto_coin.dart';
import 'package:crypto_app/features/crypto_list/crypto_list.dart';

final routes = {
  '/': (context) => const CryproListScreen(),
  '/coin': (context) => const CryptoCoinScreen(),
};
