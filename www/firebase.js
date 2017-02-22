var exec = require('cordova/exec');

module.exports = {
  getId: function(callback) {
    exec(callback, null, 'FirebasePlugin', 'getId', []);
  },
  getToken: function(callback) {
    exec(callback, null, 'FirebasePlugin', 'getToken', []);
  }
};
