import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/dashboard_controller.dart';
import 'due_invoice_card.dart';

/// The Debt tab body: total still owed for the selected store, then every
/// unpaid due/installment invoice, newest first. Not date-filtered - a debt
/// stays here until it is collected.
class DebtTabView extends StatelessWidget {
  final DashboardController controller;

  const DebtTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DebtTotalCard(controller: controller),
          SizedBox(height: 16.h),
          Expanded(
            child: Obx(() {
              final invoices = controller.dueInvoices.toList(growable: false);
              final isLoading = controller.isDueInvoicesLoading.value;
              final error = controller.dueInvoicesError.value;
              if (isLoading && invoices.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.refreshDueInvoices,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: invoices.length + 1,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (_, index) {
                    if (index < invoices.length) {
                      return DueInvoiceCard(
                        invoice: invoices[index],
                        money: controller.money,
                      );
                    }
                    if (invoices.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 160.h),
                        child: Center(
                          child: Text(
                            error ?? 'No due invoices',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }
                    if (!controller.canLoadMoreDueInvoices) {
                      return const SizedBox.shrink();
                    }
                    return Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () =>
                                  controller.refreshDueInvoices(loadMore: true),
                              child: const Text('Load more'),
                            ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DebtTotalCard extends StatelessWidget {
  final DashboardController controller;

  const _DebtTotalCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.dashboardCardGradientStart,
            AppColors.dashboardCardGradientEnd,
          ],
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total due',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    controller.money(controller.dueInvoicesAmount.value),
                    style: getTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dashboardTextDark,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${controller.dueInvoicesTotal.value} '
              'invoice${controller.dueInvoicesTotal.value == 1 ? '' : 's'}',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.dashboardAccentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
