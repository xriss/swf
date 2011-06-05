/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class Trans
{
	var mc:MovieClip=null;

	function out(state)
	{
	
		if(mc!=null)
		{
			mc.removeMovieClip();
			mc=null;
		}
		
		if(_root.main.opt_transitions)
		{
			mc=state.mc;	// streal movieclip from state
			state.mc=null;
			
			mc.swapDepths(99999);	// move to front
			
			mc._alpha=100;
			mc.trans=this;
			mc._xmouse_=mc._xmouse;
			mc._ymouse_=mc._ymouse;
			mc.onEnterFrame=function()	// perform transition
			{
				this._xscale*=1.02;
				this._yscale*=1.02;
				
				this._x=(this._xmouse_-(this._xscale*this._xmouse_/100));
				this._y=(this._ymouse_-(this._yscale*this._ymouse_/100));
	
				this._alpha*=0.9;
				if(this._alpha<1)
				{
					this.trans.mc=null;
					this.removeMovieClip();
				}
			}
		}
	}
}