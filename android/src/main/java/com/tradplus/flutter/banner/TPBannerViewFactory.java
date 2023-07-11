package com.tradplus.flutter.banner;

import android.content.Context;

import com.tradplus.flutter.nativead.TPNativeAdView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TPBannerViewFactory  extends PlatformViewFactory {
    BinaryMessenger messenger;

    public TPBannerViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new TPBannerAdView(context, messenger,  params);
    }
}
