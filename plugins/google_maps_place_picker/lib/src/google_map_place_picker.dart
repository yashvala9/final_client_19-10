import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/components/animated_pin.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
    this.showResultInFloatingCard = false,
    this.pickerType = LocationPickerType.Auto,
    required this.locationPinIcon,
    required this.cardButtonText,
    required this.cardLocationPinIcon,
    required this.enabledDarkMode,
    required this.enablePinShadow,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResult>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final bool? selectInitialPosition;

  final String? language;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;
  final bool showResultInFloatingCard;
  final LocationPickerType pickerType;
  final Widget locationPinIcon;
  final String cardButtonText;
  final dynamic cardLocationPinIcon;
  final bool enabledDarkMode;
  final bool enablePinShadow;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    if (forceSearchOnZoomChanged == false &&
        provider.prevCameraPosition != null &&
        provider.prevCameraPosition!.target.latitude ==
            provider.cameraPosition!.target.latitude &&
        provider.prevCameraPosition!.target.longitude ==
            provider.cameraPosition!.target.longitude) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(
          lat: provider.cameraPosition!.target.latitude,
          lng: provider.cameraPosition!.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage!);
      if (onSearchFailed != null) {
        onSearchFailed!(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch!) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        print("Fetching details by placeId Error: " +
            detailResponse.errorMessage!);
        if (onSearchFailed != null) {
          onSearchFailed!(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }

    provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        _buildFloatingCard(
          floatingCard: showResultInFloatingCard,
          pickerType: pickerType,
        ),
        _buildMapIcons(context),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,

            onMapCreated: (GoogleMapController controller) {
              if (enabledDarkMode) {
                controller.setMapStyle(MapThemes.nightTheme);
              }
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;

              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                provider.placeSearchingState = SearchingState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                    _searchByCameraLocation(provider);
                  });
                }
              }

              provider.pinState = PinState.Idle;
            },
            onCameraMoveStarted: () {
              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer?.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              // Begins the search state if the hide details is enabled
              if (hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.Searching;
              }

              onMoveStart!();
            },
            onCameraMove: (CameraPosition position) {
              provider.setCameraPosition(position);
            },
            // gestureRecognizers make it possible to navigate the map when it's a
            // child in a scroll view e.g ListView, SingleChildScrollView...
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                locationPinIcon,
                const SizedBox(height: 42),
              ],
            ),
          ),
          if (enablePinShadow)
            Center(
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                  child: locationPinIcon,
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
          if (enablePinShadow)
            Center(
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildFloatingCard({
    bool floatingCard = true,
    LocationPickerType pickerType = LocationPickerType.Auto,
  }) {
    return Selector<PlaceProvider,
        Tuple4<PickResult?, SearchingState, bool, PinState>>(
      selector: (_, provider) => Tuple4(
          provider.selectedPlace,
          provider.placeSearchingState,
          provider.isSearchBarFocused,
          provider.pinState),
      builder: (context, data, __) {
        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
            data.item3 == true ||
            data.item4 == PinState.Dragging &&
                hidePlaceDetailsWhenDraggingPin!) {
          return const SizedBox.shrink();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return _defaultPlaceWidgetBuilder(
              context,
              data.item1,
              data.item2,
              isFloatingCard: floatingCard,
              pickerType: pickerType,
            );
          } else {
            return Builder(
              builder: (builderContext) => selectedPlaceWidgetBuilder!(
                builderContext,
                data.item1,
                data.item2,
                data.item3,
              ),
            );
          }
        }
      },
    );
  }

  Widget _defaultPlaceWidgetBuilder(
    BuildContext context,
    PickResult? data,
    SearchingState state, {
    bool isFloatingCard = false,
    LocationPickerType pickerType = LocationPickerType.Auto,
  }) {
    if (pickerType == LocationPickerType.Auto && !isFloatingCard) {
      return FloatingCard(
        bottomPosition:
            isFloatingCard ? MediaQuery.of(context).size.height * 0.05 : 0,
        leftPosition:
            isFloatingCard ? MediaQuery.of(context).size.width * 0.025 : 0,
        rightPosition:
            isFloatingCard ? MediaQuery.of(context).size.width * 0.025 : 0,
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(isFloatingCard ? 12.0 : 0),
        elevation: 4.0,
        color: Theme.of(context).cardColor,
        child: state == SearchingState.Searching
            ? _buildLoadingIndicator(context)
            : _buildSelectionDetailsWithIcon(context, data!),
      );
    } else {
      return FloatingCard(
        bottomPosition:
            isFloatingCard ? MediaQuery.of(context).size.height * 0.05 : 0,
        leftPosition:
            isFloatingCard ? MediaQuery.of(context).size.width * 0.025 : 0,
        rightPosition:
            isFloatingCard ? MediaQuery.of(context).size.width * 0.025 : 0,
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(isFloatingCard ? 12.0 : 0),
        elevation: 4.0,
        color: Theme.of(context).cardColor,
        child: state == SearchingState.Searching
            ? _buildLoadingIndicator(context)
            : _buildSelectionDetails(context, data!),
      );
    }
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.formattedAddress!,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              onPlacePicked!(result);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: Colors.green,
              ),
            ),
            minWidth: double.maxFinite,
            // height: Get.height * 0.06,
            child: Center(
              child: Text(
                cardButtonText,
                style: Theme.of(context).textTheme.button?.copyWith(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.28,
                    ),
              ),
            ),
          ),
          // MaterialButton(
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          //   color: Theme.of(context).primaryColor,
          //   child: Text(
          //     cardButtonText,
          //     style: Theme.of(context).textTheme.button,
          //   ),
          //   onPressed: () {
          //     onPlacePicked!(result);
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildSelectionDetailsWithIcon(
    BuildContext context,
    PickResult result,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.zero,
          // radius: 0,
          // padding: const EdgeInsets.all(10),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      cardLocationPinIcon.runtimeType == IconData
                          ? Icon(
                              cardLocationPinIcon ?? Icons.location_pin,
                              size: Theme.of(context).iconTheme.size,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            )
                          : cardLocationPinIcon as Widget,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          result.name ?? 'Select Location',
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 18,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    result.formattedAddress ?? "",
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),
                ),
                // if (pickerType == LocationPickerType.Auto)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: MaterialButton(
                        onPressed: onMyLocation,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        minWidth: double.maxFinite,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.my_location_rounded,
                              size: Theme.of(context).iconTheme.size,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              'Use Current Location',
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.fontSize,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.28,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  minWidth: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Text(
                    cardButtonText,
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    onPlacePicked!(result);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapIcons(BuildContext context) {
    final RenderBox appBarRenderBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox;

    return Positioned(
      top: appBarRenderBox.size.height,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMapTypeButton!
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onToggleMapType,
                    child: const Icon(Icons.layers),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          enableMyLocationButton! &&
                  (pickerType != LocationPickerType.Auto &&
                      !showResultInFloatingCard)
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onMyLocation,
                    child: const Icon(Icons.my_location),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
