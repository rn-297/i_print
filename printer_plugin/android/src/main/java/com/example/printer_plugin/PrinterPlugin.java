package com.example.printer_plugin;

import static android.app.Activity.RESULT_OK;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Toast;
import android.graphics.Bitmap;


import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel.Result;
import android.graphics.BitmapFactory;
import com.microlan.printersdk2.PrinterSDK;
import com.microlan.printersdk2.BluetoothManager;
import com.microlan.printersdk2.Utils;



import java.util.Set;

/** PrinterPlugin */
public class PrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
   private ArrayAdapter<BluetoothDevice> btDevices = null;
  static private final int REQUEST_ENABLE_BT = 0 * 1000;
  static private BluetoothAdapter mBluetoothAdapter = null;
  Context context;
  Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context=flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "printer_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getBluetoothDevices")) {
    } else if (call.method.equals("connectBluetoothDevice")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if (call.method.equals("printData")) {
        byte[] imageData = call.argument("imageData");
        Bitmap bmp = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
        printPhoto(bmp);
        result.success(null);
    } else {
      result.notImplemented();
    }
  }


  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity(); // Get Activity context here
  }

  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  public void onDetachedFromActivity() {
    this.activity = null;
  }


  private void printPhoto(Bitmap bmp) {
    // Your existing Android code here
//    loadingDialog.show();
    BluetoothManager bluetoothManager = BluetoothManager.getInstance(this.activity);
    BluetoothSocket bluetoothSocket = bluetoothManager.getBluetoothSocket();
    PrinterSDK printerSDK = new PrinterSDK(bluetoothSocket);
    Bitmap processedBitmap = printerSDK.resizeBitmap(bmp);
    processedBitmap = printerSDK.prepareImageForPrint(processedBitmap);
    byte[] command = Utils.decodeBitmap(processedBitmap);
    printerSDK.printText(command);
    printerSDK.printNewLine();
    printerSDK.printNewLine();
//    loadingDialog.cancel();
  }



  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
