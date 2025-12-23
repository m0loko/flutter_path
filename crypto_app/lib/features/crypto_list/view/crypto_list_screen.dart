import 'dart:async';

import 'package:crypto_app/features/crypto_list/block/crypto_list_bloc.dart';
import 'package:crypto_app/features/crypto_list/widgets/widgets.dart';
import 'package:crypto_app/repositories/crypto_coins/crypto_coins.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CryproListScreen extends StatefulWidget {
  const CryproListScreen({super.key});
  @override
  State<CryproListScreen> createState() => _CryproListScreenState();
}

class _CryproListScreenState extends State<CryproListScreen> {
  final _cryproListBloc = CryptoListBloc(GetIt.I<AbstractCoinsRepository>());
  @override
  void initState() {
    _cryproListBloc.add(LoadCryptoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Currencies List')),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          _cryproListBloc.add(LoadCryptoList(completer: completer));
          return completer.future;
        },
        child: BlocBuilder<CryptoListBloc, CryptoListState>(
          bloc: _cryproListBloc,
          builder: (context, state) {
            if (state is CryptoListLoaded) {
              return ListView.separated(
                padding: EdgeInsets.only(top: 16),
                separatorBuilder: (context, index) => Divider(),
                physics: BouncingScrollPhysics(),
                itemCount: state.coinList.length,
                itemBuilder: (context, i) {
                  final coin = state.coinList[i];
                  return CryptoCoinTile(coin: coin);
                },
              );
            } else if (state is CryproListLoadingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      'Something went wrong',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Please try again lattet',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        _cryproListBloc.add(LoadCryptoList());
                      },
                      child: Text('Try again', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            }
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Stream<int> countStream(int max) async* {
    for (int i = 0; i < max; i++) {
        yield i;
    }
}