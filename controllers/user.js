'use strict';
module.exports = function(req, res, cbf){
  var sess = req.session;
  if(!sess.data){
    sess.data = {
      name : 'vicanso',
      count : 0
    };
  }
  sess.data.count++;
  cbf(null, sess.data);
};