library devaloop_tenant_page;

import 'package:flutter/material.dart';
import 'package:devaloop_group_item/group_item.dart';
import 'package:devaloop_form_builder/form_builder.dart';

class TenantPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tenantCategoryName;
  final dynamic Function(Tenant tenant) addTenant;
  final Future<List<GroupContent>> Function() tenants;
  final String userName;
  final String userDetail;
  final dynamic Function() onLoggingOut;

  const TenantPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.tenants,
      required this.addTenant,
      required this.tenantCategoryName,
      required this.userName,
      required this.userDetail,
      required this.onLoggingOut});

  @override
  State<TenantPage> createState() => _TenantPageState();
}

class _TenantPageState extends State<TenantPage> {
  late Future<List<GroupContent>> _tenants;

  void init() {
    _tenants = Future(() async {
      var tenants = await widget.tenants.call();
      return tenants;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.subtitle),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupItem(
              contents: [
                GroupContent(
                  leading: const Icon(Icons.person),
                  title: widget.userName,
                  subtitle: widget.userDetail,
                  detail: Detail(
                    detailPage: LoggingOutPage(
                      username: widget.userName,
                      detail: widget.userDetail,
                      onLoggingOut: widget.onLoggingOut,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _tenants,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GroupItem(
                        title: widget.tenantCategoryName,
                        contents: snapshot.data!,
                      ),
                      GroupItem(
                        contents: [
                          GroupContent(
                            leading: const Icon(Icons.add),
                            title: 'Add ${widget.tenantCategoryName}',
                            subtitle: 'Add ${widget.tenantCategoryName}',
                            detail: Detail(
                              detailPage: TenantAddPage(
                                addTenant: widget.addTenant,
                              ),
                              onDetailPageClosed: (result) {
                                if (result != null) {
                                  setState(() {
                                    init();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TenantAddPage extends StatelessWidget {
  final dynamic Function(Tenant tenant) addTenant;

  const TenantAddPage({super.key, required this.addTenant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          inputFields: const [
            InputText(
              name: 'name',
              label: 'Name',
            ),
            InputText(
              name: 'description',
              label: 'Description',
              isMultilines: true,
            ),
          ],
          onSubmit: (context, inputValues) async {
            await addTenant.call(
              Tenant(
                  name: inputValues['name']!.getString()!,
                  desctiption: inputValues['desctiption']!.getString()!),
            );

            if (!context.mounted) return;

            Navigator.pop(context, true);
          },
          submitButtonSettings: const SubmitButtonSettings(
            label: 'Add',
            icon: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class LoggingOutPage extends StatefulWidget {
  final String username;
  final String detail;
  final dynamic Function() onLoggingOut;

  const LoggingOutPage({
    super.key,
    required this.username,
    required this.detail,
    required this.onLoggingOut,
  });

  @override
  State<LoggingOutPage> createState() => _LoggingOutPageState();
}

class _LoggingOutPageState extends State<LoggingOutPage> {
  late bool _isLoggingOut;

  @override
  void initState() {
    super.initState();
    _isLoggingOut = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(widget.username),
          subtitle: Text(widget.detail),
        ),
      ),
      body: Center(
        child: _isLoggingOut
            ? const CircularProgressIndicator()
            : FilledButton.icon(
                onPressed: () async {
                  setState(() {
                    _isLoggingOut = true;
                  });

                  await widget.onLoggingOut.call();

                  if (!context.mounted) return;

                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
      ),
    );
  }
}

class Tenant {
  final String name;
  final String desctiption;

  Tenant({required this.name, required this.desctiption});
}
