var pm2 = require('pm2');
var async = require('async');
var config = require('./config');
var options = {
  name : config.app,
  instances : 2
};

async.waterfall([
  pm2.connect,
  function(cbf){
    pm2.delete(options.name, function(){
      cbf();
    });
  },
  function(result, cbf){
    pm2.start('app.js', options, cbf);
  }
], function(err){
  if(err){
    console.error(err);
    throw err;
  }else{
    console.log('pm2 start success!');
  }
});
// pm2.connect(function(err){
//   if(err){
//     throw err;
//   }
//   pm2.delete(options.name, function(){
//     pm2.start('app.js', options, function(err, proc){
//       if(err){
//         throw err;
//       }
//     });
//   })
  
// });




// var pm2 = require('pm2');

// // Connect or launch PM2
// pm2.connect(function(err) {

//   // Start a script on the current folder
//   pm2.start('test.js', { name: 'test' }, function(err, proc) {
//     if (err) throw new Error('err');

//     // Get all processes running
//     pm2.list(function(err, process_list) {
//       console.log(process_list);

//       // Disconnect to PM2
//       pm2.disconnect(function() { process.exit(0) });
//     });
//   });
// })