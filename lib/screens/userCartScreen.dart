

/*

















class UserCartScreen extends StatelessWidget {
  static const String routeName = "/userCartScreen";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final viewCartBloc = BlocProvider.of<ViewCartBloc>(context);
    viewCartBloc.add(
      ViewCart(
        firebaseUID: FirebaseAuth.instance.currentUser.uid,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 42.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PreviousPageIconButton(
                color: Colors.pinkAccent,
              ),
              SizedBox(
                height: 16.0,
              ),
              CartTitle(
                text1: "My",
                text2: "Cart",
                text3: "🛍️",
              ),
              SizedBox(
                height: 18.0,
              ),
              UserCartList(),
              TotalCostBox(size: size),
              NeumorphicRoundedButton(
                size: size,
                text: "Checkout",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/