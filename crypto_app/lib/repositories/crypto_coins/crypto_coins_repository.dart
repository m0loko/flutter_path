import 'package:crypto_app/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
    CryptoCoinsRepository({required this.dio});
  final Dio dio;
  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    final response = await dio.get(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false',
    );

    final data = response.data as List<dynamic>;

    final cryptoCoinsList = data.map((e) {
      final name = e['name'] as String;
      final price = (e['current_price'] as num).toDouble();
      final imageUrl = e['image'] as String;
      return CryptoCoin(name: name, priceInUSD: price, imageUrl: imageUrl);
    }).toList();
    return cryptoCoinsList;
  }
}
