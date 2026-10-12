/// One unpaid credit (due/installment) sale shown on the Debt tab.
class DueInvoiceModel {
  final String id;
  final String orderNumber;
  final DateTime? date;
  final String customerName;
  final String? storeName;
  final String? employeeName;
  final double totalAmount;
  final double amountReceived;
  final double amountDue;

  const DueInvoiceModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.customerName,
    required this.storeName,
    required this.employeeName,
    required this.totalAmount,
    required this.amountReceived,
    required this.amountDue,
  });

  factory DueInvoiceModel.fromApi(Map<String, dynamic> row) {
    final customer = row['customerName']?.toString().trim() ?? '';
    return DueInvoiceModel(
      id: row['checkoutOrderId']?.toString() ?? '',
      orderNumber: row['orderNumber']?.toString() ?? '',
      date: DateTime.tryParse(row['date']?.toString() ?? '')?.toLocal(),
      customerName: customer.isEmpty ? 'Walk-in customer' : customer,
      storeName: row['storeName']?.toString(),
      employeeName: row['employeeName']?.toString(),
      totalAmount: (row['totalAmount'] as num?)?.toDouble() ?? 0,
      amountReceived: (row['amountReceived'] as num?)?.toDouble() ?? 0,
      amountDue: (row['amountDue'] as num?)?.toDouble() ?? 0,
    );
  }
}
