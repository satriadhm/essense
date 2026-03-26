import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/analysis/perfume_search_sheet.dart';
import '../../widgets/analysis/primary_action_button.dart';
import '../../widgets/analysis/secondary_action_button.dart';
import 'scan_biometrics_screen.dart';
import 'scan_product_screen.dart';

class AddFragranceScreen extends StatelessWidget {
  const AddFragranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      'assets/images/scan.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Let's start with your scent!",
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add the fragrance you're wearing",
                        style: AppTextStyles.bodyLarge,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryActionButton(
                      text: 'Scan My Fragrance',
                      icon: Icons.qr_code_2_rounded,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ScanProductScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SecondaryActionButton(
                      text: 'Add manually',
                      icon: Icons.grid_view_rounded,
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => DraggableScrollableSheet(
                            initialChildSize: 0.75,
                            minChildSize: 0.5,
                            maxChildSize: 0.93,
                            expand: false,
                            builder: (_, scrollController) =>
                                PerfumeSearchSheet(
                              scrollController: scrollController,
                              onSelected: (perfume) {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ScanBiometricsScreen(
                                      selectedPerfume: perfume,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: InkResponse(
                onTap: () => Navigator.of(context).maybePop(),
                radius: 24,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
