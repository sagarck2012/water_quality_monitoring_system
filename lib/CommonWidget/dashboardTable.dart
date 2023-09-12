import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DynamicTable extends StatelessWidget {
  final List<dynamic> doValues;
  final List<dynamic> phValues;
  final List<dynamic> tempValues;
  final List<dynamic> data_time;
  final String Location;
  final int totalRow;

  DynamicTable({
    Key? key,
    required this.doValues,
    required this.phValues,
    required this.tempValues,
    required this.data_time,
    required this.Location,
    required this.totalRow,
  }) : super(key: key);

  int get numberOfRows => totalRow ?? 0;
  final int numberOfColumns = 5;
  List<dynamic> columnNames = ["Location","DO","PH","Temp","Date"];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),
        headingRowColor: MaterialStatePropertyAll(Color.lerp(Colors.pink, Colors.white,BorderSide.strokeAlignCenter)),
        dataRowColor: MaterialStatePropertyAll(Color.lerp(Colors.white12, Colors.white10, BorderSide.strokeAlignCenter)),
        dataTextStyle: TextStyle(color: Colors.brown),
        border: TableBorder(
          top: BorderSide(color: Colors.black45),
          left: BorderSide(color: Colors.black45),
          right: BorderSide(color: Colors.black45),
          bottom: BorderSide(color: Colors.black45),
        ),
        columns: List.generate(
          numberOfColumns,
              (index) => DataColumn(
            label: Text('${columnNames[index]}'),
          ),
        ),
        rows: List.generate(
          numberOfRows,
              (rowIndex) =>
              DataRow(
                cells: List.generate(
                  numberOfColumns,
                      (colIndex) {
                    dynamic cellValue;
                    if (colIndex == 0) {
                      cellValue = Location;
                    }
                    else if (colIndex == 1) {
                      cellValue = doValues[rowIndex].toString();
                    } else if (colIndex == 2) {
                      // PH Column
                      cellValue = phValues[rowIndex].toString();
                    } else if (colIndex == 3) {
                      // Temp Column
                      cellValue = tempValues[rowIndex].toString();
                    } else {
                      // Date_Time Column
                      final DateTime dateTime = DateTime.parse(data_time[rowIndex].toString());
                      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
                      final String formattedDateTime = formatter.format(dateTime);
                      cellValue = formattedDateTime; // For other columns
                    }
                    return DataCell(
                      Text(cellValue),
                    );
                  },
                ),
              ),
        ),
      ),
    );
  }
}


// class DynamicTable extends StatefulWidget {
//
//   final List<dynamic> doValues;
//   final List<dynamic> phValues;
//   final List<dynamic> tempValues;
//   final List<dynamic> data_time;
//   final String Location;
//   final int totalRow;
//
//   const DynamicTable({super.key,required this.doValues ,required this.phValues,required this.tempValues,required this.data_time,required this.Location,required this.totalRow });
//   @override
//   State<DynamicTable> createState() => _DynamicTableState();
// }
//
// class _DynamicTableState extends State<DynamicTable> {
//   //bool isLoading = true;
//
//   final int numberOfRows = widget.totalRow;
//   final int numberOfColumns = 5;
//
//   // Number of columns
//   List<dynamic> columnNames = ["Location","DO","PH","Temp","Date"];
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         headingTextStyle: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),
//         headingRowColor: MaterialStatePropertyAll(Color.lerp(Colors.cyan, Colors.white,BorderSide.strokeAlignCenter)),
//         dataRowColor: MaterialStatePropertyAll(Color.lerp(Colors.white12, Colors.white10, BorderSide.strokeAlignCenter)),
//          dataTextStyle: TextStyle(color: Colors.brown),
//             border: TableBorder(
//               top: BorderSide(color: Colors.black45),
//               left: BorderSide(color: Colors.black45),
//               right: BorderSide(color: Colors.black45),
//               bottom: BorderSide(color: Colors.black45),
//             ),
//         columns: List.generate(
//           numberOfColumns,
//               (index) => DataColumn(
//             label: Text('${columnNames[index]}'),
//           ),
//         ),
//         rows: List.generate(
//           numberOfRows,
//               (rowIndex) =>
//                 DataRow(
//             cells: List.generate(
//               numberOfColumns,
//                   (colIndex) {
//                 dynamic cellValue;
//                 if (colIndex == 0) {
//                   cellValue = widget.Location;
//                 }
//                 else if (colIndex == 1) {
//                   cellValue = widget.doValues[rowIndex].toString();
//                 } else if (colIndex == 2) {
//                   // PH Column
//                   cellValue = widget.phValues[rowIndex].toString();
//                 } else if (colIndex == 3) {
//                   // Temp Column
//                   cellValue = widget.tempValues[rowIndex].toString();
//                 } else {
//                   // Date_Time Column
//                   final DateTime dateTime = DateTime.parse(widget.data_time[rowIndex].toString());
//                   final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
//                   final String formattedDateTime = formatter.format(dateTime);
//                   cellValue = formattedDateTime; // For other columns
//                 }
//                 return DataCell(
//                   Text(cellValue),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//



































class DateTimeFormatter extends StatelessWidget {
  final String dateTimeString = '2023-06-27T04:50:41Z';

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');
    final String formattedDateTime = formatter.format(dateTime);

    return Text(
      formattedDateTime,
      style: TextStyle(fontSize: 18),
    );
  }
}
