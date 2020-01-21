(
var maxNum= 100;
var win= Window("multi slider test", Rect(100, 100, 640, 320));
var msl= MultiSliderView(win, Rect(10, 10, win.bounds.width-20, win.bounds.height-20));
var list= List.fill(maxNum, 0);
msl.elasticMode= 1;
msl.indexThumbSize= 4;
msl.valueThumbSize= 4;
win.front;

//fake data -2 to 2
Routine({
	inf.do{|i|
		//var fake= 2.0.rand2;
		var fake= sin(i*0.2)*2;

		if(list.size>=maxNum, {
			list.pop;
		});
		list.addFirst(fake.linlin(-2, 2, 0, 1));
		msl.value= list;

		(1/25).wait;
	};
}).play(AppClock);
CmdPeriod.doOnce({win.close});
)