import 'package:devaloop_group_item/group_item.dart';
import 'package:devaloop_tenant_page/tenant_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TenantPage(
        title: 'Fast Chasier',
        subtitle: 'Fast Chasier',
        tenantCategoryName: 'Store',
        addTenant: (tenant) {},
        tenants: () async {
          await Future.delayed(const Duration(seconds: 5));
          return [
            Tenant(
              id: '001',
              name: 'Toko Modern Sejahtera',
              detail: 'Toko Alat Masak & Perabotan Rumah Tangga',
              owner: 'user@gmail.com',
            ),
            Tenant(
              id: '001',
              name: 'Toko Abadi Jaya',
              detail: 'Toko Alat Bagungan',
              owner: 'user1@gmail.com',
            ),
            Tenant(
              id: '001',
              name: 'Toko Sentosa',
              detail: 'Toko Listrik',
              owner: 'user2@gmail.com',
            ),
          ];
        },
        userName: 'user@gmail.com',
        userDetail: 'Google Account',
        onLoggingOut: () {},
        ownerMenu: [
          GroupItem(
            contents: [
              GroupContent(
                title: 'Report',
                subtitle: 'Report',
                leading: const Icon(Icons.summarize),
              ),
              GroupContent(
                title: 'Add Cashier Staff',
                subtitle: 'Add Cashier Staff',
                leading: const Icon(Icons.people),
              ),
            ],
          )
        ],
        menu: [
          GroupItem(
            title: 'Transaction',
            contents: [
              GroupContent(
                title: 'Sell',
                subtitle: 'Sell',
                leading: const Icon(Icons.sell),
              ),
            ],
          ),
          GroupItem(
            title: 'Inventory',
            contents: [
              GroupContent(
                title: 'Inventory',
                subtitle: 'Inventory',
                leading: const Icon(Icons.warehouse),
              ),
            ],
          ),
        ],
        updateTenant: (Tenant tenant) {},
        removeTenant: (Tenant tenant) {},
      ),
    );
  }
}
