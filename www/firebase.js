var exec = require('cordova/exec')

module.exports = {
  initialize: function (admobAppId) {
    return new Promise(
      function (resolve, reject) {
        exec(resolve, reject, 'FirebasePlugin', 'initialize', [admobAppId]);
      }
    )
  },
  admob: {
    addTestDevice: function (deviceId) {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'admobAddTestDevice', [deviceId]);
        }
      )
    },
    getTestDevices: function () {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'admobGetTestDevices', []);
        }
      )
    },
    requestInterstitial: function () {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'admobRequestInterstitial', []);
        }
      )
    },
    setInterstitialAdUnitId: function (adUnitId) {
      return new Promise(
        function(resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'admobSetInterstitialAdUnitId', [adUnitId]);
        }
      )
    },
    showInterstitial: function () {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'admobShowInterstitial', []);
        }
      )
    }
  },
  analytics: {
    logEvent: function (eventName, eventParams) {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'analyticsLogEvent', [eventName, eventParams || {}])
        }
      )
    },
    setUserId: function (userId) {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'analyticsSetUserId', [userId])
        }
      )
    }
  },
  iid: {
    getToken: function () {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'iidGetToken', [])
        }
      )
    }
  },
  messaging: {
    enableNotifications: function () {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'messagingEnableNotifications', [])
        }
      )
    }
  }
}
