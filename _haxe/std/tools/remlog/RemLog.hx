/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package tools.remlog;

typedef Infos = {
	var id : Int;
	var first : Bool;
	var sock : neko.net.Socket;
}

class RemLog extends neko.net.ThreadRemotingServer {

	static var ID = 0;
	static var host;
	static var port;
	static var server : RemLog;

	public override function initClientApi(cnx : haxe.remoting.SocketConnection,_) {
		var s1 = haxe.remoting.SocketConnection.getSocket(cnx);
		var inf : Infos = (cast s1).__peer;
		if( inf != null )
			return;
		var s2 = new neko.net.Socket();
		s2.connect(host,port);
		inf = { sock : s2, id : ++ID, first : true };
		(cast s1).__peer = inf;
		inf = { sock : s1, id : inf.id, first : false };
		(cast s2).__peer = inf;
		trace(inf.id+" CONNECT");
		server.addSocket(s2);
	}

	public override function clientMessage(cnx,msg) {
		var sock = haxe.remoting.SocketConnection.getSocket(cnx);
		var inf : Infos = (cast sock).__peer;
		if( inf == null )
			return;
		trace(inf.id+(if( inf.first ) " > " else " < ")+msg);
		try {
			haxe.remoting.SocketConnection.sendMessage(inf.sock,msg);
		} catch( e : neko.io.Error ) {
			trace(inf.id+" connection broken");
			stopClient(inf.sock);
		}
	}

	public override function clientDisconnected(cnx) {
		var sock = haxe.remoting.SocketConnection.getSocket(cnx);
		var inf : Infos = (cast sock).__peer;
		stopClient(inf.sock);
		if( inf.first )
			trace(inf.id+" DISCONNECTED");
	}

	static function main() {
		var args = neko.Sys.args();
		if( args.length != 2 )
		throw "Arguments needed : [host] [port]";
		host = new neko.net.Host(args[0]);
		port = Std.parseInt(args[1]);
		neko.Lib.println("Starting proxy for "+host.toString()+":"+port);
		server = new RemLog();
		server.run("localhost",9999);
	}

 }