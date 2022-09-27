import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final _formKey = GlobalKey<FormState>();

  var newPhotoURL =
      'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png'; // default pic
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newPhotoController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPhotoController.dispose();
    super.dispose();
  }

  final FirebaseAuth firebaseAuth = GetIt.I.get();
  User? get currentUser => firebaseAuth.currentUser;

  changeProfilePic() async {
    try {
      await currentUser!.updatePhotoURL(newPhotoURL);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Your Profile has been Changed',
              style: TextStyle(fontSize: 18.0),
            )),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context, "Change Profile"),
        body: ListView(
          children: [
            SizedBox(height: 30),
            buildListTile(
                image:
                    'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png'),
            SizedBox(height: 30),
            SizedBox(height: 30),
            buildListTile(
                image:
                    'https://thumbs.dreamstime.com/z/cartoon-carot-150984192.jpg'),
            SizedBox(height: 30),
            buildListTile(
              image:
                  'https://img.freepik.com/premium-vector/grape-muscular-cartoon-cartoon-mascot-vector_193274-6103.jpg?w=740',
            ),
            SizedBox(height: 30),
            buildListTile(
              image:
                  'https://img.freepik.com/premium-vector/cute-bread-character-with-joyful-emotions-happy-face-smile-arms-legs-bakery-homemade-pastry-with-funny-expression-pose-vector-flat-illustration_427567-3914.jpg?w=740',
            ),
            SizedBox(height: 30),
            buildListTile(
              image:
                  'https://img.freepik.com/premium-vector/ice-cream-waffle-cone-dessert-cartoon-character_8071-8861.jpg?w=740',
            ),
            SizedBox(height: 30),
            buildListTile(
              image:
                  'https://img.freepik.com/premium-vector/cheese-character-listens-music-with-sings_8071-12310.jpg?w=740',
            ),
            SizedBox(height: 30),
            buildListTile(
              image:
                  'https://www.kindpng.com/picc/m/6-63784_steve-drawing-at-getdrawings-pizza-steve-hd-png.png',
            ),
            SizedBox(height: 30),
          ],
        ),
      );

  Widget buildListTile({
    @required String? image,
    //ImageProvider? image,
  }) =>
      GestureDetector(
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            //backgroundImage: NetworkImage(image.toString()),
            radius: 70.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(image.toString()))),
        onTap: () {
          newPhotoURL = image.toString();
          changeProfilePic();
        },
        // Image tapped
      );
}
