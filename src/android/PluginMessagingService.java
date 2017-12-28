package com.jernung.plugins.firebase;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class PluginMessagingService extends FirebaseMessagingService {

    private static final String PLUGIN_NAME = "FirebaseMessagingPlugin";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d(PLUGIN_NAME, "From: " + remoteMessage.getFrom());

        if (remoteMessage.getData().size() > 0) {
            Log.d(PLUGIN_NAME, "Data: " + remoteMessage.getData());
        }
        if (remoteMessage.getNotification() != null) {
            Log.d(PLUGIN_NAME, "Body: " + remoteMessage.getNotification().getBody());
        }
    }

}
