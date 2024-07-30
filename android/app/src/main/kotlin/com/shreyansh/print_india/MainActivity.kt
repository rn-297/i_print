package com.shreyansh.print_india

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity()/*{
    private val CHANNEL = "iPrintFilePicker"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "getPdfFiles") {
                val pdfFiles = getPdfFiles()

                if (!pdfFiles.isEmpty()) {
                    result.success(pdfFiles)
                } else {
                    result.error("UNAVAILABLE", "Pdf Files not available.", null)
                }
            } else if (call.method == "getWordFiles") {
                val wordFiles = getWordFiles()

                if (!wordFiles.isEmpty()) {
                    result.success(wordFiles)
                } else {
                    result.error("UNAVAILABLE", "Word Files not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }


    private fun getPdfFiles(): List<String> {
        android.util.Log.d("TAG_RN", "getPdfFiles: 1")
        val pdfPaths = mutableListOf<String>()
        android.util.Log.d("TAG_RN", "getPdfFiles: 2")

        val appsDir = getExternalFilesDirs(null)
        android.util.Log.d("TAG_RN", "getPdfFiles: 3")

        for (file in appsDir) {
            val dir = File(file.absolutePath.split("Android/")[0])
            android.util.Log.d("TAG_RN", "getPdfFiles: "+dir)
            val emptyList = mutableListOf<String>()
            val pdfPathsFromDir = walkDirForFiles(dir, emptyList, ".pdf")
            pdfPaths.addAll(pdfPathsFromDir)
        }
        android.util.Log.d("TAG_RN", "getPdfFiles: 4")

        return pdfPaths
    }

    private fun getWordFiles(): List<String> {
        android.util.Log.d("TAG_RN", "getWordFiles: 1")
        val wordPaths = mutableListOf<String>()
        android.util.Log.d("TAG_RN", "getWordFiles: 2")

        val appsDir = getExternalFilesDirs(null)
        android.util.Log.d("TAG_RN", "getWordFiles: 3")


        for (file in appsDir) {
            val dir = File(file.absolutePath.split("Android/")[0])
            val emptyList = mutableListOf<String>()
            val wordPathsFromDir = walkDirForFiles(dir, emptyList, ".docx")
            wordPaths.addAll(wordPathsFromDir)
        }
        android.util.Log.d("TAG_RN", "getWordFiles: 4")


        return wordPaths
    }

    private fun walkDirForFiles(dir: File, paths: MutableList<String>, extension: String): List<String> {
        try {android.util.Log.d("TAG_RN", "walkDirForFiles: 1")
            val files = dir.listFiles()
            android.util.Log.d("TAG_RN", "walkDirForFiles: 2"+dir)
            if (files != null) {
                android.util.Log.d("TAG_RN", "walkDirForFiles: 3")
                for (file in files) {
                    if (file.isDirectory) {
                        android.util.Log.d("TAG_RN", "walkDirForFiles: 4")
                        walkDirForFiles(file, paths, extension)
                    } else if (file.name.endsWith(extension)) {
                        paths.add(file.absolutePath)
                    }
                }
            }
        } catch (e: Exception) {
            android.util.Log.d("TAG_RN", "walkDirForFiles: Not yet implemented")
        }
        return paths
    }


}
*/