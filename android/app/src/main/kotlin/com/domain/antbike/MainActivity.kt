package com.domain.antbike

 
import android.os.Bundle
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.antbike/deviceFilter"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateDeviceFilter") {
        val vendorID = call.argument<String>("vendor_id") ?: ""
        val productID = call.argument<String>("product_id") ?: ""
        updateDeviceFilter(vendorID, productID)
        result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

private fun updateDeviceFilter(vendorID: String, productID: String) {
    // Log the values
    Log.d("DeviceFilter", "VendorID: $vendorID, ProductID: $productID")
    
    // You can now use the vendorID and productID for USB device filtering in your native Android code.
    // You may need to implement a BroadcastReceiver to handle USB device connections and disconnections.
}

}
