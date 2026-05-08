package com.tradplus.flutter;

import androidx.annotation.NonNull;

import com.tradplus.flutter.TradPlusSdk;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** TradplusFlutterDemoPlugin */
public class TradplusFlutterPlugin implements FlutterPlugin, ActivityAware{

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    TradPlusSdk.getInstance().initPlugin(flutterPluginBinding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    TradPlusSdk.getInstance().detachPlugin();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    TradPlusSdk.getInstance().setActivity(activityPluginBinding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    TradPlusSdk.getInstance().setActivity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
    TradPlusSdk.getInstance().setActivity(activityPluginBinding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    TradPlusSdk.getInstance().setActivity(null);
  }
}
