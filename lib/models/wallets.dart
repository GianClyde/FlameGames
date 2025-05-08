class Wallet {
  final String walletId;
  double balance;

  Wallet({required this.walletId, required this.balance});

  void updateBalance(double newBalance) {
    balance = newBalance;
  }
}
