// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart' as bt;
import 'package:flutter_thermal_printer/utils/printer.dart' as bt1;
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class ScanPrinterController extends GetxController {
  // List<PrinterBluetooth> bluetoothPrinter = [];
  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  double copies = 1;
  final StickerViewController stickerViewController =
      Get.put(StickerViewController());

  final _flutterThermalPrinterPlugin = bt.FlutterThermalPrinter.instance;

  List<bt1.Printer> printers = [];

  bt1.Printer? selectedPrinter;
  bool isLoading = false;

  late StreamSubscription<List<bt1.Printer>> _devicesStreamSubscription;

  // @override
  // onInit() {
  //   super.onInit();
  //   requestBluetoothPermissions();
  //   scanDevices();
  // }

  // scanDevices() {
  //   printerManager.startScan(Duration(seconds: 4));
  //
  //   printerManager.scanResults.listen((printers) async {
  //     // store found printers
  //     print("printers ${printers}");
  //     if (printers.isNotEmpty) {
  //       bluetoothPrinter = printers;
  //     }
  //     update();
  //   });
  // }

  // Future<void> selectPrinter(PrinterBluetooth printer) async {
  //
  //   printerManager.selectPrinter(printer);
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final PosPrintResult res =
  //   await printerManager.printTicket((await demoReceipt(paper, profile)),chunkSizeBytes: 150,queueSleepTimeMs: 5);
  //   // StickerViewController stickerViewController =
  //   //     Get.put(StickerViewController());
  //   // final profile = await CapabilityProfile.load();
  //   // final generator = Generator(PaperSize.mm58, profile);
  //   // img.Image image = img.decodeImage(stickerViewController.capturedSS)!;
  //   // List<int> bytes = generator.image(image);
  //   // // print(bytes);
  //   //
  //   // List<int> imageBytes=[];
  //   // imageBytes.addAll(generator.imageRaster(image,imageFn: PosImageFn.graphics));
  //   // imageBytes.addAll(generator.cut());
  //   // print(imageBytes);
  //   // final PosPrintResult res = await printerManager
  //   //     .printTicket(imageBytes, queueSleepTimeMs: 30000);
  //   // print('Print result: ${res.msg}');
  //   // printText();
  // }

  Future<List<int>> ticket(
      Uint8List imageBytesList, CapabilityProfile profile) async {
    print("imageBytesList$imageBytesList");
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    img.Image? image = img.decodeImage(imageBytesList);
    if (image != null) {
      bytes.addAll(generator.imageRaster(image, imageFn: PosImageFn.graphics));
      bytes.addAll(generator.cut());
    }

    return bytes;
  }

  Future<List<int>> demoReceipt() async {
    // Future.delayed(Duration(seconds: 5));
    // _flutterThermalPrinterPlugin.connect(selectedPrinter!);
    /*StickerViewController stickerViewController = Get.find();
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    final img.Image image = img.decodeImage(stickerViewController.capturedSS)!;
    bytes += ticket.image(image);
    bytes += ticket.feed(1);

    bytes += ticket.cut();*/
    List<int> bytes = [];
    final img.Image image = img.decodeImage(stickerViewController.capturedSS)!;
    img.Image resized = img.copyResize(image, width: 384, maintainAspect: true);
    int resizedHeight = resized.height;
    int partHeight = 384;
    int numberOfParts = (resizedHeight / partHeight).ceil();

    List<img.Image> imageParts = [];

    // Divide the image into parts of 400 pixels each
    for (int i = 0; i < numberOfParts; i++) {
      int y = i * partHeight;
      int height =
          (y + partHeight > resizedHeight) ? resizedHeight - y : partHeight;

      img.Image part =
          img.copyCrop(resized, x: 0, y: y, width: 384, height: height);
      imageParts.add(part);
    }

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);

    // for (int i = 0; i < imageParts.length; i++) {
    //   bytes += generator.imageRaster(imageParts[i]);
    //   if (i == imageParts.length - 1) {
    //     bytes += generator.emptyLines(3);
    //   }
    //
    //   // Future.delayed(Duration(seconds: 10));
    //   // _flutterThermalPrinterPlugin.disconnect(selectedPrinter!);
    //   // Future.delayed(Duration(seconds: 5));
    //   // _flutterThermalPrinterPlugin.connect(selectedPrinter!);
    // }

    bytes += generator.imageRaster(resized);
    // bytes += generator.emptyLines(3);
    bytes += generator.cut();
    return bytes;

    // Future.delayed(Duration(seconds: 10));
    // _flutterThermalPrinterPlugin.disconnect(selectedPrinter!);
  }

  // Future<void> printLineCut() async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);
  //
  //   List<int> bytes = [];
  //   // bytes += generator.text(
  //   //   'Hello, Ajay How are you!',
  //   //   styles: PosStyles(
  //   //     align: PosAlign.left,
  //   //     height: PosTextSize.size1,
  //   //     width: PosTextSize.size1,
  //   //   ),
  //   //   linesAfter: 1,
  //   // );
  //   // bytes += generator.text('Good Morning !!');
  //   bytes += generator.cut();
  //
  //   final PosPrintResult res = await printerManager.printTicket(bytes);
  //   if (res == PosPrintResult.success) {
  //     print('Print success');
  //   } else {
  //     print('Print failed: $res');
  //   }
  // }

  //BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // List<PrinterDevice> devices = [];
  // PrinterDevice? selectedDevice;
  //
  // PrinterManager printerManager = PrinterManager.instance;

  final bool _connected = false;
  bool isDeviceConnected = false;

  @override
  onInit() {
    super.onInit();
    copies = 1;
    initPlatformState();
    // requestBluetoothPermissions();
    // getSelectedDeviceState();
    // scanDevices();
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetooth.isDenied) {
      print("here");
      await Permission.bluetooth.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      print("here1");

      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      print("here2");

      await Permission.bluetoothConnect.request();
    }

    if (await Permission.location.isDenied) {
      print("here3");

      await Permission.location.request();
    }
    print("here ____");
    print(await Permission.bluetooth.isDenied);
    print(await Permission.bluetoothConnect.isDenied);
    print(await Permission.bluetoothScan.isDenied);
    print(await Permission.location.isDenied);
    // if(){
    //   initPlatformState();
    // }
  }

  Future<void> initPlatformState() async {
    print("here");

    final profiles = await CapabilityProfile.getAvailableProfiles();
    print(profiles);
    _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
        .listen((List<bt1.Printer> event) {
      print(event.map((e) => e.name).toList().toString());
      // setState(() {
      printers = event;
      print(printers);
      printers
          .removeWhere((element) => element.name == null || element.name == '');
      update();
      // _flutterThermalPrinterPlugin.stopScan();
      // _devicesStreamSubscription?.cancel();
      // _devicesStreamSubscription?.cancel();

      // });
    });
    // _flutterThermalPrinterPlugin.stopScan();
  }

  Future<void> scanDevices() async {
    isLoading = true;
    Future.delayed(Duration.zero, () => update());
    /*try {
      List<PrinterDevice> devicesList = [];
      printerManager.stateBluetooth.listen((status) {
        print(' ----------------- status bt $status ------------------ ');

      });

      printerManager
          .discovery(type: PrinterType.bluetooth, isBle: true)
          .listen((device) async {
            print("here");
        devicesList.add(device);

        devices = devicesList;
        update();
      });


    } on PlatformException {
      print("object");
    }catch(ex){
      print(ex.toString());
    }*/

// if(){
//     var devices1 = await bluetooth.getBondedDevices();
//     print(devices1);
//     for (var device in devices1) {
//       devices.add(PrinterDevice(
//         name: device.name ?? "",
//         address: device.address ?? "",
//       ));
//     }
    _devicesStreamSubscription.cancel();
    await _flutterThermalPrinterPlugin.getPrinters();
    _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
        .listen((List<bt1.Printer> event) {
      print(event.map((e) => e.name).toList().toString());
      // setState(() {
      printers = event;
      print(printers);
      printers
          .removeWhere((element) => element.name == null || element.name == '');

      if (printers.isNotEmpty) {
        isLoading = false;
        _flutterThermalPrinterPlugin.stopScan();
        _devicesStreamSubscription.cancel();
        update();
      }
      print(printers);

      // });
    });
    // _devicesStreamSubscription?.cancel();
    // update();

// }

    // bluetooth.onStateChanged().listen((state)
    // {
    //   switch (state) {
    //     case BlueThermalPrinter.CONNECTED:
    //       _connected = true;
    //       isDeviceConnected = true;
    //       update();
    //       print("bluetooth device state: connected");
    //
    //       break;
    //     case BlueThermalPrinter.DISCONNECTED:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: disconnected");
    //
    //       break;
    //     case BlueThermalPrinter.DISCONNECT_REQUESTED:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: disconnect requested");
    //
    //       break;
    //     case BlueThermalPrinter.STATE_TURNING_OFF:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: bluetooth turning off");
    //
    //       break;
    //     case BlueThermalPrinter.STATE_OFF:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: bluetooth off");
    //
    //       break;
    //     case BlueThermalPrinter.STATE_ON:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: bluetooth on");
    //
    //       break;
    //     case BlueThermalPrinter.STATE_TURNING_ON:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: bluetooth turning on");
    //
    //       break;
    //     case BlueThermalPrinter.ERROR:
    //       _connected = false;
    //       isDeviceConnected = false;
    //       print("bluetooth device state: error");
    //
    //       break;
    //     default:
    //       print(state);
    //       break;
    //   }
    // });
  }

  Future<void> selectPrinter(bt1.Printer printer) async {
    // bool? connected = false;
    // connected = await bluetooth.isDeviceConnected(device);
    // if (!connected!) {
    //   var resultConnection = await bluetooth.connect(device);
    //   selectedDevice = device;
    //   isConnected = true;
    //   update();
    //   print(resultConnection);
    // }
    // selectedDevice = device;
    // isConnected = true;
    //
    // getSelectedDeviceState();

    // var result = await printerManager.connect(
    //     type: PrinterType.bluetooth,
    //     model: BluetoothPrinterInput(
    //         name: device.name,
    //         address: device.address!,
    //         isBle: true,
    //         autoConnect: true));
    // selectedDevice = device;
    // print(result);

    if (printer.isConnected ?? false) {
      print("already Connected");
      selectedPrinter = printer;
      isDeviceConnected = printer.isConnected ?? false;
      printImage();
    } else {
      final isConnected = await _flutterThermalPrinterPlugin.connect(printer);
      selectedPrinter = printer;
      isDeviceConnected = isConnected;
      if (isConnected) {
        printImage();
      } else {
        print("Error Connecting");
      }
    }
  }

  Future<void> getSelectedDeviceState() async {
    print("here1 ${selectedPrinter!.name}");
    bool connected = false;
    if (selectedPrinter != null) {
      print("object ${selectedPrinter!.isConnected!}");
      connected = selectedPrinter!.isConnected ?? false;
    }
    print("connected $connected");
    isDeviceConnected = connected;
    update();
    // print("_device $selectedDevice");
  }

  void printImage() async {
    // var image = img.decodePng(stickerViewController.capturedSS);

    // resize
    // var thumbnail = img.copyResize(image!,
    //     interpolation: img.Interpolation.nearest, height: 200);
    List<int> bytes = await demoReceipt();

    // final generator = Generator(PaperSize.mm80, profile);
    // var bytes = generator.imageRaster(thumbnail, align: PosAlign.center);
    print(stickerViewController.capturedSS.isNotEmpty);
    if (stickerViewController.capturedSS.isNotEmpty) {
      for (int i = 0; i < copies.round(); i++) {
        // var result = await printerManager.send(
        //     type: PrinterType.bluetooth, bytes: bytes);
        // var result = await printerManager1.printTicket(
        //      bytes,chunkSizeBytes: 150);
        // print("here done $result");
        bytes = await demoReceipt();
         _flutterThermalPrinterPlugin.printData(
          selectedPrinter!,
          bytes,
          longData: true,
        );
        // Future.delayed(const Duration(seconds: 15));

        /* var result =
            await bluetooth.printImageBytes(stickerViewController.capturedSS);
        await  Future.delayed(new Duration(seconds: 10));
            // await bluetooth.write("\n\n\nHello");
        await bluetooth.printNewLine();
        print("result1 $result");
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.printNewLine();
        print(result);
        result=await bluetooth.paperCut();
        await new Future.delayed(new Duration(seconds: 1));
        print("result cut $result");
*/
      }
      await _flutterThermalPrinterPlugin.printData(
        selectedPrinter!,
        bytes,
        longData: true,
      );
    }
    // bluetooth.printNewLine();
    // bluetooth.printNewLine();
    // bluetooth.drawerPin2();
    // // bluetooth.printNewLine();
    //
    // bluetooth.disconnect();
    // print(result);
    // // List<Uint8List> imgList = [];
    // img.Image? receiptImg = img.decodePng(stickerViewController.capturedSS);
    //
    // if (receiptImg != null) {
    //   for (var i = 0; i <= receiptImg.height; i += 320) {
    //     img.Image cropedReceiptImg =
    //         img.copyCrop(receiptImg, x: 0, y: i, width: 320, height: 200);
    //
    //     Uint8List bytes = img.encodePng(cropedReceiptImg);
    //
    //     imgList.add(bytes);
    //   }
    //
    //   imgList.forEach((element) {
    //     bluetooth.printImageBytes(element);
    //   });
    // }
  }
}
