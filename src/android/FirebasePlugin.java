package com.jernung.plugins.firebase;

import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.iid.FirebaseInstanceId;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FirebasePlugin extends CordovaPlugin {

    private static final String PLUGIN_NAME = "FirebasePlugin";

    private InterstitialAd mAdmobInterstitialAd;
    private JSONArray mAdmobTestDeviceIds;
    private FirebaseAnalytics mAnalytics;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        mAdmobInterstitialAd = new InterstitialAd(cordova.getActivity());
        mAdmobTestDeviceIds = new JSONArray();
        mAnalytics = FirebaseAnalytics.getInstance(cordova.getActivity());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("initialize".equals(action)) {
            callbackContext.success();

            return true;
        }

        if ("admobAddTestDevice".equals(action)) {
            admobAddTestDevice(args.getString(0));
            callbackContext.success(admobGetTestDevices());
            return true;
        }

        if ("admobGetTestDevices".equals(action)) {
            callbackContext.success(admobGetTestDevices());
            return true;
        }

        if ("admobRequestInterstitial".equals(action)) {
            admobRequestNewInterstitial();
            return true;
        }

        if ("admobSetInterstitialAdUnitId".equals(action)) {
            String adUnitId = args.getString(0);
            admobSetInterstitialAdUnitId(adUnitId);
            return true;
        }

        if ("admobShowInterstitial".equals(action)) {
            admobShowInterstitial();
            return true;
        }

        if ("analyticsLogEvent".equals(action)) {
            String eventName = args.getString(0);
            JSONObject eventParams = args.getJSONObject(1);

            analyticsLogEvent(eventName, eventParams);

            return true;
        }

        if ("analyticsSetUserId".equals(action)) {
            analyticsSetUserId(args.getString(0));

            return true;
        }

        if ("iidGetToken".equals(action)) {
            callbackContext.success(iidGetToken());

            return true;
        }

        if ("messagingEnableNotifications".equals(action)) {
            callbackContext.success();

            return true;
        }

        return false;
    }

    private void admobAddTestDevice(final String deviceId) {
        mAdmobTestDeviceIds.put(deviceId);
    }

    private Boolean admobCanRequestNewAd() {
        return !mAdmobInterstitialAd.isLoaded() && !mAdmobInterstitialAd.isLoading();
    }

    private JSONArray admobGetTestDevices() {
        return mAdmobTestDeviceIds;
    }

    private void admobRequestNewInterstitial() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                AdRequest.Builder adRequest = new AdRequest.Builder()
                        .addTestDevice(AdRequest.DEVICE_ID_EMULATOR);

                try {
                    for (int i = 0; i < mAdmobTestDeviceIds.length(); i++) {
                        adRequest.addTestDevice(mAdmobTestDeviceIds.getString(i));
                    }
                } catch (JSONException error) {
                    Log.e(PLUGIN_NAME, error.getMessage());
                }

                if (admobCanRequestNewAd()) {
                    mAdmobInterstitialAd.loadAd(adRequest.build());
                }
            }
        });
    }

    private void admobSetInterstitialAdUnitId(final String adUnitId) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                mAdmobInterstitialAd.setAdUnitId(adUnitId);
                mAdmobInterstitialAd.setAdListener(
                        new AdListener() {
                            @Override
                            public void onAdClosed() {
                                admobRequestNewInterstitial();
                            }
                        }
                );

                admobRequestNewInterstitial();
            }
        });
    }

    private void admobShowInterstitial() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (mAdmobInterstitialAd.isLoaded()) {
                    mAdmobInterstitialAd.show();
                } else {
                    admobRequestNewInterstitial();
                }
            }
        });
    }

    private void analyticsLogEvent(final String eventName, final JSONObject eventParams) {
        try {
            final Bundle params = PluginUtils.jsonToBundle(eventParams);

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    mAnalytics.logEvent(eventName, params);
                }
            });
        } catch (Exception error) {
            Log.e(PLUGIN_NAME, error.getMessage());
        }
    }

    private void analyticsSetUserId(final String userId) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                mAnalytics.setUserId(userId);
            }
        });
    }

    private String iidGetToken() {
        return FirebaseInstanceId.getInstance().getToken();
    }

}
