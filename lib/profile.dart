import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/user/userInfo.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("User Details"),
),
       body: Center(
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: Column(

             crossAxisAlignment: CrossAxisAlignment.start,

             children: [
               Align(
                 child: Text("User Details",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w800,color: Colors.purple,shadows: [
                   Shadow(
                     offset: Offset(2.0, 2.0), // Adjust the shadow offset
                     color: Colors.black26.withOpacity(0.2), // Adjust the shadow color and opacity
                     blurRadius: 2.0, // Adjust the shadow blur radius
                   ),
                 ],),),
               ),
               SizedBox(height: 20,),
               Row(
                 children: [
                   UserProfileAvatar(icon: Icons.person, iconColor: Colors.white, backgroundColor: Colors.black26!,),
                   SizedBox(width: 10,),
                   StyledText(text: "${userInfo.userName}"),
                 ],
               ),
               SizedBox(height: 10,),
               Row(
                 children: [
                   UserProfileAvatar(icon: Icons.email_outlined, iconColor: Colors.white, backgroundColor: Colors.black26!,),
                   SizedBox(width: 10,),
                   StyledText(text:"${userInfo.userEmail}"),
                 ],
               ),
               SizedBox(height: 10,),
               Row(
                 children: [
                   UserProfileAvatar(icon: userInfo.Staff=="Not Staff"?Icons.work_off_outlined: Icons.work, iconColor: Colors.white, backgroundColor: Colors.black26!,),
                   SizedBox(width: 10,),
                   StyledText(text: "${userInfo.Staff}"),
                 ],
               ),SizedBox(height: 10,),
               Row(
                 children: [
                   UserProfileAvatar(icon:Icons.phone, iconColor: Colors.white, backgroundColor: Colors.black26!,),
                   SizedBox(width: 10,),
                   StyledText(text: "${userInfo.userPhoneNumber}"),
                 ],
               ),




             ],
           ),
         ),

       )
    );
  }
}


class UserProfileAvatar extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  UserProfileAvatar({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0, // Adjust the radius as needed
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: 40.0, // Adjust the icon size as needed
        color: iconColor,
      ),
    );
  }
}