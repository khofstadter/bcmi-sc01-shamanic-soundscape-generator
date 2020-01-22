/*
TODO
- all counters could be mapped to the soundscape;
- add new variable to decide when to move;
- other rewards to consider:
- - signal hits threshold;
- - signal is above threshold;
- - signal was above threshold for a set amount of time;
*/

~reward= Routine(
	~timer = [0,0,0,0];
	~hiThetaEnergy = 10;
	~timeThreshold = 1000;
	~move = 0;
	// 0: elapsed time since routine started
	// 1: total time above ~threshold
	// 2: current time spent above ~threshold
	// 3: how often was ~timeThreshold met
	{inf.do{ |i|
		~rec.extra= [~energyTheta,~hiThetaEnergy, ~currentForestDepth,~timer]; //update DataRecord;
		~timer[0] = ~timer[0]+1;
		(~energyTheta >= ~hiThetaEnergy).if {
			~timer[1] = ~timer[1]+1;
			~timer[2] = ~timer[2]+1;

			(~timer[2]%~timeThreshold == 0).if {
				~timer[3] = ~timer[3]+1
			}

		} {
			~timer[2] = 0; //restart
		};

		~timer.postln;

		(~timer[3] == ~timeThreshold).if {
			~move = 1
		};

		/*(~timer[0] == 20).if {
			~move = -1
		};*/


		/*
		(~move == 1).if {

			(~currentForestFlowDepth < ~forestFlow.size).if {
			"go deeper".postln;
			~forestFlow.valueArray(~~forestFlow[~~currentForestFlowDepth+1]);
			~timer = [0,0,0,0];
			~move = 0;
			} {
			}
		};

		(~move == -1).if {
			"go outside".postln;
			//~forestFlow.valueArray(~~forestFlow[~~currentForestFlowDepth-1]);
			~timer = [0,0,0,0];
			~move = 0;
		};*/

		1.wait}});