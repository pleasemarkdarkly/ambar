const cluster = require('cluster');

//根据CPU多核心启动多进程运行日志
var name = __dirname + '/server.js';

cluster.setupMaster({
	exec : name,
	args : process.argv,// ["8000"],
	silent : false
});
var cpus = require('os').cpus();
var length = cpus.length;
var workers = {};
for ( var i = 0; i < length; i++) {
	var worker = cluster.fork();
	worker['workerId'] = worker.id;
	workers[worker['workerId']] = worker;
}