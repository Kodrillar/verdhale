import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart" as latlng;
import 'package:verdhale/src/models/service_price_model.dart';
import 'package:verdhale/src/screens/vaccination/vaccination_discount_screen.dart';

import '../../components/bottom_navigation_bar/flow_bottom_navigation_bar.dart';
import '../../components/button/auth_button.dart';
import '../../utils/constant.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: buildBottomAppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 700,
            child: FlutterMap(
              options: MapOptions(
                center: latlng.LatLng(8.94582, 7.06331),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/kdrillar/cl39uqcrh006714lauwb67fj1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2RyaWxsYXIiLCJhIjoiY2wzOXVvdnUwMDFhdDNicWx4b254NHBobiJ9.Q6VYmEsTdIE7W-r9SAZ-sQ",
                    additionalOptions: {
                      "accessToken":
                          "pk.eyJ1Ijoia2RyaWxsYXIiLCJhIjoiY2wzOXVvdnUwMDFhdDNicWx4b254NHBobiJ9.Q6VYmEsTdIE7W-r9SAZ-sQ",
                      "id": "mapbox.mapbox-streets-v8"
                    }),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latlng.LatLng(8.95682, 7.06631),
                      builder: (ctx) => SizedBox(
                        child: Image.asset("assets/images/location.png"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        color: kGreenColor,
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Location",
        style: kAppBarTextStyle,
      ),
    );
  }

  buildBottomAppBar() {
    return FlowBottomNavigationBar(
      child: AuthButton(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const VaccinationDiscountScreen();
              },
            ),
          );
        },
        buttonName: "Proceed",
      ),
    );
  }
}
