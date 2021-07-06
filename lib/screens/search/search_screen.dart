import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carpoolapp/data_handler/appData.dart';
import 'package:carpoolapp/Assistants/requestAssistant.dart';
import 'package:carpoolapp/models/placePredictions.dart';
import 'package:carpoolapp/models/address.dart';

class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {

  TextEditingController pickUptextEditingController = TextEditingController();
  TextEditingController dropOfftextEditingController = TextEditingController();
  List<placePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUptextEditingController.text = placeAddress;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ]
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                          },
                            child: Icon(Icons.arrow_back)
                        ),
                        Center(
                          child: Text("Set Drop Off"),
                        )
                      ],
                    ),

                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        Icon(Icons.search),

                        SizedBox(width: 18.0,),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val){
                                  findPlace(val);
                                },
                                controller: pickUptextEditingController,
                                decoration: InputDecoration(
                                  hintText: "PickUp Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10.0,),

                    Row(
                      children: [
                        Icon(Icons.map),

                        SizedBox(width: 18.0,),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val){
                                  findPlace(val);
                                },
                                controller: dropOfftextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Where to?",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.0,),
            (placePredictionList.length > 0)
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index){
                  return PredictionTile(placepredictions: placePredictionList[index],);
                },
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemCount: placePredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            )
                : Container(), //tile for displaying predictions

          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async{
    if(placeName.length>1){
      String autoCompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=ADD_KEY_HERE&sessiontoken=1234567890&components=country:pk";

      var res = await RequestAssistant.getRequest(autoCompleteURL);

      if(res == "failed"){
        return;
      }

      if(res["status"] == "OK"){
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => placePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {

  final placePredictions placepredictions;

  PredictionTile({Key key, this.placepredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAddressDetails(placepredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0,),
                      Text(placepredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placepredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async{

    String placeDetailsurl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=ADD_KEY_HERE";

    var res = await RequestAssistant.getRequest(placeDetailsurl);

    if(res == "failed"){
      return;
    }

    if(res["status"] == "OK"){
      userAddress address = userAddress();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("This is Drop Off Location :: ");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}
