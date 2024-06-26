import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moovup_flutter/listing/people_list.dart';
import 'package:moovup_flutter/model/person.dart';

import '../bloc/main_bloc.dart';

class MapView extends StatefulWidget {
  final Person? person;

  const MapView({
    super.key,
    this.person,
  });

  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  CameraPosition initialCameraPosition = _kGooglePlex;

  @override
  initState() {
    super.initState();
    if (showSinglePerson()) {
      setState(() {
        generateMarkers(
          [widget.person!],
        );
      });
    } else {
      setState(() {
        generateMarkers(
          context.read<MainBloc>().state.people,
        );
      });
    }
  }

  bool showSinglePerson() {
    return widget.person != null;
  }

  CameraPosition getInitialCameraPosition() {
    if (showSinglePerson()) {
      return CameraPosition(
        target: LatLng(widget.person?.lat ?? -1, widget.person?.lng ?? -1),
        zoom: 14.0,
      );
    } else {
      return initialCameraPosition;
    }
  }

  PreferredSizeWidget? getHeaderBar() {
    if (showSinglePerson()) {
      return AppBar(
        title: Text(
          widget.person?.getName() ?? "",
        ),
      );
    }
    return null;
  }

  void generateMarkers(List<Person> people) {
    Set<Marker> set = {};
    double minLng = -1;
    double maxLng = -1;
    double minLat = -1;
    double maxLat = -1;

    for (var p in people) {
      if (p.shouldShowInMap()) {
        if (minLng == -1 && maxLng == -1 && minLat == -1 && maxLat == -1) {
          minLng = p.lng!;
          maxLng = p.lng!;
          minLat = p.lat!;
          maxLat = p.lat!;
        }
        set.add(
          Marker(
            markerId: MarkerId(p.id),
            position: LatLng(
              p.lat ?? -1,
              p.lng ?? -1,
            ),
            infoWindow: InfoWindow(
              title: p.getName(),
            ),
          ),
        );
        minLat = min(p.lat!, minLat);
        maxLat = max(p.lat!, maxLat);
        minLng = min(p.lng!, minLng);
        maxLng = max(p.lng!, maxLng);
      }
    }
    initialCameraPosition = CameraPosition(
      target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
      zoom: 9.0,
    );
    markers = set;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MainBloc, MainBlocState>(
      listener: (_, state) => {
        setState(() {
          generateMarkers(context.read<MainBloc>().state.people);
        })
      },
      bloc: context.read(),
      builder: (context, state) {
        return Scaffold(
          appBar: getHeaderBar(),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getContentView(),
        );
      },
    );
  }

  Widget getContentView() {
    if (showSinglePerson()) {
      return Column(
        children: [
          Expanded(
            child: getGoogleMap(),
          ),
          PersonCard(
            person: widget.person!,
            withEmail: true,
            bottomInset: getBottomInsets(),
            onTapCallback: (Person person) {},
          ),
        ],
      );
    } else {
      return getGoogleMap();
    }
  }

  double getBottomInsets() {
    if (Platform.isAndroid) {
      return MediaQuery.of(context).padding.bottom + 16.0;
    } else {
      return MediaQuery.of(context).padding.bottom;
    }
  }

  GoogleMap getGoogleMap() {
    return GoogleMap(
      markers: markers,
      mapType: MapType.normal,
      initialCameraPosition: getInitialCameraPosition(),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
