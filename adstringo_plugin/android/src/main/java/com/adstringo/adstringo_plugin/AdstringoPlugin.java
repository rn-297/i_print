package com.adstringo.adstringo_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import android.content.Context;
import android.util.Log;

/** AdstringoPlugin */
public class AdstringoPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "image_picker_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getFiles")) {
      result.success(getFiles(call.argument("type")));
    } else {
      result.notImplemented();
    }
  }

  private List<String> getFiles(String type) {
    List<String> pdfPaths = new ArrayList<>();
    final File[] appsDir = context.getExternalFilesDirs(null);

    for(int i=0;i< appsDir.length;i++) {
      File file=appsDir[i];
      String a = file.getAbsolutePath();
      File dir = new File(a.split("/Android/")[0]);
//      Log.d("My Data", dir.getPath());
      List<String>emptyList=new ArrayList<>();
      List<String> pdfPathsFromDir = walkDir(dir,emptyList,type); // Get PDF paths from the directory
      pdfPaths.addAll(pdfPathsFromDir);
    }

    // Process files in batches
   /* int totalFiles = pdfPaths.size();
    for (int i = 0; i < totalFiles; i += BATCH_SIZE) {
      int endIndex = Math.min(i + BATCH_SIZE, totalFiles);
      List<String> batch = pdfPaths.subList(i, endIndex);

      // Use a Handler to post the batch to the main thread
      Handler handler = new Handler(Looper.getMainLooper());
      handler.post(() -> callback.onBatchProcessed(batch));
    }*/

    return pdfPaths;
  }


  private List<String> walkDir(File dir,List<String> filepath,String type) {
    File[] listFile = dir.listFiles();

    if (listFile != null) {
      for (int i=0;i< listFile.length;i++) {
        File file=listFile[i];
        if (file.isDirectory()) {
          walkDir(file,filepath,type);
        } else {
//          Log.d("my_file", file.getPath());
          if (type.equals("All")&&(file.getAbsolutePath().endsWith(".pdf")||file.getAbsolutePath().endsWith(".docx"))){
            filepath.add(file.getAbsolutePath());
          }else if (type.equals("pdf")&&file.getAbsolutePath().endsWith(".pdf")) {
//            Log.d("my_file_pdf", file.getAbsolutePath());
            filepath.add(file.getAbsolutePath());
          }else if (type.equals("word")&&file.getAbsolutePath().endsWith(".docx")||file.getAbsolutePath().endsWith(".doc")) {
//            Log.d("my_file_pdf", file.getAbsolutePath());
            filepath.add(file.getAbsolutePath());
          }
        }
      }
    }
    return  filepath;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
