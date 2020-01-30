~reward= Routine(
	~timer= [0,0,0,0];
	~timeThreshold= 1000; //set to 1000 as it is not used at the moment
	~move= 0;
	//0: elapsed time since routine started
	//1: total time above ~threshold
	//2: current time spent above ~threshold
	//3: how often was ~timeThreshold met
	{inf.do{ |i|
		~timer[0]= ~timer[0]+1;
		(~toThreshold >= ~threshold).if {
			~timer[1]= ~timer[1]+1;
			~timer[2]= ~timer[2]+1;

			(~timer[2]%~timeThreshold == 0).if {
				~timer[3]= ~timer[3]+1
			}

		} {
			~timer[2]= 0; //restart
		};

		~timer.postln;

		(~timer[3]== ~timeThreshold).if {
			~move= 1
		};

		/*(~timer[0] == 20).if {
			~move= -1
		};*/


		/*
		(~move == 1).if {

			(~currentForestFlowDepth < ~forestFlow.size).if {
			"go deeper".postln;
			~forestFlow.valueArray(~~forestFlow[~~currentForestFlowDepth+1]);
			~timer= [0,0,0,0];
			~move= 0;
			} {
			}
		};

		(~move == -1).if {
			"go outside".postln;
			//~forestFlow.valueArray(~~forestFlow[~~currentForestFlowDepth-1]);
			~timer= [0,0,0,0];
			~move= 0;
		};*/

		1.wait}
	}
);