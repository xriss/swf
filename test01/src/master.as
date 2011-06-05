
class master {

	// --- Main Entry Point
	static function main()
	{
		_root.ti=0;
		
		_root.xml=new XML();
		
		if(_root.f_args)
		{
			_root.xml.load("xml.php?cmd="+_root.f_cmd+"&user="+_root.f_user+"&min="+_root.f_min+"&max="+_root.f_max);
		}
		else
		{
			_root.xml.load("test.xml");
		}
		
		_root.init_xml=false;
		_root.init_draw=false;
		
		_root.onEnterFrame=function()
		{
			with(this)
			{


 
			
if (xml.loaded)	// should be fast...
{
//    var p = getxmldata.firstChild;
//    xmldoc = getxmldata.childNodes;
//    node_name=p.nodeName;
//    topic=p.attributes.topic;
//    author=p.attributes.author;

if(init_xml==false)
{
	this.dat=new Array();
	this.dat_numof=0;
	this.dat_max=1;
	
	
	var xml_dat=xml.firstChild.firstChild;
	var i=0;
	
	i=0;
	while(xml_dat)
	{
		if(xml_dat.nodeName=="turn")
		{
			dat[i]=Number(xml_dat.attributes.pop);
			if(dat_max<dat[i]) { dat_max=dat[i]; }
			
			i++;
			dat_numof=i;
		}
		xml_dat=xml_dat.nextSibling;
	}
	
	init_xml=true;
}
else
if(init_draw==false)
{

				clear();

//				lineStyle( 4, 0x8080ff, 50 );

				var xmin,ymin,xmax,ymax;	// graph area within clip
				var xsiz,ysiz; 				// max-min
				var xmul,ymul; 				// scale input numbers to fit into output
				
				xmin=(0+8)*16;
				ymin=(0+8)*16;
				
				xmax=(256-8)*16;
				ymax=(128-8)*16;
				
				xsiz=xmax-xmin;
				ysiz=ymax-ymin;
				
				xmul=xsiz/(dat_numof-1);
				ymul=ysiz/dat_max;
				
				beginFill(0x8080ff,50);
				moveTo(xmin,ymax);
				for(i=0;i<dat_numof;i++)
				{
					lineTo(xmin+i*xmul,ymax-dat[i]*ymul);
				}
				lineTo(xmax,ymax);
				lineTo(xmin,ymax);
				endFill();

				for(tt=4;tt>=1;tt--)
				{
					var tx,ty;
					
					tx=0.05*tt;
					ty=(tx*xmul)/ymul;
					
					for(i=0;i<dat_numof-1;i++)
					{
						var t;
						
						t=(dat[i]*ymul-dat[i+1]*ymul);
						
						beginFill(0x8080ff,25);
						moveTo(xmin+(i+tx)  *xmul,ymax-ty*ymul);
						lineTo(xmin+(i+tx)  *xmul,ymax-(dat[i]-ty)*ymul+tx*t);
						lineTo(xmin+(i+1-tx)*xmul,ymax-(dat[i+1]-ty)*ymul-tx*t);
						lineTo(xmin+(i+1-tx)*xmul,ymax-ty*ymul);
						lineTo(xmin+(i+tx)  *xmul,ymax-ty*ymul);
						endFill();
					}
				}

				
	init_draw=true;
}
}
			}
		}
	}

}
	