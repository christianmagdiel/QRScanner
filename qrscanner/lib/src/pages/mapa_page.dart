import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets';
  List<String> mapas = ['streets', 'dark', 'light', 'outdoors', 'satellite'];
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearbotonFlotante(context),
    );
  }

 Widget _crearbotonFlotante(BuildContext context) {
   return FloatingActionButton(
     child: Icon(Icons.repeat),
     backgroundColor: Theme.of(context).primaryColor,
     onPressed: (){
       // streets, dark, light, outdoors, satellite
       setState(() {
        for(int i = 0; i<= mapas.length-1;i++){
          if (tipoMapa == mapas[i]){
            if((i+1)> mapas.length-1){
              tipoMapa = mapas[0];
            }else{
            tipoMapa = mapas[i+1];
            } 
            return;
          }
        }
      });
     },
   );
 }

 Widget _crearFlutterMap(ScanModel scan) {
   return FlutterMap(
     mapController: map,
     options: MapOptions(
       center: scan.getLatLng(),
       zoom: 15
     ),
     layers: [
       _crearMapa(),
       _crearMarcadores(scan)
     ],
   );
 }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken'   : 'pk.eyJ1IjoiY2hyaXN0aWFubWFnZGllbCIsImEiOiJjazJxZzE3bnMwZXBwM2N1aXg0MHNlOXZ1In0.7yxe66WcKPu9CQCaKUTBUg',
        'id'            : 'mapbox.$tipoMapa' // streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers:  <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 40.0, 
              color: Theme.of(context).primaryColor),
          )
        )
      ]
    );
  }
}