import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:softverse_dash/core/common/widgets/app_network_image.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=https://api.softverse.test');
  });

  testWidgets('resolves a server-relative inventory image URL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppNetworkImage(
          url: '/media/uploads/item.jpg',
          width: 60,
          height: 60,
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as NetworkImage).url,
      'https://api.softverse.test/media/uploads/item.jpg',
    );
  });

  testWidgets('shows a placeholder without requesting an empty URL', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppNetworkImage(url: '', width: 60, height: 60)),
    );

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Iconsax.gallery_slash), findsOneWidget);
  });
}
