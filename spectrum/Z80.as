//
// FlashZXSpectrum48k Copyright 2006 Jon Pollard
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
//
// Z80.as
// 
// Class for emulation of the Z80 processor.
//
// This file is a direct port from Java to ActionScript of code in 
// the Java Spectrum emulator QAOP http://wizard.ae.krakow.pl/~jb/qaop
//

package {
	import flash.utils.getTimer;
	import Z80Env;

	
 	public class Z80
	{
		private var env:Z80Env;
	
		public function Z80( env:Z80Env )
		{
			this.env = env;
			ticks_limit = 55553;
		}
		
		private var PC:int, SP:int;
		private var I:int, R:int, R7:int;
		private var A:int, B:int, C:int, D:int, E:int, HL:int;
		private var A_:int, B_:int, C_:int, D_:int, E_:int, HL_:int;
		private var IX:int, IY:int;
		private var ir:int; // hidden register

		private var Ff:int, Fr:int, Fa:int, Fb:int;
		private var Ff_:int, Fr_:int, Fa_:int, Fb_:int;

	/*
	   Z: Fr==0
	   P: parity of Fr&0xFF
	 P/V: X ? P : V
			FEDCBA98 76543210
		Ff	.......C S.5.3...
		Fr	........ V..H....
		Fa	.......X V..H....
		Fb	...H..N. V..H....
	*/
		private static const FC:int = 0x01;
		private static const FN:int = 0x02;
		private static const FP:int = 0x04;
		private static const F3:int = 0x08;
		private static const FH:int = 0x10;
		private static const F5:int = 0x20;
		private static const FZ:int = 0x40;
		private static const FS:int = 0x80;
		private static const F53:int = 0x28;
		
		private function flagsR():int 
		{
			var f:int = (Ff & (FS|F53)) | ((Ff >> 8) & FC);		// S.5.3..C
			var ra:int = Fr ^ Fa;
			var u:int = Fb >> 8;
			if( Fr == 0 )
				f |= FZ;			// .Z......
			f |= u & FN;				// ......N.
			f |= (ra ^ Fb ^ u) & FH;		// ...H....
			if( (Fa & (~0xFF)) == 0 )
				f |= ((ra & (Fb ^ Fr)) >> 5) & FP;	// .....V..
			else {
				var p:int = Fr;
				p ^= p>>4;
				p ^= p<<2;
				p = (~p) ^ (p>>1);
				f |= p & FP;			// .....P..
			}
			return f;
		}
		
		private function flagsW(f:int):void 
		{
			Ff = f & (FS|F53) | f<< 8 & 0x100;
			Fr = ~f & FZ;
			Fa = Fb = (f & FP) << 5;
			Fa |= f & FH;
			Fb |= (f & FN) != 0 ? ~0x80 : 0;
		}
		
		public function aR():int { return A; }
		public function fR():int { return flagsR(); }
		public function bcR():int { return B << 8 | C; }
		public function deR():int { return D << 8 | E; }
		public function hlR():int { return HL; }
		public function ixR():int { return IX; }
		public function iyR():int { return IY; }
		public function pcR():int { return PC; }
		public function spR():int { return SP; }
		public function afR():int { return A << 8 | flagsR(); }

		public function aW( v:int ):void { A = v; }
		public function fW( v:int ):void { flagsW(v); }
		public function bcW( v:int ):void { C = v & 0xFF; B = v >>> 8; }
		public function deW( v:int ):void { E = v & 0xFF; D = v >>> 8; }
		public function hlW( v:int ):void { HL = v; }
		public function ixW( v:int ):void { IX = v; }
		public function iyW( v:int ):void { IY = v; }
		public function pcW( v:int ):void { PC = v; }
		public function spW( v:int ):void { SP = v; }
		public function afW( v:int ):void { A = v >>> 8; flagsW( v & 0xFF ); }
		
		public function iW( v:int ):void { I = v; }
		public function rW( v:int ):void { R = v; R7 = v & 0x80; }
		public function im( v:int ):void { v &= 3; if( v != 0 ) v++; IM = intToByte(v); }
		public function iff( v:int ):void { IFF = intToByte(v); }
		public function eiW( v:Boolean ):void { IFF = intToByte(v ? 3 : 0); }

		public function iR():int { return I; }
		public function rR():int { return R & 0x7F | R7; }
		public function eiR():Boolean { return (IFF & 1) != 0; }

		public var ticks:int;
		public var ticks_limit:int;
		
		public function exx():void
		{
			var tmp:int;
			tmp = B_; B_ = B; B = tmp;
			tmp = C_; C_ = C; C = tmp;
			tmp = D_; D_ = D; D = tmp;
			tmp = E_; E_ = E; E = tmp;
			tmp = HL_; HL_ = HL; HL = tmp;
		}
		
		public function ex_af():void 
		{
			var tmp:int;
			tmp = A_; A_ = A; A = tmp;
			tmp = Ff_; Ff_ = Ff; Ff = tmp;
			tmp = Fr_; Fr_ = Fr; Fr = tmp;
			tmp = Fa_; Fa_ = Fa; Fa = tmp;
			tmp = Fb_; Fb_ = Fb; Fb = tmp;
		}
		
		public function push( v:int ):void 
		{
			SP = SP - 2 & 0xFFFF;
			ticks++;
			env.mem16W( SP, v );
			ticks += 6;
		}
		
		public function pop():int 
		{
			var v:int = env.mem16R( SP );
			SP = SP + 2 & 0xFFFF;
			ticks += 6;
			return v;
		}
		
		private function add( b:int ):void
		{
			var r:int = A + b;
			Fa = A;
			Fb = b;
			Ff = r;
			A = Fr = r & 0xFF;
		}

		private function adc( b:int ):void
		{
			var r:int = A + b + (Ff >> 8 & FC);
			Fa = A;
			Fb = b;
			Ff = r;
			A = Fr = r & 0xFF;
		}
		
		private function sub( b:int ):void
		{
			var r:int = A - b;
			Fa = A;
			Fb = ~b;
			Ff = r;
			A = Fr = r & 0xFF;
		}

		private function sbc( b:int ):void
		{
			var r:int = A - b - (Ff >> 8 & FC);
			Fa = A;
			Fb = ~b;
			Ff = r;
			A = Fr = r & 0xFF;
		}

		private function cp( b:int ):void
		{
			var r:int = A - b;
			Fa = A; Fb = ~b;
			Ff = r & ~F53 | b & F53;
			Fr = r & 0xFF;
		}

		private function and( b:int ):void
		{
			var r:int = A & b;
			A = Ff = Fr = r;
			Fa = ~r;
			Fb = 0;
		}

		private function or( b:int ):void
		{
			var r:int = A | b;
			A = Ff = Fr = r;
			Fa = r | 0x100;
			Fb = 0;
		}

		private function xor( b:int ):void
		{
			var r:int = A ^ b;
			A = Ff = Fr = r;
			Fa = r | 0x100;
			Fb = 0;
		}
		
		private function cpl():void
		{
			A = A ^ 0xFF;
			Ff = Ff & ~F53 | A & F53;
			Fb |= ~0x80;
			Fa = Fa & ~FH | ~Fr & FH; // set H, N
		}

		private function inc( v:int ):int
		{
			var r:int = v + 1 & 0xFF;
			Fa = v;
			Fb = 0;
			Fr = r;
			Ff = Ff & ~0xFF | r;
			return r;
		}

		private function dec( v:int ):int
		{
			var r:int = v - 1 & 0xFF;
			Fa = v;
			Fb = -1;
			Fr = r;
			Ff = Ff & ~0xFF | r;
			return r;
		}
		
		private function bit( n:int, v:int ):void
		{
			Ff = Ff & ~0xFF | (v &= 1<<n);
			Fa = ~(Fr = v);
			Fb = 0;
		}
		
		private function f_szh0n0p( r:int ):void
		{
			// SZ5H3PNC
			// xxx0xP0.
			Ff = Ff & ~0xFF | r;
			Fr = r;
			Fa = r | 0x100;
			Fb = 0;
		}

		private function f_h0n0_c35( v:int ):void
		{
			Ff = Ff & 0xD7 | v & 0x128;
			Fb &= 0x80;
			Fa = Fa & ~FH | Fr & FH; // reset H, N
		}
		
		private function shifter( o:int, v:int ):int
		{
			var b:int;
			if( (o & 1) == 0 ) {
				v <<= 1;
				if( o <= 2 ) 
					b = (o == 0 ? v : Ff) >> 8;
				else
					b = o >> 1;
				v |= b & 1;
				Ff = v;
				v &= 0xFF;
			} else {
				b = 0;
				switch( o ) {
					case 1:
						b = v<<8;
						break;
					case 3:
						b = Ff;
						break;
					case 5:
						b = v << 1;
						break;
				}
				v |= b & 0x100;
				Ff = v << 8;
				v >>>= 1;
				Ff |= v;
			}
			Fr = v;
			Fa = v | 0x100;
			Fb = 0;
			return v;
		}
		
		private function add16( a:int, b:int ):int
		{
			var r:int = a + b;
			var h:int = (r ^ a ^ b) >> 8 & 0x10;
			Fb &= 0x80;
			Fa = Fa & ~0x10 | (Fr ^ h) & 0x10;
			Ff = Ff & ~(0x100 | F53) | r >> 8 & (0x100 | F53);
			ir = a;
			ticks += 7;
			return r & 0xFFFF;
		}

		private function adc_hl( b:int ):void
		{
			var r:int = HL + b + (Ff >> 8 & FC);
			Ff = r >> 8;
			Fa = HL >> 8;
			Fb = b >> 8;
			r &= 0xFFFF;
			Fr = r >> 8 | r << 8;
			HL = r;
			ticks += 7;
		}

		private function sbc_hl( b:int ):void
		{
			var r:int = HL - b - (Ff >> 8 & FC);
			Ff = r >> 8;
			Fa = HL >> 8;
			Fb = ~(b >> 8);
			r &= 0xFFFF;
			Fr = r >> 8 | r << 8;
			HL = r;
			ticks += 7;
		}
		
		private function scf_ccf( v:int ):void
		{
			Ff = Ff & 0xD7 | v | A & 0x28;
			Fb &= 0x80;
			Fa = (Fa | FH) ^ Fr & FH ^ v >>> 4;
		}

		private function getd( xy:int ):int
		{
			var d:int = env.memR(PC);
			PC = PC + 1 & 0xFFFF;
			ticks += 8;
			return ir = xy + intToByte(d) & 0xFFFF;
		}

		private function imm8():int
		{
			var v:int = env.memR(PC);
			PC = PC + 1 & 0xFFFF;
			ticks += 3;
			return v;
		}

		private function imm16():int
		{
			var v:int = env.mem16R(PC);
			PC = PC + 2 & 0xFFFF;
			ticks += 6;
			return v;
		}
		
		/* instructions */

		private function daa():void
		{
			var h:int = (Fr ^ Fa ^ Fb ^ Fb >> 8) & FH;

			var d:int = 0;
			if((A | Ff & 0x100) > 0x99)
				d = 0x160;
			if((A & 0xF | h) > 9)
				d += 6;

			Fa = A | 0x100; // parity
			if( (Fb & 0x200) == 0 )
				A += (Fb = d);
			else {
				A -= d;
				Fb = ~d;
			}
			A &= 0xFF;
			Ff = A | d & 0x100;
			Fr = A;
		}

		private function rrd():void
		{
			var v:int = env.memR(HL) | A << 8;
			ticks += 7;
			f_szh0n0p( A = A & 0xF0 | v & 0x0F );
			v = v >>> 4 & 0xFF;
			env.memW( HL, v );
			ticks += 3;
		}

		private function rld():void
		{
			var v:int = env.memR(HL) << 4 | A & 0x0F;
			ticks += 7;
			f_szh0n0p( A = A & 0xF0 | v >>> 8 );
			v &= 0xFF;
			env.memW( HL, v );
			ticks += 3;
		}
		
		private function ld_a_ir( v:int ):void
		{
			A = v;
			Ff = Ff & ~0xFF | v;
			Fr = v == 0 ? 0 : 1;
			Fa = Fb = IFF << 6 & 0x80; // !!!
			ticks++;
		}

		private function jp( y:Boolean ):void
		{
			var a:int = imm16();
			if(y)
				PC = a;
		}

		private function jr( y:Boolean ):void
		{
			var pc:int = PC;
			var d:int = intToByte(env.memR(pc));
			ticks += 3;
			
			if(y) {
				env.cont( pc, 5 );
				ticks += 5;
				ir = pc = pc + d + 1 & 0xFFFF;
			} else
				pc = pc + 1 & 0xFFFF;
			PC = pc;
		}

		private function call( y:Boolean ):void
		{
			var a:int = imm16();
			if(y) {
				env.cont( PC, 1 );
				push(PC);
				ir = PC = a;
			}
		}

		private function halt():void
		{
			halted = true;
			var n:int = ticks_limit - ticks + 3 >> 2;
			if( n > 0 ) {
				R += n;
				ticks += 4 * n;
			}
		}

		private function ldir( i:int, r:Boolean ):void
		{
			var hl:int = HL, de:int = deR(), bc:int = (bcR() - 1 & 0xFFFF) + 1;
			var v:int, pc:int = PC - 2 & 0xFFFF;
			for(;;) {
				v = env.memR(hl);
				hl = hl + i & 0xFFFF;
				ticks += 3;
				env.memW(de, v);
				ticks += 3;
				env.cont(v = de, 2);
				de = de + i & 0xFFFF;
				ticks += 2;
				if( --bc == 0 || !r)
					break;
				if( ticks >= ticks_limit || de == pc || de == pc + 1 ) {
					PC = pc;
					env.cont(v, 5);
					ticks += 5;
					break;
				}
				ticks += 13;
			}
			HL = hl;
			deW(de);
			bcW(bc);

			if( Fr != 0 )
				Fr = 1; // keep Z
			Fa = Fb = bc != 0 ? 0x80 : 0;
			v += A;
			Ff = Ff & ~F53 | v & F3 | v << 4 & F5;
		}
	
		private function cpir( i:int, r:Boolean ):void
		{
			var b:int = env.memR(HL);
			var v:int = A - b & 0xFF;
			HL = HL + i & 0xFFFF;

			Fr = v & ~0x80 | v >>> 7;
			Fb = ~b & ~0x80;
			Fa = A & ~0x80;

			ticks += 8;
			var bc:int = bcR() - 1;
			if( bc != 0 ) {
				Fa |= 0x80;
				Fb |= 0x80;
				if( r && v != 0 ) {
					PC = PC - 2 & 0xFFFF;
					ticks += 5;
				}
				bc &= 0xFFFF;
			}
			bcW(bc);

			Ff = Ff & ~0xFF | v & ~F53;
			if( ((v ^ b ^ A) & FH) != 0 )
				v--;
			Ff |= v << 4 & 0x20 | v & 8;
		}

		private function inir_otir( op:int ):void
		{
			// 101rd01o
			var v:int, d:int, m:int;
			HL = (m = HL) + (d = 1 - (op >> 2 & 2));
			var b:int = B - 1 & 0xFF;
			var k:int;
			ticks++;
			if( (op & 1) == 0 ) {
				v = env.input( b << 8 | C);
				ticks += 4;
				env.memW(m, v);
				ticks += 3;
				k = (Ff >> 8 & 1) + d;
			} else {
				v = env.memR(m);
				ticks += 3;
				env.output( B << 8 | C, v);
				ticks += 4;
				k = HL;
			}
			k = (k & 0xFF) + v;
			if( b != 0 && op >= 0xB0 ) {
				PC = PC - 2 & 0xFFFF;
				ticks += 5;
			}
			Fr = B = b;
			Ff = b | k & 0x100;
			Fb = (k & 0x100) << 4 | v << 2 & 0x200; // H,N
			k = k & 7 ^ b; k ^= k << 4; k ^= k << 2; k ^= k << 1;
			Fb |= (k ^ b) & 0x80; // P
			Fa = Fb;
		}

		public function intToByte( b:int ):int
		{
			b &= 0xFF;
			return b & 0x80 ? b - 0x100 : b;
		}

		public function execute():void
		{
			if( halted ) {
				halt();
				return;
			}
			do {
				var v:int, d:int, a:int;
				
				var c:int = env.m1(PC);
				PC = PC + 1 & 0xFFFF;
				ticks += 4;
				R++;
							
				switch( c ) {
//					case 0x00: 
//						break;
					case 0x08:
						ex_af();
						break;
					case 0x10: {
							ticks++;
							var pc:int;
							d = intToByte(env.memR(pc = PC));
							
							ticks+=3;
							if( (B = B - 1 & 0xFF) > 0 ) {
								env.cont(pc, 5);
								ticks += 5;
								pc+=d;
							}
							PC = pc + 1 & 0xFFFF;
						} break;
					case 0x18:
						d = intToByte(env.memR(PC));
						ticks+=3;
						env.cont(PC, 5);
						ticks+=5;
						PC = ir = PC + 1 + d & 0xFFFF;
						break;
					case 0x01:
						v=imm16();
						B = v >>> 8;
						C = v & 0xFF;
						break;
					case 0x03:
						v = (B << 8 | C) + 1 & 0xFFFF;
						B = v >>> 8;
						C = v & 0xFF;
						ticks += 2;
						break;
					case 0x09: 
						HL = add16(HL, B << 8 | C);
						break;
					case 0x0B:
						v = (B << 8 | C) - 1 & 0xFFFF;
						B = v >>> 8;
						C = v & 0xFF;
						ticks += 2;
						break;
					case 0x11:
						v = imm16();
						D = v >>> 8;
						E = v & 0xFF;
						break;
					case 0x13:
						v = (D << 8 | E) + 1 & 0xFFFF;
						D = v >>> 8;
						E = v & 0xFF;
						ticks += 2;
						break;
					case 0x19:
						HL = add16(HL, D << 8 | E);
						break;
					case 0x1B:
						v = (D << 8 | E) - 1 & 0xFFFF;
						D = v >>> 8;
						E = v & 0xFF;
						ticks+=2;
						break;
					case 0x21:
						HL = imm16();
						break;
					case 0x23:
						HL = HL + 1 & 0xFFFF;
						ticks += 2;
						break;
					case 0x29:
						HL = add16(HL, HL);
						break;
					case 0x2B:
						HL = HL - 1 & 0xFFFF;
						ticks += 2;
						break;
					case 0x31:
						SP = imm16();
						break;
					case 0x33:
						SP = SP + 1 & 0xFFFF;
						ticks += 2;
						break;
					case 0x39:
						HL = add16(HL,SP);
						break;
					case 0x3B:
						SP = SP - 1 & 0xFFFF;
						ticks += 2;
						break;
					case 0x02:
						env.memW( B << 8 | C, A );
						ticks += 3;
						break;
					case 0x0A:
						A = env.memR( B << 8 | C );
						ticks += 3;
						break;
					case 0x12:
						env.memW(D << 8 | E, A);
						ticks += 3;
						break;
					case 0x1A:
						A = env.memR(D << 8 | E);
						ticks += 3;
						break;
					case 0x22:
						env.mem16W(imm16(), HL);
						ticks += 6;
						break;
					case 0x2A:
						HL = env.mem16R(imm16());
						ticks += 6;
						break;
					case 0x32:
						env.memW(imm16(), A);
						ticks += 3;
						break;
					case 0x3A:
						A = env.memR(imm16());
						ticks += 3; break;
					case 0x04:
						B = inc(B);
						break;
					case 0x05:
						B = dec(B);
						break;
					case 0x06:
						B = imm8();
						break;
					case 0x0C:
						C = inc(C);
						break;
					case 0x0D:
						C = dec(C);
						break;
					case 0x0E:
						C = imm8();
						break;
					case 0x14:
						D = inc(D);
						break;
					case 0x15:
						D = dec(D);
						break;
					case 0x16:
						D = imm8();
						break;
					case 0x1C:
						E = inc(E);
						break;
					case 0x1D:
						E = dec(E);
						break;
					case 0x1E:
						E = imm8();
						break;
					case 0x24:
						HL = HL & 0xFF | inc(HL >>> 8) << 8;
						break;
					case 0x25:
						HL = HL & 0xFF | dec(HL >>> 8) << 8;
						break;
					case 0x26:
						HL = HL & 0xFF | imm8() << 8;
						break;
					case 0x2C:
						HL = HL & 0xFF00 | inc(HL & 0xFF);
						break;
					case 0x2D:
						HL = HL & 0xFF00 | dec(HL & 0xFF);
						break;
					case 0x2E:
						HL = HL & 0xFF00 | imm8();
						break;
					case 0x34:
						v = inc(env.memR(HL));
						ticks += 4;
						env.memW(HL, v);
						ticks += 3;
						break;
					case 0x35:
						v = dec(env.memR(HL));
						ticks += 4;
						env.memW(HL, v);
						ticks += 3;
						break;
					case 0x36:
						env.memW(HL, imm8());
						ticks+=3;
						break;
					case 0x3C:
						A = inc(A);
						break;
					case 0x3D:
						A = dec(A);
						break;
					case 0x3E:
						A = imm8();
						break;
					case 0x20:
						jr( Fr != 0 );
						break;
					case 0x28:
						jr( Fr == 0 );
						break;
					case 0x30:
						jr( (Ff & 0x100) == 0 );
						break;
					case 0x38:
						jr( (Ff & 0x100) != 0 );
						break;
					case 0x07:
						a = A << 1 | A >>> 7;
						f_h0n0_c35(a);
						A = a & 0xFF;
						break;
					case 0x0F:
						a = A >>> 1;
						f_h0n0_c35(a | A << 8);
						A = a | A << 7 & 0xFF;
						break;
					case 0x17:
						a = A << 1;
						A = a & 0xFF | Ff >>> 8 & 1;
						f_h0n0_c35(a);
						break;
					case 0x1F:
						a = A;
						A = (a | Ff & 0x100) >>> 1;
						f_h0n0_c35(A | a << 8);
						break;
					case 0x27: 
						daa();
						break;
					case 0x2F:
						cpl();
						break;
					case 0x37:
						scf_ccf(0x100);
						break;
					case 0x3F:
						scf_ccf(~Ff & 0x100);
						break;
					// case 0x40: break;
					case 0x41:
						B = C;
						break;
					case 0x42:
						B = D;
						break;
					case 0x43:
						B = E;
						break;
					case 0x44:
						B = HL >>> 8;
						break;
					case 0x45: 
						B = HL & 0xFF;
						break;
					case 0x46:
						B = env.memR(HL);
						ticks += 3;
						break;
					case 0x47:
						B = A;
						break;
					case 0x48:
						C = B;
						break;
					// case 0x49: break;
					case 0x4A:
						C = D;
						break;
					case 0x4B:
						C = E;
						break;
					case 0x4C:
						C = HL >>> 8;
						break;
					case 0x4D:
						C = HL & 0xFF;
						break;
					case 0x4E:
						C = env.memR(HL);
						ticks += 3;
						break;
					case 0x4F:
						C = A;
						break;
					case 0x50:
						D = B;
						break;
					case 0x51:
						D = C;
						break;
					// case 0x52: break;
					case 0x53: 
						D = E;
						break;
					case 0x54:
						D = HL >>> 8;
						break;
					case 0x55:
						D = HL & 0xFF;
						break;
					case 0x56: 
						D = env.memR(HL);
						ticks += 3;
						break;
					case 0x57:
						D = A;
						break;
					case 0x58:
						E = B;
						break;
					case 0x59:
						E = C;
						break;
					case 0x5A:
						E = D;
						break;
					// case 0x5B: break;
					case 0x5C: 
						E = HL >>> 8;
						break;
					case 0x5D:
						E = HL & 0xFF;
						break;
					case 0x5E: 
						E = env.memR(HL);
						ticks += 3;
						break;
					case 0x5F:
						E = A; 
						break;
					case 0x60: 
						HL = HL & 0xFF | B << 8;
						break;
					case 0x61: 
						HL = HL & 0xFF | C << 8;
						break;
					case 0x62: 
						HL = HL & 0xFF | D << 8;
						break;
					case 0x63: 
						HL = HL & 0xFF | E << 8;
						break;
					// case 0x64: break;
					case 0x65: 
						HL = HL & 0xFF | (HL & 0xFF) << 8;
						break;
					case 0x66: 
						HL = HL & 0xFF | env.memR(HL) << 8;
						ticks += 3;
						break;
					case 0x67:
						HL = HL & 0xFF | A << 8;
						break;
					case 0x68:
						HL = HL & 0xFF00 | B;
						break;
					case 0x69:
						HL = HL & 0xFF00 | C;
						break;
					case 0x6A:
						HL = HL & 0xFF00 | D;
						break;
					case 0x6B: 
						HL = HL & 0xFF00 | E;
						break;
					case 0x6C:
						HL = HL & 0xFF00 | HL >>> 8;
						break;
					// case 0x6D: break;
					case 0x6E:
						HL = HL & 0xFF00 | env.memR(HL);
						ticks += 3;
						break;
					case 0x6F:
						HL = HL & 0xFF00 | A;
						break;
					case 0x70:
						env.memW(HL, B);
						ticks += 3;
						break;
					case 0x71:
						env.memW(HL, C);
						ticks += 3;
						break;
					case 0x72:
						env.memW(HL, D);
						ticks+=3;
						break;
					case 0x73:
						env.memW(HL, E);
						ticks += 3;
						break;
					case 0x74:
						env.memW(HL, HL >>> 8);
						ticks += 3;
						break;
					case 0x75:
						env.memW(HL, HL & 0xFF);
						ticks += 3;
						break;
					case 0x76:
						halt();
						break;
					case 0x77:
						env.memW(HL, A);
						ticks += 3;
						break;
					case 0x78:
						A = B;
						break;
					case 0x79:
						A = C;
						break;
					case 0x7A:
						A = D;
						break;
					case 0x7B:
						A = E;
						break;
					case 0x7C:
						A = HL >>> 8;
						break;
					case 0x7D:
						A = HL & 0xFF;
						break;
					case 0x7E:
						A = env.memR(HL);
						ticks += 3;
						break;
					// case 0x7F: break;
					case 0x80:
						add(B);
						break;
					case 0x81:
						add(C);
						break;
					case 0x82:
						add(D);
						break;
					case 0x83:
						add(E);
						break;
					case 0x84:
						add(HL >>> 8);
						break;
					case 0x85:
						add(HL&0xFF);
						break;
					case 0x86:
						add(env.memR(HL));
						ticks+=3;
						break;
					case 0x87:
						add(A);
						break;
					case 0x88:
						adc(B);
						break;
					case 0x89:
						adc(C);
						break;
					case 0x8A: 
						adc(D);
						break;
					case 0x8B:
						adc(E);
						break;
					case 0x8C:
						adc(HL >>> 8);
						break;
					case 0x8D: 
						adc(HL & 0xFF);
						break;
					case 0x8E: 
						adc(env.memR(HL));
						ticks += 3;
						break;
					case 0x8F:
						adc(A);
						break;
					case 0x90:
						sub(B);
						break;
					case 0x91:
						sub(C);
						break;
					case 0x92:
						sub(D);
						break;
					case 0x93:
						sub(E);
						break;
					case 0x94:
						sub(HL >>> 8);
						break;
					case 0x95: 
						sub(HL & 0xFF);
						break;
					case 0x96: 
						sub(env.memR(HL));
						ticks += 3;
						break;
					case 0x97:
						sub(A);
						break;
					case 0x98:
						sbc(B);
						break;
					case 0x99:
						sbc(C);
						break;
					case 0x9A:
						sbc(D);
						break;
					case 0x9B:
						sbc(E);
						break;
					case 0x9C:
						sbc(HL >>> 8);
						break;
					case 0x9D:
						sbc(HL & 0xFF);
						break;
					case 0x9E:
						sbc(env.memR(HL));
						ticks += 3;
						break;
					case 0x9F:
						sbc(A);
						break;
					case 0xA0:
						and(B);
						break;
					case 0xA1:
						and(C);
						break;
					case 0xA2:
						and(D);
						break;
					case 0xA3:
						and(E);
						break;
					case 0xA4:
						and(HL >>> 8);
						break;
					case 0xA5:
						and(HL & 0xFF);
						break;
					case 0xA6: 
						and(env.memR(HL));
						ticks+=3;
						break;
					case 0xA7:
						and(A);
						break;
					case 0xA8:
						xor(B);
						break;
					case 0xA9:
						xor(C);
						break;
					case 0xAA:
						xor(D);
						break;
					case 0xAB:
						xor(E);
						break;
					case 0xAC:
						xor(HL >>> 8);
						break;
					case 0xAD:
						xor(HL & 0xFF);
						break;
					case 0xAE:
						xor(env.memR(HL));
						ticks += 3;
						break;
					case 0xAF:
						xor(A);
						break;
					case 0xB0:
						or(B);
						break;
					case 0xB1:
						or(C);
						break;
					case 0xB2:
						or(D);
						break;
					case 0xB3:
						or(E);
						break;
					case 0xB4:
						or(HL >>> 8);
						break;
					case 0xB5:
						or(HL&0xFF);
						break;
					case 0xB6:
						or(env.memR(HL));
						ticks += 3;
						break;
					case 0xB7:
						or(A);
						break;
					case 0xB8:
						cp(B);
						break;
					case 0xB9:
						cp(C);
						break;
					case 0xBA:
						cp(D);
						break;
					case 0xBB:
						cp(E);
						break;
					case 0xBC:
						cp(HL >>> 8);
						break;
					case 0xBD:
						cp(HL & 0xFF);
						break;
					case 0xBE:
						cp(env.memR(HL));
						ticks+=3;
						break;
					case 0xBF: 
						cp(A);
						break;
					case 0xDD:
					case 0xFD: 
						group_xy(c);
						break;
					case 0xCB: 
						group_cb();
						break;
					case 0xED:
						group_ed();
						break;
					case 0xC0:
						ticks++;
						if( Fr != 0 )
							ir = PC = pop();
						break;
					case 0xC2:
						jp(Fr != 0);
						break;
					case 0xC4:
						call( Fr != 0 );
						break;
					case 0xC8: 
						ticks++;
						if( Fr == 0 )
							ir = PC = pop();
						break;
					case 0xCA: 
						jp( Fr == 0 );
						break;
					case 0xCC:
						call( Fr == 0 );
						break;
					case 0xD0:
						ticks++; 
						if( (Ff & 0x100) == 0 )
							ir = PC = pop();
						break;
					case 0xD2: 
						jp((Ff & 0x100) == 0);
						break;
					case 0xD4:
						call((Ff & 0x100) == 0);
						break;
					case 0xD8:
						ticks++;
						if((Ff & 0x100) != 0)
							ir = PC = pop();
						break;
					case 0xDA: 
						jp((Ff & 0x100) != 0);
						break;
					case 0xDC: 
						call((Ff & 0x100) != 0);
						break;
					case 0xE0: 
						ticks++;
						if(	(flagsR() & FP) == 0 ) 
							ir = PC = pop();
						break;
					case 0xE2:
						jp((flagsR() & FP) == 0);
						break;
					case 0xE4:
						call((flagsR() & FP) == 0);
						break;
					case 0xE8:
						ticks++;
						if((flagsR() & FP) != 0)
							ir = PC = pop();
						break;
					case 0xEA: 
						jp((flagsR() & FP) != 0);
						break;
					case 0xEC:
						call((flagsR() & FP) != 0);
						break;
					case 0xF0: 
						ticks++; 
						if((Ff & FS) == 0)
							ir = PC = pop();
						break;
					case 0xF2: 
						jp((Ff & FS) == 0);
						break;
					case 0xF4: 
						call((Ff & FS) == 0);
						break;
					case 0xF8: 
						ticks++;
						if((Ff & FS) != 0)
							ir = PC = pop();
						break;
					case 0xFA:
						jp((Ff & FS) != 0);
						break;
					case 0xFC:
						call((Ff & FS) != 0);
						break;
					case 0xC1:
						v = pop();
						B = v >> 8;
						C = v & 0xFF;
						break;
					case 0xC5:
						push(B << 8 | C);
						break;
					case 0xD1:
						v = pop();
						D = v >> 8;
						E = v & 0xFF;
						break;
					case 0xD5: 
						push(D << 8 | E);
						break;
					case 0xE1:
						HL = pop();
						break;
					case 0xE5:
						push(HL);
						break;
					case 0xF1:
						afW(pop());
						break;
					case 0xF5:
						push(A << 8 | flagsR());
						break;
					case 0xC3: 
						PC = imm16();
						break;
					case 0xC6:
						add(imm8());
						break;
					case 0xCE:
						adc(imm8());
						break;
					case 0xD6:
						sub(imm8());
						break;
					case 0xDE: 
						sbc(imm8());
						break;
					case 0xE6:
						and(imm8());
						break;
					case 0xEE:
						xor(imm8());
						break;
					case 0xF6:
						or(imm8());
						break;
					case 0xFE:
						cp(imm8());
						break;
					case 0xC9:
						ir = PC = pop();
						break;
					case 0xCD:
						a = imm16();
						env.cont(PC, 1);
						push(PC);
						ir = PC = a;
						break;
					case 0xD3: 
						env.output(imm8() | A << 8, A);
						ticks += 4; 
						break;
					case 0xDB: 
						A = env.input(imm8() | A << 8);
						ticks += 4;
						break;
					case 0xD9: 
						exx();
						break;
					case 0xE3:
						v = env.mem16R(SP);
						ticks += 7;
						env.mem16W(SP, HL);
						HL=v;
						ticks += 8;
						break;
					case 0xE9: 
						PC = HL;
						break;
					case 0xEB:
						v = HL;
						HL = D << 8 | E;
						D = v >>> 8;
						E = v & 0xFF;
						break;
					case 0xF3:
						IFF = 0;
						break;
					case 0xFB:
						IFF = 3;
						break;
					case 0xF9:
						SP = HL;
						ticks += 2;
						break;
					case 0xC7:
					case 0xCF:
					case 0xD7:
					case 0xDF:
					case 0xE7:
					case 0xEF:
					case 0xF7:
					case 0xFF: 
						push(PC);
						PC = c - 199;
						break;
				}
			} while( ticks_limit - ticks > 0 );
		}

		private function group_xy( c0:int ):void
		{
			for(;;) {
				var v:int, a:int;
			
				var xy:int = c0 == 0xDD ? IX : IY;
				var c:int = env.m1(PC); PC = PC+1 & 0xFFFF;
				ticks += 4; R++;
				switch( c ) {
					// case 0x00: break;
					case 0x08: ex_af(); break;
					case 0x10: ticks++; jr((B=B-1&0xFF)>0); break;
					case 0x18: jr(true); break;
					case 0x01: v = imm16(); B=v>>>8; C=v&0xFF; break;
					case 0x03: v = (B<<8|C)+1&0xFFFF; B=v>>>8; C=v&0xFF; ticks+=2; break;
					case 0x09: xy=add16(xy,B<<8|C); break;
					case 0x0B: v = (B<<8|C)-1&0xFFFF; B=v>>>8; C=v&0xFF; ticks+=2; break;
					case 0x11: v = imm16(); D=v>>>8; E=v&0xFF; break;
					case 0x13: v = (D<<8|E)+1&0xFFFF; D=v>>>8; E=v&0xFF; ticks+=2; break;
					case 0x19: xy=add16(xy,D<<8|E); break;
					case 0x1B: v = (D<<8|E)-1&0xFFFF; D=v>>>8; E=v&0xFF; ticks+=2; break;
					case 0x21: xy=imm16(); break;
					case 0x23: xy=xy+1&0xFFFF; ticks+=2; break;
					case 0x29: xy=add16(xy,xy); break;
					case 0x2B: xy=xy-1&0xFFFF; ticks+=2; break;
					case 0x31: SP=imm16(); break;
					case 0x33: SP=SP+1&0xFFFF; ticks+=2; break;
					case 0x39: xy=add16(xy,SP); break;
					case 0x3B: SP=SP-1&0xFFFF; ticks+=2; break;
					case 0x02: env.memW(B<<8|C,A); ticks+=3; break;
					case 0x0A: A=env.memR(B<<8|C); ticks+=3; break;
					case 0x12: env.memW(D<<8|E,A); ticks+=3; break;
					case 0x1A: A=env.memR(D<<8|E); ticks+=3; break;
					case 0x22: env.mem16W(imm16(),xy); ticks+=6; break;
					case 0x2A: xy=env.mem16R(imm16()); ticks+=6; break;
					case 0x32: env.memW(imm16(),A); ticks+=3; break;
					case 0x3A: A=env.memR(imm16()); ticks+=3; break;
					case 0x04: B=inc(B); break;
					case 0x05: B=dec(B); break;
					case 0x06: B=imm8(); break;
					case 0x0C: C=inc(C); break;
					case 0x0D: C=dec(C); break;
					case 0x0E: C=imm8(); break;
					case 0x14: D=inc(D); break;
					case 0x15: D=dec(D); break;
					case 0x16: D=imm8(); break;
					case 0x1C: E=inc(E); break;
					case 0x1D: E=dec(E); break;
					case 0x1E: E=imm8(); break;
					case 0x24: xy=xy&0xFF|inc(xy>>>8)<<8; break;
					case 0x25: xy=xy&0xFF|dec(xy>>>8)<<8; break;
					case 0x26: xy=xy&0xFF|imm8()<<8; break;
					case 0x2C: xy=xy&0xFF00|inc(xy&0xFF); break;
					case 0x2D: xy=xy&0xFF00|dec(xy&0xFF); break;
					case 0x2E: xy=xy&0xFF00|imm8(); break;
					case 0x34: v = inc(env.memR(a=getd(xy))); ticks+=4; env.memW(a,v); ticks+=3; break;
					case 0x35: v = dec(env.memR(a=getd(xy))); ticks+=4; env.memW(a,v); ticks+=3; break;
					case 0x36: a = xy + intToByte(env.memR(PC)) & 0xFFFF; ticks+=3;
						v = env.memR( PC+1 & 0xFFFF ); ticks+=5;
						env.memW(a,v); PC = PC+2&0xFFFF; ticks+=3; break;
					case 0x3C: A=inc(A); break;
					case 0x3D: A=dec(A); break;
					case 0x3E: A=imm8(); break;
					case 0x20: jr(Fr!=0); break;
					case 0x28: jr(Fr==0); break;
					case 0x30: jr((Ff&0x100)==0); break;
					case 0x38: jr((Ff&0x100)!=0); break;
					case 0x07: a = A<<1|A>>>7; f_h0n0_c35(a); A=a&0xFF; break;
					case 0x0F: a = A>>>1; f_h0n0_c35(a|A<<8); A=a|A<<7&0xFF; break;
					case 0x17: a = A<<1; A=a&0xFF|Ff>>>8&1; f_h0n0_c35(a); break;
					case 0x1F: a = A; A=(a|Ff&0x100)>>>1; f_h0n0_c35(A|a<<8); break;
					case 0x27: daa(); break;
					case 0x2F: cpl(); break;
					case 0x37: scf_ccf(0x100); break;
					case 0x3F: scf_ccf(~Ff&0x100); break;
					// case 0x40: break;
					case 0x41: B=C; break;
					case 0x42: B=D; break;
					case 0x43: B=E; break;
					case 0x44: B=xy>>>8; break;
					case 0x45: B=xy&0xFF; break;
					case 0x46: B=env.memR(getd(xy)); ticks+=3; break;
					case 0x47: B=A; break;
					case 0x48: C=B; break;
					// case 0x49: break;
					case 0x4A: C=D; break;
					case 0x4B: C=E; break;
					case 0x4C: C=xy>>>8; break;
					case 0x4D: C=xy&0xFF; break;
					case 0x4E: C=env.memR(getd(xy)); ticks+=3; break;
					case 0x4F: C=A; break;
					case 0x50: D=B; break;
					case 0x51: D=C; break;
					// case 0x52: break;
					case 0x53: D=E; break;
					case 0x54: D=xy>>>8; break;
					case 0x55: D=xy&0xFF; break;
					case 0x56: D=env.memR(getd(xy)); ticks+=3; break;
					case 0x57: D=A; break;
					case 0x58: E=B; break;
					case 0x59: E=C; break;
					case 0x5A: E=D; break;
					// case 0x5B: break;
					case 0x5C: E=xy>>>8; break;
					case 0x5D: E=xy&0xFF; break;
					case 0x5E: E=env.memR(getd(xy)); ticks+=3; break;
					case 0x5F: E=A; break;
					case 0x60: xy=xy&0xFF|B<<8; break;
					case 0x61: xy=xy&0xFF|C<<8; break;
					case 0x62: xy=xy&0xFF|D<<8; break;
					case 0x63: xy=xy&0xFF|E<<8; break;
					// case 0x64: break;
					case 0x65: xy=xy&0xFF|(xy&0xFF)<<8; break;
					case 0x66: HL=HL&0xFF|env.memR(getd(xy))<<8; ticks+=3; break;
					case 0x67: xy=xy&0xFF|A<<8; break;
					case 0x68: xy=xy&0xFF00|B; break;
					case 0x69: xy=xy&0xFF00|C; break;
					case 0x6A: xy=xy&0xFF00|D; break;
					case 0x6B: xy=xy&0xFF00|E; break;
					case 0x6C: xy=xy&0xFF00|xy>>>8; break;
					// case 0x6D: break;
					case 0x6E: HL=HL&0xFF00|env.memR(getd(xy)); ticks+=3; break;
					case 0x6F: xy=xy&0xFF00|A; break;
					case 0x70: env.memW(getd(xy),B); ticks+=3; break;
					case 0x71: env.memW(getd(xy),C); ticks+=3; break;
					case 0x72: env.memW(getd(xy),D); ticks+=3; break;
					case 0x73: env.memW(getd(xy),E); ticks+=3; break;
					case 0x74: env.memW(getd(xy),HL>>>8); ticks+=3; break;
					case 0x75: env.memW(getd(xy),HL&0xFF); ticks+=3; break;
					case 0x76: halt(); break;
					case 0x77: env.memW(getd(xy),A); ticks+=3; break;
					case 0x78: A=B; break;
					case 0x79: A=C; break;
					case 0x7A: A=D; break;
					case 0x7B: A=E; break;
					case 0x7C: A=xy>>>8; break;
					case 0x7D: A=xy&0xFF; break;
					case 0x7E: A=env.memR(getd(xy)); ticks+=3; break;
					// case 0x7F: break;
					case 0x80: add(B); break;
					case 0x81: add(C); break;
					case 0x82: add(D); break;
					case 0x83: add(E); break;
					case 0x84: add(xy>>>8); break;
					case 0x85: add(xy&0xFF); break;
					case 0x86: add(env.memR(getd(xy))); ticks+=3; break;
					case 0x87: add(A); break;
					case 0x88: adc(B); break;
					case 0x89: adc(C); break;
					case 0x8A: adc(D); break;
					case 0x8B: adc(E); break;
					case 0x8C: adc(xy>>>8); break;
					case 0x8D: adc(xy&0xFF); break;
					case 0x8E: adc(env.memR(getd(xy))); ticks+=3; break;
					case 0x8F: adc(A); break;
					case 0x90: sub(B); break;
					case 0x91: sub(C); break;
					case 0x92: sub(D); break;
					case 0x93: sub(E); break;
					case 0x94: sub(xy>>>8); break;
					case 0x95: sub(xy&0xFF); break;
					case 0x96: sub(env.memR(getd(xy))); ticks+=3; break;
					case 0x97: sub(A); break;
					case 0x98: sbc(B); break;
					case 0x99: sbc(C); break;
					case 0x9A: sbc(D); break;
					case 0x9B: sbc(E); break;
					case 0x9C: sbc(xy>>>8); break;
					case 0x9D: sbc(xy&0xFF); break;
					case 0x9E: sbc(env.memR(getd(xy))); ticks+=3; break;
					case 0x9F: sbc(A); break;
					case 0xA0: and(B); break;
					case 0xA1: and(C); break;
					case 0xA2: and(D); break;
					case 0xA3: and(E); break;
					case 0xA4: and(xy>>>8); break;
					case 0xA5: and(xy&0xFF); break;
					case 0xA6: and(env.memR(getd(xy))); ticks+=3; break;
					case 0xA7: and(A); break;
					case 0xA8: xor(B); break;
					case 0xA9: xor(C); break;
					case 0xAA: xor(D); break;
					case 0xAB: xor(E); break;
					case 0xAC: xor(xy>>>8); break;
					case 0xAD: xor(xy&0xFF); break;
					case 0xAE: xor(env.memR(getd(xy))); ticks+=3; break;
					case 0xAF: xor(A); break;
					case 0xB0: or(B); break;
					case 0xB1: or(C); break;
					case 0xB2: or(D); break;
					case 0xB3: or(E); break;
					case 0xB4: or(xy>>>8); break;
					case 0xB5: or(xy&0xFF); break;
					case 0xB6: or(env.memR(getd(xy))); ticks+=3; break;
					case 0xB7: or(A); break;
					case 0xB8: cp(B); break;
					case 0xB9: cp(C); break;
					case 0xBA: cp(D); break;
					case 0xBB: cp(E); break;
					case 0xBC: cp(xy>>>8); break;
					case 0xBD: cp(xy&0xFF); break;
					case 0xBE: cp(env.memR(getd(xy))); ticks+=3; break;
					case 0xBF: cp(A); break;
					case 0xDD:
					case 0xFD: c0=c; continue;
					case 0xCB: group_xy_cb(xy); break;
					case 0xED: group_ed(); break;
					case 0xC0: ticks++; if(Fr!=0) ir=PC=pop(); break;
					case 0xC2: jp(Fr!=0); break;
					case 0xC4: call(Fr!=0); break;
					case 0xC8: ticks++; if(Fr==0) ir=PC=pop(); break;
					case 0xCA: jp(Fr==0); break;
					case 0xCC: call(Fr==0); break;
					case 0xD0: ticks++; if((Ff&0x100)==0) ir=PC=pop(); break;
					case 0xD2: jp((Ff&0x100)==0); break;
					case 0xD4: call((Ff&0x100)==0); break;
					case 0xD8: ticks++; if((Ff&0x100)!=0) ir=PC=pop(); break;
					case 0xDA: jp((Ff&0x100)!=0); break;
					case 0xDC: call((Ff&0x100)!=0); break;
					case 0xE0: ticks++; if((flagsR()&FP)==0) ir=PC=pop(); break;
					case 0xE2: jp((flagsR()&FP)==0); break;
					case 0xE4: call((flagsR()&FP)==0); break;
					case 0xE8: ticks++; if((flagsR()&FP)!=0) ir=PC=pop(); break;
					case 0xEA: jp((flagsR()&FP)!=0); break;
					case 0xEC: call((flagsR()&FP)!=0); break;
					case 0xF0: ticks++; if((Ff&FS)==0) ir=PC=pop(); break;
					case 0xF2: jp((Ff&FS)==0); break;
					case 0xF4: call((Ff&FS)==0); break;
					case 0xF8: ticks++; if((Ff&FS)!=0) ir=PC=pop(); break;
					case 0xFA: jp((Ff&FS)!=0); break;
					case 0xFC: call((Ff&FS)!=0); break;
					case 0xC1: v=pop(); B=v>>8; C=v&0xFF; break;
					case 0xC5: push(B<<8|C); break;
					case 0xD1: v=pop(); D=v>>8; E=v&0xFF; break;
					case 0xD5: push(D<<8|E); break;
					case 0xE1: xy=pop(); break;
					case 0xE5: push(xy); break;
					case 0xF1: afW(pop()); break;
					case 0xF5: push(A<<8|flagsR()); break;
					case 0xC3: PC=imm16(); break;
					case 0xC6: add(imm8()); break;
					case 0xCE: adc(imm8()); break;
					case 0xD6: sub(imm8()); break;
					case 0xDE: sbc(imm8()); break;
					case 0xE6: and(imm8()); break;
					case 0xEE: xor(imm8()); break;
					case 0xF6: or(imm8()); break;
					case 0xFE: cp(imm8()); break;
					case 0xC9: ir=PC=pop(); break;
					case 0xCD: call(true); break;
					case 0xD3: env.output(imm8()|A<<8,A); ticks+=4; break;
					case 0xDB: A=env.input(imm8()|A<<8); ticks+=4; break;
					case 0xD9: exx(); break;
					case 0xE3: v = env.mem16R(SP); ticks+=7; env.mem16W(SP,xy); xy=v; ticks+=8; break;
					case 0xE9: PC=xy; break;
					case 0xEB: v = HL; HL=D<<8|E; D=v>>>8; E=v&0xFF; break;
					case 0xF3: IFF=0; break;
					case 0xFB: IFF=3; break;
					case 0xF9: SP=xy; ticks+=2; break;
					case 0xC7:
					case 0xCF:
					case 0xD7:
					case 0xDF:
					case 0xE7:
					case 0xEF:
					case 0xF7:
					case 0xFF: push(PC); PC=c-199; break;
				}
				if(c0==0xDD) IX = xy; else IY = xy;
				break;
			}
		}
	
		private function group_ed():void
		{
			var v:int, a:int;
			var c:int = env.m1(PC); PC = PC+1 & 0xFFFF;
			ticks += 4; R++;
			switch(c) {
				case 0x47: I=A; ticks++; break;
				case 0x4F: rW(A); ticks++; break;
				case 0x57: ld_a_ir(I); break;
				case 0x5F: ld_a_ir(rR()); break;
				case 0x67: rrd(); break;
				case 0x6F: rld(); break;
				case 0x40: v = env.input(B<<8|C); B=v; f_szh0n0p(v); ticks+=4; break;
				case 0x41: env.output(B<<8|C,B); ticks+=4; break;
				case 0x48: v = env.input(B<<8|C); C=v; f_szh0n0p(v); ticks+=4; break;
				case 0x49: env.output(B<<8|C,C); ticks+=4; break;
				case 0x50: v = env.input(B<<8|C); D=v; f_szh0n0p(v); ticks+=4; break;
				case 0x51: env.output(B<<8|C,D); ticks+=4; break;
				case 0x58: v = env.input(B<<8|C); E=v; f_szh0n0p(v); ticks+=4; break;
				case 0x59: env.output(B<<8|C,E); ticks+=4; break;
				case 0x60: v = env.input(B<<8|C); HL=HL&0xFF|v<<8; f_szh0n0p(v); ticks+=4; break;
				case 0x61: env.output(B<<8|C,HL>>>8); ticks+=4; break;
				case 0x68: v = env.input(B<<8|C); HL=HL&0xFF00|v; f_szh0n0p(v); ticks+=4; break;
				case 0x69: env.output(B<<8|C,HL&0xFF); ticks+=4; break;
				case 0x70: f_szh0n0p(env.input(B<<8|C)); ticks+=4; break;
				case 0x71: env.output(B<<8|C,0); ticks+=4; break;
				case 0x78: v = env.input(B<<8|C); A=v; f_szh0n0p(v); ticks+=4; break;
				case 0x79: env.output(B<<8|C,A); ticks+=4; break;
				case 0x42: sbc_hl(B<<8|C); break;
				case 0x4A: adc_hl(B<<8|C); break;
				case 0x43: env.mem16W(imm16(),B<<8|C); ticks+=6; break;
				case 0x4B: v=env.mem16R(imm16()); B=v>>>8; C=v&0xFF; ticks+=6; break;
				case 0x52: sbc_hl(D<<8|E); break;
				case 0x5A: adc_hl(D<<8|E); break;
				case 0x53: env.mem16W(imm16(),D<<8|E); ticks+=6; break;
				case 0x5B: v = env.mem16R(imm16()); D=v>>>8; E=v&0xFF; ticks+=6; break;
				case 0x62: sbc_hl(HL); break;
				case 0x6A: adc_hl(HL); break;
				case 0x63: env.mem16W(imm16(),HL); ticks+=6; break;
				case 0x6B: HL=env.mem16R(imm16()); ticks+=6; break;
				case 0x72: sbc_hl(SP); break;
				case 0x7A: adc_hl(SP); break;
				case 0x73: env.mem16W(imm16(),SP); ticks+=6; break;
				case 0x7B: SP=env.mem16R(imm16()); ticks+=6; break;
				case 0x44:
				case 0x4C:
				case 0x54:
				case 0x5C:
				case 0x64:
				case 0x6C:
				case 0x74:
				case 0x7C: a=A; A=0; sub(a); break;
				case 0x45:
				case 0x4D:
				case 0x55:
				case 0x5D:
				case 0x65:
				case 0x6D:
				case 0x75:
				case 0x7D: IFF|=IFF>>1; PC=pop(); break; // !!!
				case 0x46:
				case 0x4E:
				case 0x56:
				case 0x5E:
				case 0x66:
				case 0x6E:
				case 0x76:
				case 0x7E: IM = intToByte(c>>3&3); break;
				case 0xA0: ldir(1,false); break;
				case 0xA8: ldir(-1,false); break;
				case 0xB0: ldir(1,true); break;
				case 0xB8: ldir(-1,true); break;
				case 0xA1: cpir(1,false); break;
				case 0xA9: cpir(-1,false); break;
				case 0xB1: cpir(1,true); break;
				case 0xB9: cpir(-1,true); break;
				case 0xA2:
				case 0xA3:
				case 0xAA:
				case 0xAB:
				case 0xB2:
				case 0xB3:
				case 0xBA:
				case 0xBB: inir_otir(c); break;
//				default: System.out.println(PC+": Not emulated ED/"+c);
			}
		}
	
		private function group_cb():void
		{
			var v:int;
		
			var c:int = env.m1(PC); PC = PC+1 & 0xFFFF;
			ticks+=4; R++;
			var o:int = c>>>3 & 7;
			switch(c & 0xC7) {
				case 0x00: B=shifter(o,B); break;
				case 0x01: C=shifter(o,C); break;
				case 0x02: D=shifter(o,D); break;
				case 0x03: E=shifter(o,E); break;
				case 0x04: HL=HL&0xFF|shifter(o,HL>>>8)<<8; break;
				case 0x05: HL=HL&0xFF00|shifter(o,HL&0xFF); break;
				case 0x06: v = shifter(o,env.memR(HL)); ticks+=4; env.memW(HL,v); ticks+=3; break;
				case 0x07: A=shifter(o,A); break;
				case 0x40: bit(o,B); break;
				case 0x41: bit(o,C); break;
				case 0x42: bit(o,D); break;
				case 0x43: bit(o,E); break;
				case 0x44: bit(o,HL>>>8); break;
				case 0x45: bit(o,HL&0xFF); break;
				case 0x46: bit(o,env.memR(HL)); Ff=Ff&~F53|ir>>8&F53; ticks+=4; break;
				case 0x47: bit(o,A); break;
				case 0x80: B=B&~(1<<o); break;
				case 0x81: C=C&~(1<<o); break;
				case 0x82: D=D&~(1<<o); break;
				case 0x83: E=E&~(1<<o); break;
				case 0x84: HL&=~(0x100<<o); break;
				case 0x85: HL&=~(1<<o); break;
				case 0x86: v = env.memR(HL)&~(1<<o); ticks+=4; env.memW(HL,v); ticks+=3; break;
				case 0x87: A=A&~(1<<o); break;
				case 0xC0: B=B|1<<o; break;
				case 0xC1: C=C|1<<o; break;
				case 0xC2: D=D|1<<o; break;
				case 0xC3: E=E|1<<o; break;
				case 0xC4: HL|=0x100<<o; break;
				case 0xC5: HL|=1<<o; break;
				case 0xC6: v=env.memR(HL)|1<<o; ticks+=4; env.memW(HL,v); ticks+=3; break;
				case 0xC7: A=A|1<<o; break;
			}
		}
	
		private function group_xy_cb( xy:int ):void
		{
			var pc:int = PC;
			var a:int = ir = xy + intToByte(env.memR(pc)) & 0xFFFF;
			ticks += 3;
			var c:int = env.memR(pc+1 & 0xFFFF);
			PC = pc+2 & 0xFFFF;
			ticks += 5;
			var v:int = env.memR(a);
			ticks += 4;

			var o:int = c>>>3 & 7;
			switch( c & 0xC0) {
				case 0x00: v = shifter(o, v); break;
				case 0x40: bit(o, v); Ff=Ff&~F53 | a>>8&F53; return;
				case 0x80: v &= ~(1<<o); break;
				case 0xC0: v |= 1<<o; break;
			}
			env.memW(a, v);
			ticks += 3;
			switch( c & 0x07 ) {
				case 0: B = v; break;
				case 1: C = v; break;
				case 2: D = v; break;
				case 3: E = v; break;
				case 4: HL = HL&0x00FF | v<<8; break;
				case 5: HL = HL&0xFF00 | v; break;
				case 7: A = v; break;
			}
		}
	
		/* interrupts */
	
		private var IFF:int, IM:int;
		private var halted:Boolean;
		
		public function interrupt( bus:int ):Boolean
		{
			if((IFF&1)==0)
				return false;
			IFF = 0;
			halted = false;
			ticks += 6;
			push(PC);
			switch(IM) {
				case 0:	// IM 0
				case 1:	// IM 0
					if((bus|0x38)==0xFF) {
						PC=bus-199;
						break;
					}
					/* not emulated */
				case 2:	// IM 1
					PC = 0x38; break;
				case 3:	// IM 2
					PC = env.mem16R(I<<8 | bus);
					ticks += 6;
					break;
			}
			return true;
		}
		
		public function nmi():void
		{
			IFF &= 2;
			halted = false;
			push(PC);
			ticks += 4;
			PC = 0x66;
		}
		
		public function reset():void
		{
			ticks = -14337;			

			halted = false;
			IFF = IM = 0;
			PC = 0;
			SP = 0xFFFF;
			afW( 0xFFFF );
		}
	}
}