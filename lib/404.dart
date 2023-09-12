void main() {

  String studentGrade(String studentName , int testScore )
  {
    String grade="Invalid Grade";
    if(testScore>=0 && testScore<=59 ){
      return "F";
    }
    else if(testScore>=60 && testScore<=69 ){
      return "D";
    }
    else if(testScore>=70 && testScore<=79 ){
      return "C";
    }
    else if(testScore>=80 && testScore<=89 ){
      return "B";
    }
    else if(testScore>=90 && testScore<=100 ){
      return "A";
    }

    return grade;
  }

  String studentName = "T.M Moeen Uddin";  /// student name must be yours


  int testScore = 101;





  String grade = studentGrade(studentName, testScore);


  print("$studentName's grade: $grade");


}