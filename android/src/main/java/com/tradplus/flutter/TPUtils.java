package com.tradplus.flutter;

import android.content.Context;
import android.content.res.Resources;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPRewardCallbackInfo;
import com.tradplus.ads.base.common.TPURLManager;
import com.tradplus.ads.common.serialization.JSON;
import com.tradplus.ads.common.serialization.TypeReference;

import java.util.HashMap;
import java.util.Map;

public class TPUtils {
    public static HashMap<String, String> tpAdInfoToMap(TPAdInfo tpAdInfo) {

        HashMap<String, String> infoMap = null;
        try{
            infoMap = JSON.parseObject(JSON.toJSONString(tpAdInfo), new TypeReference<HashMap<String, String>>() {});

        }catch (Exception e){

        }

        return infoMap;
    }

    public static HashMap<String, Object> tpErrorToMap(TPAdError tpAdError) {
        HashMap<String, Object> infoMap = new HashMap<>();
        try{
            infoMap.put("code", tpAdError.getErrorCode());
            infoMap.put("msg", tpAdError.getErrorMsg());
        }catch (Exception e){

        }

        return infoMap;
    }

    public static int getLayoutIdByName(Context context, String name){

        Resources resources = context.getResources();
        String packageName = context.getPackageName();

        int id = resources.getIdentifier(name, "layout", packageName);
        return id;
    }

    public static int dip2px(Context context, double dipValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5);
    }
}
