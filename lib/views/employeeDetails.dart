import 'package:MachineTest/providers/employeeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDetails extends StatefulWidget {
  final dynamic employeeData;
  const EmployeeDetails({Key key, this.employeeData}) : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final appBar =  AppBar(
    title: Text("Employees Details",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    centerTitle: true,
  );


  @override
  Widget build(BuildContext context) {
    final _employeeProvider =  Provider.of<EmployeeProvider>(context).employeeList;

    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - appBar.preferredSize.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border : Border.all(
                    color: Colors.blue,
                    width: 2
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.employeeData["profile_image"] != null ? widget.employeeData["profile_image"] : "https://www.seekpng.com/png/full/349-3499598_portrait-placeholder-placeholder-person.png",
                    placeholder: (context, url) => Image.asset('assets/images/placeholder_men.jpg'),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("${ widget.employeeData["name"]}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),),
              SizedBox(height: 30,),

              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _employeeFeilds(title: "User Name", data: "${ widget.employeeData["username"]}"),
                    Divider(),
                    _employeeFeilds(title: "Email Address",  data: "${ widget.employeeData["username"]}"),
                    Divider(),
                    _employeeFeilds(title: "Address", data: "${widget.employeeData["address"]["street"]}, ${widget.employeeData["address"]["suite"]}, ${widget.employeeData["address"]["city"]}, ${widget.employeeData["address"]["zipcode"]}"),
                    Divider(),
                    _employeeFeilds(title: "Phone Number", data: widget.employeeData["phone"] != null ? '${widget.employeeData["phone"]}' : "Not available"),
                    Divider(),
                    _employeeFeilds(title: "Company Details", data: "${widget.employeeData["company"]["name"]}, ${widget.employeeData["company"]["catchPhrase"]}"),
                    Divider(),
                    _employeeFeilds(title: "Website", data: "${widget.employeeData["website"]}")
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    ));
  }

  Widget _employeeFeilds({String title, String data}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),),
          ),
          Text(":\t",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),),
          Expanded(child: Text(data,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),))
        ],
      ),
    );
  }
}
