// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:image/image.dart' as img;

class ScanPrinterController extends GetxController {
  List<PrinterBluetooth> bluetoothPrinter = [];
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  @override
  onInit() {
    super.onInit();
    scanDevices();
  }

  scanDevices() {
    printerManager.startScan(Duration(seconds: 4));

    printerManager.scanResults.listen((printers) async {
      // store found printers
      print("printers ${printers}");
      if (printers.isNotEmpty) {
        bluetoothPrinter = printers;
      }
      update();
    });
  }

  Future<void> selectPrinter(PrinterBluetooth printer) async {

    printerManager.selectPrinter(printer);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final PosPrintResult res =
    await printerManager.printTicket((await demoReceipt(paper, profile)),chunkSizeBytes: 150,queueSleepTimeMs: 10);
    // StickerViewController stickerViewController =
    //     Get.put(StickerViewController());
    // final profile = await CapabilityProfile.load();
    // final generator = Generator(PaperSize.mm58, profile);
    // img.Image image = img.decodeImage(stickerViewController.capturedSS)!;
    // List<int> bytes = generator.image(image);
    // // print(bytes);
    //
    // List<int> imageBytes=[];
    // imageBytes.addAll(generator.imageRaster(image,imageFn: PosImageFn.graphics));
    // imageBytes.addAll(generator.cut());
    // print(imageBytes);
    // final PosPrintResult res = await printerManager
    //     .printTicket(imageBytes, queueSleepTimeMs: 30000);
    // print('Print result: ${res.msg}');
    // printText();
  }

  Future<List<int>> ticket(List<int> imageBytesList, CapabilityProfile profile) async {
    print("imageBytesList$imageBytesList");
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    img.Image? image =await  img.decodeImage(imageBytesList);
    if (image!=null) {
      bytes.addAll(generator.imageRaster(image,imageFn: PosImageFn.graphics));
      bytes.addAll(generator.cut());
    }

    return bytes;
  }

  Future<List<int>> demoReceipt(
      PaperSize paper, CapabilityProfile profile) async {
    StickerViewController stickerViewController =
    Get.put(StickerViewController());
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    final img.Image image = img.decodeImage(stickerViewController.capturedSS)!;
    bytes += ticket.image(image);
    bytes += ticket.feed(1);

    bytes += ticket.cut();
  return bytes;
  }

  Future<void> printText() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    bytes += generator.text(
      'Hello, Ajay How are you!',
      styles: PosStyles(
        align: PosAlign.left,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    );
    bytes += generator.text('Good Morning !!');
    bytes += generator.cut();

    final PosPrintResult res = await printerManager.printTicket(bytes);
    if (res == PosPrintResult.success) {
      print('Print success');
    } else {
      print('Print failed: $res');
    }
  }

/*  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> devices = [];
  BluetoothDevice? _device;
  bool _connected = false;

  @override
  onInit() {
    super.onInit();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      devices = await bluetooth.getBondedDevices();
      update();
    } on PlatformException {
      print("object");
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          _connected = true;
          print("bluetooth device state: connected");

          break;
        case BlueThermalPrinter.DISCONNECTED:
          _connected = false;
          print("bluetooth device state: disconnected");

          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          _connected = false;
          print("bluetooth device state: disconnect requested");

          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          _connected = false;
          print("bluetooth device state: bluetooth turning off");

          break;
        case BlueThermalPrinter.STATE_OFF:
          _connected = false;
          print("bluetooth device state: bluetooth off");

          break;
        case BlueThermalPrinter.STATE_ON:
          _connected = false;
          print("bluetooth device state: bluetooth on");

          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          _connected = false;
          print("bluetooth device state: bluetooth turning on");

          break;
        case BlueThermalPrinter.ERROR:
          _connected = false;
          print("bluetooth device state: error");

          break;
        default:
          print(state);
          break;
      }
    });
  }

  Future<void> selectPrinter(BluetoothDevice device) async {
    bool? connected = false;
    connected = await bluetooth.isDeviceConnected(device);
    if (!connected!) {
      var resultConnection = await bluetooth.connect(device);
      print(resultConnection);
    }

    printImage();
  }

  void printImage()async {
    bluetooth.printNewLine();
    StickerViewController stickerViewController =
    Get.put(StickerViewController());
    var image = img.decodePng(stickerViewController.capturedSS);

    // resize
    var thumbnail =
    img.copyResize(image!, interpolation: img.Interpolation.nearest, height: 200);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    var  bytes = generator.imageRaster(thumbnail, align: PosAlign.center);

    var result=await bluetooth.printImageBytes(Uint8List.fromList(bytes));
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.drawerPin2();
    // bluetooth.printNewLine();

    bluetooth.disconnect();
    print(result);
    // List<Uint8List> imgList = [];
    // img.Image? receiptImg = img.decodePng(stickerViewController.capturedSS);
*//*
    if (receiptImg != null) {
      for (var i = 0; i <= receiptImg.height; i += 320) {
        img.Image cropedReceiptImg =
            img.copyCrop(receiptImg, x: 0, y: i, width: 320, height: 200);

        Uint8List bytes = img.encodePng(cropedReceiptImg);

        imgList.add(bytes);
      }

      imgList.forEach((element) {
        bluetooth.printImageBytes(element);
      });
    }*//*
  }*/
}
