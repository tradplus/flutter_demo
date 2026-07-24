package com.tradplus.flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tradplus.flutter.banner.TPBannerViewFactory;
import com.tradplus.flutter.interactive.TPInterActiveViewFactory;
import com.tradplus.flutter.nativead.TPNativeViewFactory;
import com.tradplus.flutter.splash.TPSplashViewFactory;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/** TradPlus Flutter plugin. */
public class TradplusFlutterPlugin implements FlutterPlugin, ActivityAware,
        MethodChannel.MethodCallHandler, EventChannel.StreamHandler,
        TradPlusSdk.CallbackDispatcher {
    @Nullable
    private FlutterPluginBinding engineBinding;
    @Nullable
    private MethodChannel methodChannel;
    @Nullable
    private EventChannel eventChannel;
    @Nullable
    private EventChannel.EventSink eventSink;
    private boolean useEventChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        engineBinding = binding;

        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "tradplus_sdk");
        methodChannel.setMethodCallHandler(this);
        eventChannel = new EventChannel(binding.getBinaryMessenger(), "tradplus_sdk_events");
        eventChannel.setStreamHandler(this);

        registerOwnerOnlyViewFactory(binding, "tp_native_view",
                new TPNativeViewFactory(binding.getBinaryMessenger()));
        registerOwnerOnlyViewFactory(binding, "tp_banner_view",
                new TPBannerViewFactory(binding.getBinaryMessenger()));
        registerOwnerOnlyViewFactory(binding, "tp_splash_view",
                new TPSplashViewFactory(binding.getBinaryMessenger()));
        registerOwnerOnlyViewFactory(binding, "tp_interactive_view",
                new TPInterActiveViewFactory(binding.getBinaryMessenger()));

        TradPlusSdk.getInstance().attachEngine(binding, binding.getApplicationContext(), this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        TradPlusSdk.getInstance().detachEngine(binding);
        if (eventChannel != null) {
            eventChannel.setStreamHandler(null);
            eventChannel = null;
        }
        eventSink = null;
        useEventChannel = false;
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
        engineBinding = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        FlutterPluginBinding binding = engineBinding;
        if (binding == null) {
            result.error("tradplus_engine_detached", "The FlutterEngine is detached.", null);
            return;
        }
        if (call.method.equals("tp_setEventChannel")) {
            Boolean isOpen = call.argument("isOpen");
            useEventChannel = Boolean.TRUE.equals(isOpen);
            result.success(null);
            return;
        }
        TradPlusSdk.getInstance().onMethodCall(binding, this, call, result);
    }

    @Override
    public void onListen(Object arguments, @NonNull EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Override
    public void sendCallback(@NonNull String callName, @NonNull Map<String, Object> params) {
        new Handler(Looper.getMainLooper()).post(() -> {
            EventChannel.EventSink sink = eventSink;
            MethodChannel channel = methodChannel;
            try {
                if (sink != null && useEventChannel) {
                    Map<String, Object> event = new HashMap<>();
                    event.put("method", callName);
                    event.put("data", params);
                    sink.success(event);
                } else if (channel != null) {
                    channel.invokeMethod(callName, params);
                }
            } catch (RuntimeException ignored) {
                // The Engine may detach while a native SDK callback is in flight.
            }
        });
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityBinding) {
        if (engineBinding != null) {
            TradPlusSdk.getInstance().attachActivity(engineBinding, activityBinding.getActivity());
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        if (engineBinding != null) {
            TradPlusSdk.getInstance().detachActivityForConfigChanges(engineBinding);
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(
            @NonNull ActivityPluginBinding activityBinding) {
        onAttachedToActivity(activityBinding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (engineBinding != null) {
            TradPlusSdk.getInstance().detachActivity(engineBinding);
        }
    }

    private void registerOwnerOnlyViewFactory(
            @NonNull FlutterPluginBinding binding,
            @NonNull String viewType,
            @NonNull PlatformViewFactory delegate) {
        binding.getPlatformViewRegistry().registerViewFactory(viewType,
                new PlatformViewFactory(StandardMessageCodec.INSTANCE) {
                    @Override
                    public PlatformView create(Context context, int viewId, Object args) {
                        if (!TradPlusSdk.getInstance().isActivityOwner(binding)) {
                            throw new IllegalStateException(
                                    "TradPlus PlatformViews require the Activity owner Engine");
                        }
                        return delegate.create(context, viewId, args);
                    }
                });
    }
}
