var exec = require('cordova/exec');

module.exports = {
  getId: function () {
    return new Promise(
      function (resolve, reject) {
        exec(resolve, reject, 'FirebasePlugin', 'getId', []);
      }
    );
  },
  getToken: function () {
    return new Promise(
      function (resolve, reject) {
        exec(resolve, reject, 'FirebasePlugin', 'getToken', []);
      }
    );
  },
  analytics: {
    logEvent: function (eventName, eventParams) {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'logEvent', [eventName, eventParams || {}]);
        }
      );
    },
    setUserId: function (userId) {
      return new Promise(
        function (resolve, reject) {
          exec(resolve, reject, 'FirebasePlugin', 'setUserId', [userId]);
        }
      );
    }
  }
};
