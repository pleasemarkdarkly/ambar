const httpProxy = require('http-proxy');
const http = require('http');
const basicAuth = require('basic-auth');
const crypto = require('crypto');
const url = require("url");

var username = process.env['username'] || 'land007';
var password = process.env['password'] || 'fcea920f7412b5da7be0cf42b8c93759';
var http_proxy_paths = (process.env['http_proxy_paths'] || '').split(' ');
var http_proxy_hosts = (process.env['http_proxy_hosts'] || '').split(' ');
var http_proxy_ports = (process.env['http_proxy_ports'] || '').split(' ');
var ws_proxy_hosts = (process.env['ws_proxy_hosts'] || '').split(' ');
var ws_proxy_paths = (process.env['ws_proxy_paths'] || '').split(' ');
var ws_proxy_hosts = (process.env['ws_proxy_hosts'] || '').split(' ');
var ws_proxy_ports = (process.env['ws_proxy_ports'] || '').split(' ');

var send401 = function(res) {
	res.statusCode = 401;
	res.setHeader('WWW-Authenticate', 'Basic realm=Authorization Required');
	res.end('<html><body>Need some creds son</body></html>');
};

var proxyServer = http.createServer(function (req, res) {
	let pathname = url.parse(req.url).pathname;
	let user = basicAuth(req);
	if (!user) {
		send401(res);
		return;
	}
	let md5 = crypto.createHash('md5');
	if (user.pass === undefined) {
		md5.update('undefined');
	} else {
		md5.update(user.pass);
	}
	let pass = md5.digest('hex');
	if (user.name !== username || pass !== password) {
		send401(res);
		return;
	}
	let have_http_proxy_path = false;
	for(let h in http_proxy_paths) {
		if(pathname.indexOf(http_proxy_paths[h]) == 0) {
			have_http_proxy_path = true;
			let proxy = httpProxy.createProxyServer({
				target: {
					host: http_proxy_hosts[h],
					port: http_proxy_ports[h]
				},
				ws: false
			});
			proxy.on('proxyReq', function(proxyReq, req, res, options) {
				proxyReq.setHeader('Host', http_proxy_hosts[h] + ':' + http_proxy_ports[h]);
			});
			proxy.web(req, res);
			break;
		}
	}
	if(!have_http_proxy_path) {
		res.writeHead(200, {
			'Content-Type' : 'text/plain'
		});
		res.end('Welcome to my server!');
	}
});

proxyServer.on('upgrade', function (req, socket, head) {
	let pathname = url.parse(req.url).pathname;
	for(let w in ws_proxy_paths) {
		if(pathname.indexOf('/api/') == 0) {
			let proxy = new httpProxy.createProxyServer({
				target : {
					host :  ws_proxy_hosts[w],
					port :  ws_proxy_ports[w]
				},
				ws: true
			});
			proxy.ws(req, socket, head);
			break;
		}
	}
});

proxyServer.listen(80);
console.log("listen 80");