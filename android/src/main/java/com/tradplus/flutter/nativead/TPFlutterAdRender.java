package com.tradplus.flutter.nativead;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.tradplus.ads.base.GlobalTradPlus;
import com.tradplus.ads.base.adapter.nativead.TPNativeAdView;
import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.flutter.Const;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.Map;

public class TPFlutterAdRender extends TPNativeAdRender {
    private FrameLayout adLayout;
    private Context mContext;
    private Map<String, Object> settingParams;

    public TPFlutterAdRender(Map<String, Object> params) {
        settingParams = params;
        mContext = TradPlusSdk.getInstance().getApplicationContext();
        adLayout = new FrameLayout(mContext);
    }

    @Override
    public ViewGroup createAdLayoutView() {
        if (adLayout == null) {
            return null;
        }

        if (adLayout.getParent() != null) {
            ((ViewGroup) adLayout.getParent()).removeView(adLayout);
        }


        try {
            Map<String, Object> rootMap = (Map<String, Object>) settingParams.get(Const.Native.parent);

            if (rootMap != null) {
                int rootWidth = TPUtils.dip2px(mContext, (double) rootMap.get(Const.WIDTH));
                int rootHeight = TPUtils.dip2px(mContext, (double) rootMap.get(Const.HEIGHT));
                if (rootWidth != 0 && rootHeight != 0) {
                    FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(rootWidth, rootHeight);
                    adLayout.setLayoutParams(layoutParams);

                }
                String rootBGC = (String) rootMap.get(Const.BACKGROUND_COLOR);
                if (!TextUtils.isEmpty(rootBGC)) {
                    adLayout.setBackgroundColor(Color.parseColor(rootBGC));
                }
            }

            TextView titleView = new TextView(mContext);
            boolean titleClick = TPNativeViewInfo.addToParentView(adLayout, titleView, (Map<String, Object>) settingParams.get(Const.Native.title), -1);
            setTitleView(titleView, titleClick);

            TextView descView = new TextView(mContext);
            boolean descClick = TPNativeViewInfo.addToParentView(adLayout, descView, (Map<String, Object>) settingParams.get(Const.Native.desc), -1);
            setSubTitleView(descView, descClick);

            TextView ctaView = new TextView(mContext);
            boolean ctaClick = TPNativeViewInfo.addToParentView(adLayout, ctaView, (Map<String, Object>) settingParams.get(Const.Native.cta), -1);
            setCallToActionView(ctaView, ctaClick);

            ImageView imgMainView = new ImageView(mContext);
            boolean mainImageClick = TPNativeViewInfo.addToParentView(adLayout, imgMainView, (Map<String, Object>) settingParams.get(Const.Native.mainImage), -1);
            setImageView(imgMainView, mainImageClick);

            ImageView IconView = new ImageView(mContext);
            boolean iconClick = TPNativeViewInfo.addToParentView(adLayout, IconView, (Map<String, Object>) settingParams.get(Const.Native.icon), -1);
            setIconView(IconView, iconClick);

            ImageView adLogoView = new ImageView(mContext);
            boolean logoClick = TPNativeViewInfo.addToParentView(adLayout, adLogoView, (Map<String, Object>) settingParams.get(Const.Native.adLogo), -1);
            setAdChoiceView(adLogoView, logoClick);

            FrameLayout adChoiceView = new FrameLayout(mContext);
            boolean choiceViewClick = TPNativeViewInfo.addToParentView(adLayout, adChoiceView, (Map<String, Object>) settingParams.get(Const.Native.adLogo), -1);
            setAdChoicesContainer(adChoiceView, choiceViewClick);

        }catch (Exception e){
            e.printStackTrace();
        }
        return adLayout;
    }

}
