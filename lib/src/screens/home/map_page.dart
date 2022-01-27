import 'package:apple_market/src/model/user_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapPage extends StatefulWidget {
  final UserModel _userModel;

  const MapPage(this._userModel, {Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;

  Offset? _dragStart;
  double _scaleData = 1.0;

  _scaleStart(ScaleStartDetails details) {
    // print('_scaleStart ${_dragStart.toString()}');
    _dragStart = details.focalPoint;
    _scaleData = 1.0;
  }

  _scaleUpdate(ScaleUpdateDetails details) {
    // print('_scaleUpdate ${details.scale.toString()}');
    var _scaleDiff = details.scale - _scaleData;
    _scaleData = details.scale;
    _mapController.zoom += _scaleDiff;

    final now = details.focalPoint;
    final diff = now - _dragStart!;
    _dragStart = now;
    _mapController.drag(diff.dx, diff.dy);
    setState(() {});
  }

  Widget _buildMarkerWidget(Offset offset, {Color color = Colors.red}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: 24,
      height: 24,
      child: Icon(
        Icons.location_on,
        color: color,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _mapController = MapController(
      location:
          LatLng(widget._userModel.geoFirePoint.latitude, widget._userModel.geoFirePoint.longitude),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapLayoutBuilder(
      builder: (BuildContext context, MapTransformer transformer) {
        final myLocationOnMap = transformer.fromLatLngToXYCoords(LatLng(
            widget._userModel.geoFirePoint.latitude, widget._userModel.geoFirePoint.longitude));

        final myLocationWidget = _buildMarkerWidget(myLocationOnMap, color: Colors.black87);

        return Stack(
          children: [
            GestureDetector(
              onScaleStart: _scaleStart,
              onScaleUpdate: _scaleUpdate,
              child: Map(
                controller: _mapController,
                builder: (context, x, y, z) {
                  //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                  //Google Maps
                  final url =
                      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                  final darkUrl =
                      'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0&key=AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU&token=31440';
                  //Mapbox Streets
                  // final url =
                  //     'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=YOUR_MAPBOX_ACCESS_TOKEN';

                  return ExtendedImage.network(
                    url,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            myLocationWidget,
          ],
        );
      },
      controller: _mapController,
    );
  }
}
