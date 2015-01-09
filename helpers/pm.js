var pm2 = require('pm2');
var config = require('../config');
var async = require('async');
var _ = require('lodash');
var moment = require('moment');

var getProcessInfos = function(processList){
  var app = config.app;
  var result = [];

  var format = function(ms){
    var seconds = Math.floor(ms / 1000);
    var str = '';
    var hour = 3600;
    var day = 24 * 3600;
    var minute = 60;
    if(seconds > day){
      str += (Math.floor(seconds / day) + 'd');
      seconds %= day;
    }

    if(seconds > hour){
      str += (Math.floor(seconds / hour) + 'h');
      seconds %= hour;
    }

    if(seconds > minute){
      str += (Math.floor(seconds / minute) + 'm');
      seconds %= minute;
    }

    str += (seconds + 's');

    return str;
  };

  _.forEach(processList, function(info){
    if(info.name === app){
      var pm2Env = info.pm2_env;
      // var uptime = Date.now() - pm2Env.pm_uptime;
      // console.dir(pm2Env);
      result.push({
        pid : info.pid,
        id : pm2Env.pm_id,
        uptime : format(Date.now() - pm2Env.pm_uptime),
        restartTime : pm2Env.restart_time,
        createdAt : moment(pm2Env.created_at).format('YYYY-MM-DD HH:mm:ss'),
        pmUptime : moment(pm2Env.pm_uptime).format('YYYY-MM-DD HH:mm:ss'),
        status : pm2Env.status
      });
    }
  });
  return result;
};


exports.list = function(cbf){
  async.waterfall([
    pm2.connect,
    pm2.list,
    function(processList){
      var processInfos = getProcessInfos(processList);
      cbf(null, processInfos);
    }
  ], cbf);
};