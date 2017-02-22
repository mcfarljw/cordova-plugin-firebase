package com.jernung.plugins.firebase;

import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

public class PluginInstanceIdService extends FirebaseInstanceIdService {

    private static final String PLUGIN_NAME = "FirebasePlugin";

    @Override
    public void onTokenRefresh() {
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        Log.d(PLUGIN_NAME, "Refreshed token: " + refreshedToken);
    }

}
