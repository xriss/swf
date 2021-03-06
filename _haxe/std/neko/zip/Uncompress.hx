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
package neko.zip;

class Uncompress {

	var s : Void;

	public function new( windowBits : Int ) {
		s = _inflate_init(windowBits);
	}

	public function run( src : String, srcPos : Int, dst : String, dstPos : Int ) : { done : Bool, read : Int, write : Int } {
		return _inflate_buffer(s,untyped src.__s,srcPos,untyped dst.__s,dstPos);
	}

	public function setFlushMode( f : Flush ) {
		_set_flush_mode(s,untyped Std.string(f).__s);
	}

	public function close() {
		_inflate_end(s);
	}

	public static function run( src : String ) : String {
		var u = new Uncompress(null);
		var tmp = neko.Lib.makeString(1 << 16); // 64K
		var b = new StringBuf();
		var pos = 0;
		u.setFlushMode(Flush.SYNC);
		while( true ) {
			var r = u.run(src,pos,tmp,0);
			b.addSub(tmp,0,r.write);
			pos += r.read;
			if( r.done )
				break;
		}
		u.close();
		return b.toString();
	}

	static var _inflate_init = neko.Lib.load("zlib","inflate_init",1);
	static var _inflate_buffer = neko.Lib.load("zlib","inflate_buffer",5);
	static var _inflate_end = neko.Lib.load("zlib","inflate_end",1);
	static var _set_flush_mode = neko.Lib.load("zlib","set_flush_mode",2);

}
