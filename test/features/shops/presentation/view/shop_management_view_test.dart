import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class MockShopViewModel extends MockBloc<ShopEvent, ShopState>
    implements ShopViewModel {}

class TestShopManagementView extends StatelessWidget {
  final ShopViewModel shopViewModel;

  const TestShopManagementView({super.key, required this.shopViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Shops')),
      body: BlocConsumer<ShopViewModel, ShopState>(
        listener: (context, state) {
          // Mock listener
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return Column(
            children: [
              // Header with shop count
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.orange.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(Icons.store, color: Colors.orange, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Your Shops (${state.shops.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Shops list
              Expanded(
                child:
                    state.shops.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No shops found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add your first shop to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.shops.length,
                          itemBuilder: (context, index) {
                            final shop = state.shops[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange.withOpacity(
                                    0.2,
                                  ),
                                  child: Icon(
                                    Icons.store,
                                    color: Colors.orange,
                                  ),
                                ),
                                title: Text(
                                  shop.shopName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (shop.address != null &&
                                        shop.address!.isNotEmpty)
                                      Text(
                                        shop.address!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    if (shop.contactNumber != null &&
                                        shop.contactNumber!.isNotEmpty)
                                      Text(
                                        shop.contactNumber!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  group('ShopManagementView', () {
    late MockShopViewModel mockShopViewModel;

    setUp(() {
      mockShopViewModel = MockShopViewModel();
    });

    testWidgets('renders shop management view with correct elements', (
      WidgetTester tester,
    ) async {
      when(() => mockShopViewModel.state).thenReturn(const ShopState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ShopViewModel>.value(
            value: mockShopViewModel,
            child: TestShopManagementView(shopViewModel: mockShopViewModel),
          ),
        ),
      );

      // Check if app bar is rendered with correct title
      expect(find.text('Manage Shops'), findsOneWidget);

      // Check if header shows shop count
      expect(find.text('Your Shops (0)'), findsOneWidget);

      // Check if floating action button is present
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Check if empty state is displayed when no shops
      expect(find.text('No shops found'), findsOneWidget);
      expect(find.text('Add your first shop to get started'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (
      WidgetTester tester,
    ) async {
      when(
        () => mockShopViewModel.state,
      ).thenReturn(const ShopState.initial().copyWith(isLoading: true));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ShopViewModel>.value(
            value: mockShopViewModel,
            child: TestShopManagementView(shopViewModel: mockShopViewModel),
          ),
        ),
      );

      // Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
