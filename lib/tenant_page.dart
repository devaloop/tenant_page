library devaloop_tenant_page;

import 'package:devaloop_menu_page/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:devaloop_group_item/group_item.dart';
import 'package:devaloop_form_builder/form_builder.dart';

class TenantPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tenantCategoryName;
  final dynamic Function(Tenant tenant) addTenant;
  final dynamic Function(Tenant tenant) updateTenant;
  final dynamic Function(Tenant tenant) removeTenant;
  final Future<List<Tenant>> Function() tenants;
  final String userName;
  final String userDetail;
  final dynamic Function() onLoggingOut;
  final List<GroupItem> ownerMenu;
  final List<GroupItem> menu;

  const TenantPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.tenants,
      required this.addTenant,
      required this.tenantCategoryName,
      required this.userName,
      required this.userDetail,
      required this.onLoggingOut,
      required this.ownerMenu,
      required this.menu,
      required this.updateTenant,
      required this.removeTenant});

  @override
  State<TenantPage> createState() => _TenantPageState();
}

class _TenantPageState extends State<TenantPage> {
  late Future<List<Tenant>> _tenants;
  Tenant? _currentTenant;

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
                        contents: snapshot.data!.map((e) {
                          var ownerMenu = [
                            GroupItem(
                              title: 'Owner Access',
                              contents: [
                                GroupContent(
                                  title: 'Edit',
                                  subtitle: 'Edit',
                                  leading: const Icon(Icons.edit),
                                  detail: Detail(
                                    detailPage: TenantDetailPage(
                                      tenant: e,
                                      updateTenant: widget.updateTenant,
                                      removeTenant: widget.removeTenant,
                                    ),
                                    onDetailPageClosed: (result) {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                ),
                                GroupContent(
                                  title: 'Owner Menu',
                                  subtitle: 'Owner Menu',
                                  leading:
                                      const Icon(Icons.admin_panel_settings),
                                  detail: Detail(
                                    detailPage: MenuPage(
                                      title: 'Owner Menu',
                                      subtitle: 'Owner Menu',
                                      menu: widget.ownerMenu,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ];
                          ownerMenu.addAll(widget.menu);
                          return GroupContent(
                            title: e.name,
                            subtitle: e.detail,
                            key: e.id,
                            leading: const Icon(Icons.menu),
                            detail: Detail(
                              detailPage: e.owner == widget.userName
                                  ? MenuPage(
                                      title: _currentTenant == null
                                          ? e.name
                                          : _currentTenant!.name,
                                      subtitle: _currentTenant == null
                                          ? e.detail
                                          : _currentTenant!.detail,
                                      menu: ownerMenu,
                                    )
                                  : MenuPage(
                                      title: e.name,
                                      subtitle: e.detail,
                                      menu: widget.menu,
                                    ),
                              onDetailPageClosed: (result) {
                                if (result != null) {
                                  setState(() {
                                    init();
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
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
                                userName: widget.userName,
                                tenantCategoryName: widget.tenantCategoryName,
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
  final String userName;
  final String tenantCategoryName;
  final dynamic Function(Tenant tenant) addTenant;

  const TenantAddPage(
      {super.key,
      required this.addTenant,
      required this.userName,
      required this.tenantCategoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            'Add $tenantCategoryName',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'Add $tenantCategoryName',
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
              name: 'detail',
              label: 'Detail',
              isMultilines: true,
            ),
          ],
          onSubmit: (context, inputValues) async {
            await addTenant.call(
              Tenant(
                name: inputValues['name']!.getString()!,
                detail: inputValues['detail']!.getString()!,
                owner: userName,
              ),
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

class TenantDetailPage extends StatelessWidget {
  final Tenant tenant;
  final dynamic Function(Tenant tenant) updateTenant;
  final dynamic Function(Tenant tenant) removeTenant;

  const TenantDetailPage(
      {super.key,
      required this.tenant,
      required this.updateTenant,
      required this.removeTenant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            tenant.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            tenant.detail,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
              name: 'detail',
              label: 'detail',
              isMultilines: true,
            ),
          ],
          onInitial: (context, inputValues) {
            inputValues['name']!.setString(tenant.name);
            inputValues['detail']!.setString(tenant.detail);
          },
          onSubmit: (context, inputValues) async {
            Tenant result = Tenant(
              id: tenant.id,
              name: inputValues['name']!.getString()!,
              detail: inputValues['detail']!.getString()!,
              owner: tenant.owner,
            );
            await updateTenant.call(result);

            if (!context.mounted) return;

            Navigator.pop(context, result);
          },
          submitButtonSettings: const SubmitButtonSettings(
            label: 'Save',
            icon: Icon(Icons.save),
          ),
          additionalButtons: [
            AdditionalButton(
              label: 'Remove',
              icon: const Icon(Icons.remove),
              onTap: () async {
                await removeTenant.call(tenant);

                if (!context.mounted) return;

                Navigator.pop(context, tenant);
              },
            )
          ],
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
  final dynamic id;
  final String name;
  final String detail;
  final String owner;

  Tenant(
      {this.id, required this.name, required this.detail, required this.owner});
}
