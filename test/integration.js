var axios = require('axios');
var https = require('https');

if (process.argv.length <= 2) {
    console.log("Usage: " + __filename + " URL");
    process.exit(-1);
}

var url = process.argv[2]

// At request level
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
axios.get(url)
  .then(function (response) {
    console.log("Got response: " + response.status);
    console.log("Got data: " + response.data);
    if ( response.data != "Hello World\n") {
      process.exit(-1);
    }
  })
  .catch(function (error) {
    console.log(error);
    process.exit(-1);
  });
