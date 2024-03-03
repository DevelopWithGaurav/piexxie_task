import 'package:flutter/material.dart';
import 'package:piexxie_task/extensions.dart';
import 'package:piexxie_task/view/screens/user_details_screen.dart';

import '../../data/models/response/user_model.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.requiredUser,
    required this.index,
  });

  final UserModel requiredUser;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(userID: requiredUser.id ?? ''),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : 12),
        height: 80,
        width: double.maxFinite,
        child: Stack(
          children: [
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(left: 65),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      '${requiredUser.title} ${requiredUser.firstName} ${requiredUser.lastName}'.capitalizeFirstOfEach,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Text('test@test.com'),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade300,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Image.network(
                  requiredUser.picture ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
