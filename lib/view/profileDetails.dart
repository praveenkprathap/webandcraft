import 'package:flutter/material.dart';
import 'package:webandcraft/models/employee_model.dart';

class ProfileDetails extends StatefulWidget {
  final Employee emp;
  const ProfileDetails({Key? key, required this.emp}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsState();
  }
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Details"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: ClipOval(
              child: Image.network(
                widget.emp.profileImage ?? "",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/placeholder.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.emp.name ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.centerLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Name: ${widget.emp.username}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Email Address: ${widget.emp.email}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '''Address: 
                   ${widget.emp.address?.street}
                   ${widget.emp.address?.suite}
                   ${widget.emp.address?.city}
                   ${widget.emp.address?.zipcode}
                                ''',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '''Company Details:
                     ${widget.emp.company?.name}
                     ${widget.emp.company?.catchPhrase}
                     ${widget.emp.company?.bs}''',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ]),
          )
        ]),
      ),
    );
  }
}
