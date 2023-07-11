package com.tradplus.flutter.splash;

import android.content.Context;

import com.tradplus.flutter.banner.TPBannerAdView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TPSplashViewFactory  extends PlatformViewFactory {
    BinaryMessenger messenger;

    public TPSplashViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new TPSplashAdView(context, messenger,  params);
    }
}
