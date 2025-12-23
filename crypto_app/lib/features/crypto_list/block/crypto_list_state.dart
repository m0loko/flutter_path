part of 'crypto_list_bloc.dart';

abstract class CryptoListState extends Equatable {}

class CryptoListInitial extends CryptoListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CryproListLoading extends CryptoListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CryptoListLoaded extends CryptoListState {
  final List<CryptoCoin> coinList;

  CryptoListLoaded({required this.coinList});

  @override
  // TODO: implement props
  List<Object?> get props => [coinList];
}

class CryproListLoadingError extends CryptoListState {
  final Object? exception;

  CryproListLoadingError({required this.exception});

  @override
  // TODO: implement props
  List<Object?> get props => [exception];
}
