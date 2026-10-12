import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../models/due_invoice_model.dart';

/// A single unpaid invoice on the Debt tab: customer and invoice number on
/// the left, the amount still owed on the right, then date/store/seller and
/// how much of the total has been paid so far.
class DueInvoiceCard extends StatelessWidget {
  final DueInvoiceModel invoice;
  final String Function(num value) money;

  const DueInvoiceCard({super.key, required this.invoice, required this.money});

  static final _date = DateFormat('d MMM yyyy, h:mm a');

  @override
  Widget build(BuildContext context) {
    final details = [
      if (invoice.date != null) _date.format(invoice.date!),
      if (invoice.storeName?.isNotEmpty ?? false) invoice.storeName!,
      if (invoice.employeeName?.isNotEmpty ?? false) invoice.employeeName!,
    ].join(' · ');

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.customerName,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dashboardTextDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '#${invoice.orderNumber}',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dashboardAccentBlue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money(invoice.amountDue),
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dangerRed,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'due',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              details,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 4.h),
          Text(
            'Paid ${money(invoice.amountReceived)} of '
            '${money(invoice.totalAmount)}',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
