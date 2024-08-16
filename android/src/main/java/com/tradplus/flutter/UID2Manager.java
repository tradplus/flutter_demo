package com.tradplus.flutter;

import android.util.Log;

import androidx.annotation.NonNull;

import android.text.TextUtils;

import com.data.uid2.adapter.TTDUID2Manager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class UID2Manager {

    private static UID2Manager sInstance;

    private UID2Manager() {
    }

    public synchronized static UID2Manager getInstance() {
        if (sInstance == null) {
            sInstance = new UID2Manager();
        }
        return sInstance;
    }

    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("uid2_start")) {
            uid2Start(call, result);
        }else if (call.method.equals("uid2_reset")) {
            uid2Reset(call, result);
        }
    }


    private void uid2Start(@NonNull MethodCall call, @NonNull MethodChannel.Result uidResult) {
        if(call != null) {
            String subscriptionId = (String)call.argument("subscriptionID");
            String publicKey = (String)call.argument("serverPublicKey");

            if (TextUtils.isEmpty(subscriptionId) || TextUtils.isEmpty(publicKey)) {
                Log.e("TradPlusLog", "subscriptionId or publicKey can't Empty");
                if (uidResult != null) {
                    uidResult.error("","","subscriptionId or publicKey can't Empty");
                }
                return;
            }

            HashMap<String, String> mLocalExtras = new HashMap<>();
            String email = (String)call.argument("email");
            if (!TextUtils.isEmpty(email)) {
                mLocalExtras.put("ttd_email", email);
            }

            String emailHash = (String)call.argument("emailHash");
            if (!TextUtils.isEmpty(emailHash)) {
                mLocalExtras.put("ttd_email_hash", emailHash);
            }

            String phone = (String)call.argument("phone");
            if (!TextUtils.isEmpty(phone)) {
                mLocalExtras.put("ttd_phone", phone);
            }

            String phoneHash = (String)call.argument("phoneHash");
            if (!TextUtils.isEmpty(phoneHash)) {
                mLocalExtras.put("ttd_phone_hash", phoneHash);
            }

            boolean isTestMode = (boolean)call.argument("isTestMode");
            mLocalExtras.put("ttd_test", isTestMode ? "true":"false");

            String customURLString = (String)call.argument("customURLString");
            if (!TextUtils.isEmpty(customURLString)) {
                mLocalExtras.put("ttd_server_url", customURLString);
            }


            try {
                TTDUID2Manager.getInstance().startUID2(TradPlusSdk.getInstance().getActivity(), subscriptionId, publicKey, mLocalExtras,
                        new TTDUID2Manager.ResultCallback() {
                            @Override
                            public void result(String result) {
                                Log.i("TradPlusLog", "TTDUID2Manager result: " + result);
                                if (uidResult != null) {
                                    if (result.contains("Success")) {
                                        uidResult.success(result);
                                    }else {
                                        uidResult.error(result,"","");
                                    }
                                }
                            }
                        });
            }catch(Throwable throwable) {
                throwable.printStackTrace();
                if (uidResult != null) {
                    uidResult.error("","","uid2 adapter not found");
                }
            }
        }

    }

    private void uid2Reset(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            TTDUID2Manager.getInstance().resetIdentity();
        } catch(Throwable throwable){
            throwable.printStackTrace();
        }
    }

}
