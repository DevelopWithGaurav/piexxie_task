import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:piexxie_task/dropdown_killer.dart';
import 'package:piexxie_task/view/screens/user_details_screen.dart';

import '../../app_constant.dart';
import '../../controllers/user_list_controller.dart';
import '../../data/models/response/user_model.dart';
import 'user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        Get.find<UserListController>().getUserList(true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<UserListController>().getUserList(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'USERS LIST',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'All Team Members',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DropDownKiller<UserModel>(
                            data: Get.find<UserListController>().allUsers,
                            onSelected: (v) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => UserDetailsScreen(userID: v.id ?? '')));
                            },
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  label: const Text('Search'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Get.find<UserListController>().getUserList(false);
              },
              child: GetBuilder<UserListController>(builder: (userListController) {
                return userListController.isLoading && userListController.allUsers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : userListController.allUsers.isEmpty
                        ? const Center(child: Text('No data found!!!'))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding, vertical: 12),
                            itemCount: userListController.allUsers.length,
                            itemBuilder: (_, index) {
                              return UserCard(
                                index: index,
                                requiredUser: userListController.allUsers[index],
                              );
                            },
                          );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
