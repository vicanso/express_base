'use strict';
module.exports = function(req, res, cbf){
  setTimeout(function(){
    i.j = 0;
  }, 100);
  return;
  cbf(null, {
    viewData : {
      globalVariable : {
        name : 'tree'
      }
    }
  });
};