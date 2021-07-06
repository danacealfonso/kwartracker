class Wallet {
  Wallet(
      {this.walletId,
      this.walletColor,
      this.walletTypeName,
      this.walletTypeID,
      this.walletCurrency,
      this.walletCurrencyID,
      this.currencySign,
      this.walletName,
      this.overAllBalance = false,
      this.savedTo = '',
      this.amount = 0.00,
      this.targetAmount = 0.00});

  final String? walletId;
  final String? walletColor;
  final String? walletTypeName;
  final String? walletTypeID;
  final String? walletCurrency;
  final String? walletCurrencyID;
  final String? currencySign;
  final String? walletName;
  final String savedTo;
  final bool overAllBalance;
  final double amount;
  final double targetAmount;
}
