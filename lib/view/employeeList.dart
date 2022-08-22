import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:webandcraft/providers/employee_provider.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EmployeeListState();
  }
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  void initState() {
    Future.microtask(() async {
      await context.read<EmployeeProvider>().createDataBase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: context.watch<EmployeeProvider>().loader,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("Employee App"),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller:
                        context.watch<EmployeeProvider>().searchController,
                    decoration:
                        const InputDecoration(label: Text("Search Employee")),
                    onChanged: (val) {
                      context.read<EmployeeProvider>().search(val);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: context.watch<EmployeeProvider>().sList.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {
                          context
                              .read<EmployeeProvider>()
                              .gotoDetailsPage(index, context);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    context
                                            .watch<EmployeeProvider>()
                                            .sList[index]
                                            ?.profileImage ??
                                        "",
                                    width: 60,
                                    height: 60,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        width: 60,
                                        height: 60,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context
                                                .watch<EmployeeProvider>()
                                                .sList[index]
                                                ?.name ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "Company name: ${context.watch<EmployeeProvider>().sList[index]?.company?.name ?? " Nil"}"),
                                      Text(
                                          "Email: ${context.watch<EmployeeProvider>().sList[index]?.email ?? " Nil"}"),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      );
                    }),
                  ),
                ),
              ],
            )));
  }
}
