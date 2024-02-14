TenantPage

## Usage

```dart
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
        addTenant: (tenent) {},
        tenants: () async {
          return [
            GroupContent(
              leading: const Icon(Icons.person),
              title: 'Toko Modern Sejahtera',
              subtitle: 'Toko Alat Masak & Perabotan Rumah Tangga',
            ),
            GroupContent(
              leading: const Icon(Icons.person),
              title: 'Toko Abadi Jaya',
              subtitle: 'Toko Perlengkapan Listrik & Bangunan',
            ),
            GroupContent(
              leading: const Icon(Icons.person),
              title: 'Toko Sentosa',
              subtitle: 'Toko Kemasan & Plastik Serbaguna',
            ),
          ];
        },
        userName: 'user@gmail.com',
        userDetail: 'Google Account',
        onLoggingOut: () {},
      ),
    );
  }
}
```
