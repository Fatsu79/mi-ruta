class Purchase {
  const Purchase({
    required this.date,
    required this.amount,
    this.invoiceNumber,
  });

  final DateTime date;
  final double amount;
  final String? invoiceNumber;
}
