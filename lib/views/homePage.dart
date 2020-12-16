import 'package:MachineTest/providers/employeeProvider.dart';
import 'package:MachineTest/views/employeeDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _searchController = TextEditingController();
  @override
  void initState() {

    super.initState();
    getData();
  }

  void getData(){
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      var box = Hive.box('employeeDb');
      if(box.containsKey('employees')){
        print('Contain');
        Provider.of<EmployeeProvider>(context, listen: false).getEmployeeData();
      } else {
        print('Not Contain');
        Provider.of<EmployeeProvider>(context, listen: false).getAllEmployees();
      }
    });

  }

  onItemChanged(String value) {
    Provider.of<EmployeeProvider>(context, listen: false).updateSearchQuery(value);
  }

  @override
  Widget build(BuildContext context) {
    final _employeeProvider =  Provider.of<EmployeeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Employees Data",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          ),
          centerTitle: true,
        ),
        body: _employeeProvider.employeeList != null ? Column(
          children: [
            SizedBox(height: 10,),
            _searchBar(),
            SizedBox(height: 10,),
            Expanded(child: _productListContainer()),
          ],
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _searchBar(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  controller: _searchController,
                  onChanged: onItemChanged,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.blue,
                    ),
                    hintText: "Enter employee name / email id",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black.withAlpha(90),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productListContainer(){
    final _employeeProvider =  Provider.of<EmployeeProvider>(context).employeeList;

    return ListView.separated(itemBuilder: (context, index){
      return _employeeTile(_employeeProvider[index]);
    }, separatorBuilder: (context, index){
      return  Container(
        height: 1.0,
        color: Colors.green[100],
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
      );
    }, itemCount: _employeeProvider.length);
  }

  Widget _employeeTile(var data){
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeDetails(employeeData: data,))),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data["profile_image"] != null ? data["profile_image"] : "https://www.seekpng.com/png/full/349-3499598_portrait-placeholder-placeholder-person.png",
                  placeholder: (context, url) => Image.asset('assets/images/placeholder_men.jpg'),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
            Flexible(
              child: Text("${data["name"]}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
            )]
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Flexible(
                      child: Text('${data["email"]}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                    )
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
