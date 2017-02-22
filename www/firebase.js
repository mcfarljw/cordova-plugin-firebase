var exec = require('cordova/exec');

module.exports = {
  getId: function(callback) {
    return new Promise(
      function(resolve, reject) {
        exec(resolve, reject, 'FirebasePlugin', 'getId', []);
      }
    );
  },
  getToken: function(callback) {
    return new Promise(
      function(resolve, reject) {
        exec(resolve, reject, 'FirebasePlugin', 'getToken', []);
      }
    );
  }
};
