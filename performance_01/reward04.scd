~reward= Routine(
	~timer = [0,0,0,0];
	~hiBandEnergy = 10;
	~timeThreshold = 1000; //set to 1000 as it is not used at the moment;
	~move = 0;
	// 0: elapsed time since routine started
	// 1: total time above ~threshold
	// 2: current time spent above ~threshold
	// 3: how often was ~timeThreshold met
	{inf.do{ |i|
		~rec.extra= [~hiBandEnergy,~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~phaseSync1,~phaseSync2,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]]; //update DataRecord;
		~timer[0] = ~timer[0]+1;
		(~bandEnergyAvg[0] >= ~hiBandEnergy).if {
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



/*
thoughtless awareness
> effortless awareness
> choiceless awareness
> experiential focus

>> increase fmTheta (FZ; ACC)
>> decrease Gamma (PZ, PCC)

use local variables above ifs or global (probably local, one order higher);
1. caculate what is 50% success, set threshold to that manually/automatically;
2. rewards types:
2.1. signal hits threshold;
2.2. signal is above threshold;
2.3. signal was above threshold for a set amount of time;
*/