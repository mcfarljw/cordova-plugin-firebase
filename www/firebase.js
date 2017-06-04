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
  }
};
