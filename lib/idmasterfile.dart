import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'uploadSrId.dart';
import 'db_helper.dart';
import 'package:sleek_button/sleek_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdMasterFile extends StatefulWidget {
  @override
  _IdMasterFile createState() => _IdMasterFile();
}

class _IdMasterFile extends State<IdMasterFile> {
  final db = RapidA();
  List loadIdList;
  bool exist = false;
  bool isLoading = true;
  Future loadId() async{
    var res = await db.displayId();
    if (!mounted) return;
    setState(() {
      loadIdList = res['user_details'];
      isLoading = false;
    });
  }
  Future delete(id) async{
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 1.0, vertical: 20.0),
          title: Text(
            'Notice',
            style: TextStyle(fontSize: 18.0),
          ),
          content: SingleChildScrollView(
            child:Padding(
                padding:EdgeInsets.fromLTRB(25.0, 0.0, 20.0, 0.0),
                child: Text("Hello, do you want to delete this ID?")
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop();
                loadId();
              },
            ),
            TextButton(
              child: Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              onPressed: () async{
                 Navigator.of(context).pop();
                 await db.delete(id);
                 loadId();
                 checkIfHasId();
              },
            ),
          ],
        );
      },
    );
  }

  Future checkIfHasId() async{
    var res = await db.checkIfHasId();
    if (!mounted) return;
    setState(() {
      if(res == 'true'){
        exist = true;
      }else{
        exist = false;
      }
    });
  }

  @override
  void initState() {
    loadId();
    checkIfHasId();
    super.initState();
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,size: 23,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Your Discounted IDs",style: GoogleFonts.openSans(color:Colors.black54,fontWeight: FontWeight.bold,fontSize: 18.0),),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child:RefreshIndicator(
              onRefresh: loadId,
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    exist == false ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight / 3.0),
                      child: Center(
                        child:Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              child: SvgPicture.asset("assets/svg/inbox.svg"),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text("You have no discounted ID's yet",style: TextStyle(fontSize: 19,),),
                          ],
                        ),
                      ),
                      ) : ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: loadIdList == null ? 0 : loadIdList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var q = index;
                          q++;
                          return Padding(
                            padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                            child: Container(
                              height: 120.0,
                              child: Padding(
                                padding:EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('$q. ${loadIdList[index]['name']}',style: TextStyle(fontSize: 17,),),
                                    Text(' ${loadIdList[index]['discount_percent']} Off ${loadIdList[index]['discount_name']} # ${loadIdList[index]['discount_no']}',style: TextStyle(color:Colors.black,fontSize: 17  ,),),
                                    // ListTile(
                                    //   title: Text('$q. ${loadIdList[index]['name']}',style: TextStyle(fontSize: 17,),),
                                    //   subtitle: Text(' ${loadIdList[index]['discount_percent']} Off ${loadIdList[index]['discount_name']} # ${loadIdList[index]['id_number']}',style: TextStyle(color:Colors.black,fontSize: 17  ,),),
                                    // ),
                                    ButtonBar(
                                      children: <Widget>[
                                        // OutlineButton(
                                        //   highlightedBorderColor: Colors.black,
                                        //   highlightColor: Colors.transparent,
                                        //   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                        //   child: Icon(Icons.edit_outlined,color: Colors.black,),
                                        //   onPressed: () {
                                        //
                                        //   },
                                        // ),
                                        OutlineButton(
                                          highlightedBorderColor: Colors.black,
                                          highlightColor: Colors.transparent,
                                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                          child: Icon(Icons.delete_outline_outlined,color: Colors.black),
                                          onPressed: () {
                                            delete(loadIdList[index]['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 2.0,
                ),
                Flexible(
                  child: SleekButton(
                    onTap: () async {
                      await Navigator.of(context).push(addIds());
                      loadId();
                      checkIfHasId();
                    },
                    style: SleekButtonStyle.flat(
                      color: Colors.deepOrange,
                      inverted: false,
                      rounded: true,
                      size: SleekButtonSize.big,
                      context: context,
                    ),
                    child: Center(
                      child: Text("Add new +", style:TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


Route addIds(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => UploadSrImage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.decelerate;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
