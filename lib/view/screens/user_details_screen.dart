import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:piexxie_task/controllers/user_details_controller.dart';
import 'package:piexxie_task/extensions.dart';
import 'package:piexxie_task/extra_methods.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.userID});

  final String userID;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<UserDetailsController>().getUserDetails(widget.userID).then((value) {
        setState(() {
          _isLoading = false;
        });
        if (!value.isSuccess) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Something went wrong!!!');
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: GetBuilder<UserDetailsController>(builder: (userDetailsController) {
                return Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: size.width * 0.25, left: 20, right: 20, bottom: 65),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.width * 0.35),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'Name: ${userDetailsController.latestUser.title} ${userDetailsController.latestUser.firstName} ${userDetailsController.latestUser.lastName}'
                                  .capitalizeFirstOfEach,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userDetailsController.latestUser.email.isEmail) {
                                ExtraMethods().makeMail(userDetailsController.latestUser.email ?? '');
                              } else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(msg: 'Invalid Email!!!');
                              }
                            },
                            child: Material(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  'Email: ${userDetailsController.latestUser.email}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'DOB: ${(userDetailsController.latestUser.dateOfBirth ?? DateTime.now()).dMyDash}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'Gender: ${userDetailsController.latestUser.gender.capitalizeFirstOfEach}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userDetailsController.latestUser.phone.isValid) {
                                ExtraMethods().makeCall(userDetailsController.latestUser.email ?? '');
                              } else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(msg: 'Invalid Number!!!');
                              }
                            },
                            child: Material(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  'Phone: ${userDetailsController.latestUser.phone}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: size.width / 2,
                          width: size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade300,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Image.network(
                            userDetailsController.latestUser.picture ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }
}
