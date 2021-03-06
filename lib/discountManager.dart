import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'db_helper.dart';
import 'package:sleek_button/sleek_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'uploadSrId.dart';

class DiscountManager extends StatefulWidget {
  @override
  _DiscountManager createState() => _DiscountManager();
}


class _DiscountManager extends State<DiscountManager> {
  final db = RapidA();
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
        title: Text("Select discount",style: GoogleFonts.openSans(color:Colors.black54,fontWeight: FontWeight.bold,fontSize: 18.0),),
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child:Scrollbar(
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
                        TextButton(
                          child: Text(
                            'Tap here to upload',
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                          ),
                          onPressed: () async{
                            await Navigator.of(context).push(addIds());
                            checkIfHasId();
                            loadId();
                          },
                        ),
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
                        side.add(false);
                        return Padding(
                          padding:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                          child: Container(
                            height: 75.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CheckboxListTile(
                                  title: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('$q. ${loadIdList[index]['name']}',style: TextStyle(fontSize: 17,),),
                                          Text('    ${loadIdList[index]['discount_name']} # ${loadIdList[index]['discount_no']}',style: TextStyle(color:Colors.black,fontSize: 17  ,),),
                                        ],
                                      ),
                                      // Text('${loadIdList[index]['discount_name']} # ${loadIdList[index]['id_number']}',style: TextStyle(color:Colors.black,fontSize: 20  ,),),
                                    ],
                                  ),
                                  checkColor: Colors.deepOrange,
                                  value: side[index],
                                  onChanged: (bool value){
                                    setState(() {
                                     side[index] = value;
                                      if (value) {
                                        selectedDiscountType.add(loadIdList[index]['dicount_id']);
                                      }
                                      else{
                                        selectedDiscountType.remove(loadIdList[index]['dicount_id']);
                                      }
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                                // ListTile(
                                //   // title: Text(loadIdList[index]['discount_name'],style: TextStyle(fontSize: 24,),),
                                //   // subtitle: Text('${loadIdList[index]['name']}' ,style: TextStyle(fontSize: 18  ,),),
                                //   title: Text('$q. ${loadIdList[index]['name']}',style: TextStyle(fontSize: 24,),),
                                //   subtitle: Text('     ${loadIdList[index]['discount_name']} # ${loadIdList[index]['id_number']}',style: TextStyle(color:Colors.black,fontSize: 20  ,),),
                                // ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                  TextButton(
                    child: Text(
                      'Tap here to upload new ID',
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                    onPressed: () async{
                      await Navigator.of(context).push(addIds());
                      checkIfHasId();
                      loadId();
                    },
                  ),
                ],
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
                      Navigator.of(context).pop();
                    },
                    style: SleekButtonStyle.flat(
                      color: Colors.deepOrange,
                      inverted: false,
                      rounded: true,
                      size: SleekButtonSize.big,
                      context: context,
                    ),
                    child: Center(
                      child: Text("Back", style:TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 13.0),
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

