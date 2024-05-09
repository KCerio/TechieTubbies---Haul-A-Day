import 'package:cloud_firestore/cloud_firestore.dart';

class teamMember{
  final String staffId;
  final String fullname;
  final String position;
  final String pictureUrl;
  bool isSelected;
  final String contactNum;

  teamMember(this.staffId, this.fullname, this.position, this.pictureUrl, this.isSelected, this.contactNum) {
  }

}

Future<List<teamMember>> getTeamList(String orderId) async {
  List<teamMember> teamList = [];

  try {
    // Query the Firestore collection "Orders/orderId/truckTeam"
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Order/$orderId/truckTeam')
        .get();

    // Iterate through the documents to extract staffIds
    List<String> staffIds = querySnapshot.docs.map((doc) => doc.id).toList();

    // Check if staffIds list is empty
    if (staffIds.isNotEmpty) {
      // Query the Users collection to get user details based on staffIds
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', whereIn: staffIds)
          .get();

      // Create teamMember objects with fullname and position and add them to the list
      userSnapshot.docs.forEach((userDoc) {
        String staffId = userDoc['staffId'];
        String firstname = userDoc['firstname'];
        String lastname = userDoc['lastname'];
        String fullname = '$firstname $lastname';
        String position = userDoc['position'];
        String pictureUrl = userDoc['pictureUrl'];
        String contactNum = userDoc['contactNumber'];
        bool isSelected = false; // Assuming 'position' is a field in the Users collection

        teamMember member = teamMember(
          staffId,
          fullname,
          position,
          pictureUrl,
          isSelected,
          contactNum
        );
        teamList.add(member);
      });
    } else {
      print('No staffIds found in truckTeam collection');
    }

    return teamList;

  } catch (e) {
    print('Error fetching team members: $e');
    // Handle the error accordingly
    throw e; // Re-throw the error to propagate it
  }
}
