module.exports = function(req, res, cbf){
  var data = req.body;
  console.log(JSON.stringify(data));
  cbf(null, {
    msg : 'success'
  });
};