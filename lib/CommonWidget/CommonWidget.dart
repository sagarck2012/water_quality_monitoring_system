import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class StartButton extends StatelessWidget {
  final String buttonName;
  final Widget page;
  const StartButton({
    super.key,
    required this.buttonName,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.fromLTRB(40, 7, 40, 0),
      width:  double.infinity,
      child:
      MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );

        },
        child: FittedBox(
          child: Text(
            '$buttonName',
            style:  GoogleFonts.notoSans (
              fontSize: 24,
              fontWeight: FontWeight.w500,
              height: 1.3625,
              color: Color(0xff008BE7),
            ),
          ),
        ),
        color: Colors.white, // set background color to white
        textColor: Color(0xff008be7),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Color(0xffffffff)), // add border
        ),
      ),
    );
  }
}


// -------------------------------  Colored Card Widget *-------------------------------------------


class ColoredCardWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Color color;
  final String cardText;
  final VoidCallback onPressed;

  ColoredCardWidget({
    required this.screenHeight,
    required this.screenWidth,
    required this.color,
    required this.cardText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth * 0.4;
    double cardHeight = screenHeight * 0.2;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            cardText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
// ------------------------------- Loading View -----------------------


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return  const LoadingIndicator(
        indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget

    );
  }
}





// ---------------------------------------  Toast Message  -----------------------------------


class ToastMessage {
  static void show(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}




// ---------------------------------------  SnackBar Message  -----------------------------------


class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}



// ---------------------------------------  Alert Message  -----------------------------------



class Alert extends StatelessWidget {
  final String message;
  const Alert({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(message),
      // content: Text('Device creation failed. Device Already Exist.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the alert dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}


// ---------------------------- Registration Input Field -------------------------------Taken from Login email Field -------------------------

class InputField extends StatefulWidget{
  final hintsText;
  final keyType;
  final Function(String) onChanged;

  InputField(this.keyType,this.hintsText,this.onChanged);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController _controller = TextEditingController();

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: false,
      keyboardType: TextInputType.text,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null; // Return null to allow empty input
        }
        return null; // Validation passed
      },
      decoration: InputDecoration(
        hintText: widget.hintsText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}



// ------------------------------- Button ---------------------------

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({super.key, required this.onPressed,required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(

        onPressed: onPressed,
        icon: const Icon(Icons.arrow_circle_right),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Set the radius here
          ),
        ),
      ),
    );
  }
}


// ------------------------------------- variable ------------------------------

class  select {
  static var selectedOption;
}

class  JWTID {
  static var ID;
}


// ------------------------------   Profile Page         -------------------------------
class StyledText extends StatelessWidget {
  final String text;

  StyledText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22, // Adjust the font size as needed
        fontWeight: FontWeight.bold, // Adjust the font weight
        color: Colors.black, // Adjust the text color
      ),
    );
  }
}


// ------------------------------   token        -------------------------------
class tokenValue {
  static var token;
}