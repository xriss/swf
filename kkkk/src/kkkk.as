
class kkkk
{
	static var m;
	
	// --- Main Entry Point
/*
	static function main()
	{
		_root.k=new kkkk();
	}
*/
	
#include "src/kkkk_subs.as"

	static function main()
	{
		var i,j,k;
		var r;
		var x,y;
		
		m=create_clip(_root);		
		
		m.lineStyle(undefined,undefined);
		m.moveTo(0,0);
		m.beginFill(0x000000,100);
		m.lineTo(640,0);
		m.lineTo(640,480);
		m.lineTo(0,480);
		m.lineTo(0,0);
		m.endFill();
		
		m.tf=create_text_html(m,10000,0,0,640,480);
		
		rnd_seed(undefined,0);
		
		_root.onEnterFrame=kkkk.upd;
		
		m.bgs=[];
	}
	
	static var think=0;
	
	static function upd()
	{
	var i,r;
	
		if(think<100)
		{
			for(i=0;i<10;i++)
			{
				r=create_clip(m);
				m.bgs[think]=r;
				
				r.seed=rnd();
				
				blob(r);
				
				r._x=rnd()%640;
				r._y=rnd()%480;
				r._f=rnd()%16;
				
				r.vx=3*(rnd()-32768)/32768;
				r.vy=3*(rnd()-32768)/32768;
				
				
				think++;
			}
			m.tf.htmlText="thinking "+think;
			return;
		}
		
		
		dbg();
	
		
		for(i=0;i<m.bgs.length;i++)
		{
			r=m.bgs[i];
			
			r._x+=r.vx;
			r._y+=r.vy;
			
			if(r._x<0+32)   if(r.vx<0) { r.vx*=-1; }//r._xscale*=-1; }
			if(r._y<0+32)   if(r.vy<0) { r.vy*=-1; }
			if(r._x>640-32) if(r.vx>0) { r.vx*=-1; }//r._xscale*=-1; }
			if(r._y>480-32) if(r.vy>0) { r.vy*=-1; }
			
			r._f++;
			blobf(r,r._f);
			
		}
	}
}