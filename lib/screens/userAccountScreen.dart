
/*

class UserAccountScreen extends StatelessWidget {
  static const String routeName = "/userAccountScreen";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocBuilder<CompleteUserDataBloc, CompleteUserDataState>(
          builder: (context, userDataState) {
            return Container(
              margin: EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                top: 42.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PreviousPageIconButton(
                    color: Colors.amber,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CartTitle(
                    text1: "My",
                    text2: "Profile",
                    text3: "😃",
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  UserAvatar(
                    imageLocation: "assets/images/Boy.png",
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    // TODO: Replace it with the name of the user and give them an option to edit their name
                    userDataState.userData.name ?? "HUMAN",
                    style: TextStyle(
                      fontFamily: GoogleFonts.oxygen().fontFamily,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    // TODO: Replace it with the email of the user
                    userDataState.userData.email ?? "",
                    style: TextStyle(
                      fontFamily: GoogleFonts.oxygen().fontFamily,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  NeumorphicRectangularTileButton(
                    size: size,
                    leadingIcon: Icons.quick_contacts_dialer_outlined,
                    title: "Contact Us",
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ContactUsScreen.routeName);
                    },
                  ),
                  NeumorphicRectangularTileButton(
                    size: size,
                    leadingIcon: Icons.quick_contacts_dialer_outlined,
                    title: "Notifications",
                    onPressed: () {},
                  ),
                  NeumorphicRectangularTileButton(
                    size: size,
                    leadingIcon: Icons.quick_contacts_dialer_outlined,
                    title: "Sign Out",
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
*/