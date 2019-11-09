import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/direcciones_page.dart';
import 'package:qrscanner/src/pages/mapas_pages.dart';
import 'package:qrscanner/src/utils/utils.dart' as utils;


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScansTodos,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearFloatingActionButton(),
    );
  }

  Widget  _crearFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => _scanQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _scanQR(BuildContext context) async {
    // https://www.google.com/
    //geo:40  .702113217917734,-74.01246443232424
     String futureString = '';
    try{
      futureString = await new QRCodeReader().scan();
    }catch(ex){
      futureString = ex.toString();
    }

    if (futureString != null){
      final scan = ScanModel(valor: futureString);
      //DBProvider.db.nuevoScan(scan); No notifica el cambio
      scansBloc.agregarScan(scan);

      if (Platform.isIOS){
        Future. delayed(Duration(milliseconds: 750),(){
          utils.abrirScan(scan, context);
        });
      }else{
        utils.abrirScan(scan, context);
      }
    }
  }

  Widget _callPage(int paginaActual){
    switch( paginaActual ){
      case 0 : return MapasPages();
      case 1 : return DireccionesPage();
      default: 
        return MapasPages();
    }
  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) { setState(() => currentIndex = index); },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }

}