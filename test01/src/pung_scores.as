
class pung_scores
{
	var mc:MovieClip;
	var scores;
	var chars_num;
	var chars_name;
	var myname;
	
	var so:SharedObject;

	function so_load()
	{
		so=SharedObject.getLocal("www.wetgenes.com");
		var t=so.data;
		
		if(	t.myname) myname=t.myname;
		if(	t.pung00_score0) scores[0]=t.pung00_score0;
		if(	t.pung00_score1) scores[1]=t.pung00_score1;
		if(	t.pung00_score2) scores[2]=t.pung00_score2;
		if(	t.pung00_score3) scores[3]=t.pung00_score3;
		if(	t.pung00_score4) scores[4]=t.pung00_score4;
	}
	function so_save()
	{
		var t=so.data;
		
		t.myname=myname;
		t.pung00_score0=scores[0];
		t.pung00_score1=scores[1];
		t.pung00_score2=scores[2];
		t.pung00_score3=scores[3];
		t.pung00_score4=scores[4];
		
		so.flush();
	}

	function pung_scores(master,name,level)
	{
		
		myname="Me";
		mc=master.createEmptyMovieClip(name,level);
		mc.t=this;
		
		scores=new Array(6);
		
		scores[0]="42;Behold";
		scores[1]="23;the";
		scores[2]="19;stench";
		scores[3]="13;of";
		scores[4]="5;pung";
		scores[5]="";

		chars_num=new Array(5);
		chars_name=new Array(5);

		so_load();
		
		thunk();
		
		mc.onEnterFrame=function()
		{
			if(!this._visible) { return; }
			
			var t=this;
			
//			if(t._alpha>50) { t._alpha-=1; }
			
			t.t.update();
			t.t.draw();
		}
	}

	static function sort_scores(a:String,b:String){ var as=a.split(";");  var bs=b.split(";"); return Number(as[0])<Number(bs[0]); }
	
	function insert(num)
	{
		var aa=scores[0].split(;);
		var str= "" + num + ";" + myname;
		scores[5]=str;
		
		scores.sort(sort_scores);
		
		scores[5]="";
		
		thunk();
		
		so_save();
		
// send to site only if better than last hiscore?	
//		if(Number(aa[0])<num)
//		{

/*
			var record=new LoadVars();
			record.params = "30914_0";
			record.score = num;
			record.sendAndLoad("record.php",record,"POST");
*/

//			record.onLoad = function(){
//			if ((this.recordid+""=="undefined") || (this.recordid<0)) Trace("Score not recorded, "+this.error);
//			if ((this.result+""!="undefined") || (this.result>0)) Trace("Your rank : "+this.result+" / "+this.total);
//		}

	}

	function  onChanged()
	{
		if(mc.mynameis.text)
		{
			myname=mc.mynameis.text;
		}
	}

// create all char text elements
	function thunk()
	{
		var chr;
		var n;
		var nam;
		var num;
		var t;
		var i,j,k;
		var div;
		var sp;
		
		for(i=0;i<5;i++)
		{
			sp=scores[i].split(";");
			num=Number(sp[0]);
//			chars_num[i]=new Array(6);
			div=100000;
			for(k=0;k<7;k++)
			{
				if(k!=3) { div/=10; }
				
				nam=("chars_num"+i)+k;
				if(k==6)
				{
					chr="  " + sp[1];
				}
				else
				if(k==3)
				{
					chr=":";
				}
				else
				{
					n=Math.floor((num/div)%10);
					
					if( (k<2) && (n==0) )
					{
						chr=" ";
					}
					else
					{
						chr=String.fromCharCode(48+n);
					}
				}
				if(k==6)
				{
					mc.createTextField( nam,((i+1)*10+k) , 0 , 0 , 512 , 64 );
				}
				else
				{
					mc.createTextField( nam,((i+1)*10+k) , 0 , 0 , 64 , 64 );
				}
				t=mc[nam];
				t.type="dynamic"; t.embedFonts=true; t.html=true; t.selectable=false;
				t.htmlText="<font face=\"Verdana\" size=\"48\" color=\"#00ff00\">" + chr + "</font>";
				t._x=120+k*32;
				t._y=160+i*48;
				chars_num[i][k]=t;
			}
		}

		mc.createTextField( "mynametxt",9990 , 8*10 , 8*65 , 8*74 , 8*6 );
		t=mc["mynametxt"];t.type="dynamic";t.embedFonts=true;t.html=true; t.selectable=false;
		t.htmlText="<font face=\"Verdana\" size=\"32\" color=\"#00ff00\">My name is : </font>";

		mc.createTextField( "mynameis",9991 , 8*38 , 8*65 , 8*48 , 8*6 );
		t=mc["mynameis"];t.type="input";t.embedFonts=true;t.selectable=true;
		t.text=myname;
		t.restrict="0123456789ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		t.maxChars=16;

		var fmt=new TextFormat();
		fmt.font="Verdana";
		fmt.size=32;
		fmt.color=0x00ff00;
		t.setTextFormat(fmt);
		t.addListener(this);
		

		mc.createTextField( "continue",9992 , 8*10 , 8*57 , 8*74 , 8*6 );
		t=mc["continue"];t.type="dynamic";t.embedFonts=true;t.html=true; t.selectable=false;
		t.htmlText="<a href=\"asfunction:_root.click_continue\"><font face=\"Verdana\" size=\"32\" color=\"#00ff00\">Click or press SPACE to continue.</font></a>";
		

	}

	function update()
	{
	}

	function draw()
	{
	}
	
}

