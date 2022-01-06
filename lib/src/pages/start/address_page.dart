import 'package:apple_market/src/constants/common_size.dart';
import 'package:apple_market/src/model/address_model.dart';
import 'package:apple_market/src/model/address_modelXY.dart';
import 'package:apple_market/src/utils/logger.dart';
import 'package:apple_market/src/pages/start/address_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;
  final List<AddressModelXY> _addressModelXYList = [];
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("AddressPage >> build");

    return SafeArea(
      minimum: const EdgeInsets.only(left: padding_16, right: padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: onClickTextField,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              prefixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 24),
            ),
          ),
          TextButton.icon(
            label: Text(
              _isGettingLocation ? '위치 찾는중 ~~' : '현재위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: myLocation,
            icon: _isGettingLocation
                ? const SizedBox(
                    child: CircularProgressIndicator(color: Colors.white),
                    height: 20,
                    width: 20,
                  )
                : const Icon(
                    CupertinoIcons.compass,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          if (_addressModel != null)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: padding_16),
                // shrinkWrap: true,
                itemCount: (_addressModel == null ||
                        _addressModel!.result == null ||
                        _addressModel!.result!.items == null)
                    ? 0
                    : _addressModel!.result!.items!.length,
                itemBuilder: (context, index) {
                  if (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null ||
                      _addressModel!.result!.items![index].address == null ||
                      _addressModel!.result!.items![index].address!.parcel == null) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(_addressModel!.result!.items![index].address!.road ?? '');
                    },
                    leading: ExtendedImage.asset('assets/imgs/apple.png'),
                    title: Text(_addressModel!.result!.items![index].address!.road ?? ''),
                    subtitle: Text(_addressModel!.result!.items![index].address!.parcel ?? ''),
                  );
                },
              ),
            ),
          if (_addressModelXYList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: padding_16),
                // shrinkWrap: true,
                itemCount: _addressModelXYList.length,
                itemBuilder: (context, index) {
                  if (_addressModelXYList[index].result == null ||
                      _addressModelXYList[index].result!.isEmpty) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(_addressModelXYList[index].result![0].text ?? '');
                    },
                    leading: ExtendedImage.asset('assets/imgs/apple.png'),
                    title: Text(_addressModelXYList[index].result![0].text ?? ''),
                    subtitle: Text(_addressModelXYList[index].result![0].zipcode ?? ''),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  _saveAddressAndGoToNextPage(String address) async {
    await _saveAddressOnSharedPreference(address);
    context.read<PageController>().animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  _saveAddressOnSharedPreference(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.d('save Address: $address.');
    await prefs.setString('address', address);
  }

  void onClickTextField(text) async {
    _addressModelXYList.clear();
    _addressModel = await AddressService().searchAddressByStr(text);
    setState(() {});
  }

  void onClickSearchAddress() async {
    final text = _addressController.text;
    logger.d('text:' + text);
    if (text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      _addressModel = await AddressService().searchAddressByStr(text);
      setState(() {});
    }
    logger.d('address_page >> on Text Button Clicked !!!');
  }

  void myLocation() async {
    _addressModel = null;
    _addressModelXYList.clear();

    setState(() {
      _isGettingLocation = true;
    });
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    logger.d('_locationData: ${_locationData.toString()}');
    List<AddressModelXY> _addressModelXY = await AddressService().findAddressByCoordinate(
        // log: _locationData.longitude!, lat: _locationData.latitude!);
        log: 126.978275264,
        lat: 37.566642192);
    _addressModelXYList.addAll(_addressModelXY);

    setState(() {
      _isGettingLocation = false;
    });
  }
}
