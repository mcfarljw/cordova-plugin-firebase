package com.jernung.plugins.firebase;

import com.google.firebase.iid.FirebaseInstanceId;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

public class FirebasePlugin extends CordovaPlugin {

    private static final String PLUGIN_NAME = "FirebasePlugin";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("getId".equals(action)) {
            callbackContext.success(iidGetId());
            return true;
        }
        if ("getToken".equals(action)) {
            callbackContext.success(iidGetToken());
            return true;
        }

        return false;
    }

    private String iidGetId() {
        return FirebaseInstanceId.getInstance().getId();
    }

    private String iidGetToken() {
        return FirebaseInstanceId.getInstance().getToken();
    }

}
