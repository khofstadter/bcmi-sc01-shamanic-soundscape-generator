# BCMI-soundscape-01
## Shamanic Soundscape Generator

The SuperCollider program in this repository was used with the [OpenBCI-SuperCollider Interface](https://github.com/krisztian-hofstadter-tedor/OpenBCI-SuperCollider), together as a Brain-Computer Music Interface (the BCMI-2) to test auditory entrainment with neurofeedback.

The project titled, BCMI-2 aimed to help participants create and maintain an altered state of mind, more specifically the shamanic state of mind.

//TODO test with EEG  
//TODO refine this README.md  
//TODO record 4 channel audio with 4speaker-test.scd for reference when mixing  
//TODO fine tune how ~phaseCalcFuncVal is used for sound spatialisation  
//TODO alternative to '4 ndefs.scd' files  
//TODO timer that can move between levels  
//TODO add timer to timer[0] that counts whole session  
//TODO universal sound indicating level numbers/forest depths - instead of English  
//TODO group ndefs and find mixing solution  

## workflow for two types of use

### personal NF session

(was used in neurofeedback sessions)

- adjust code between 2-4 channel, and + live input performance

1. 30 min prior
- make space on hdd
- switch wifi/dropbox/screensaver off
- prep iPhone (airplane mode, silent, wifi-BLU off, auto lock: never, lock iPhone camera screen)

2. session
- participant to fill top of questionnaire while putting EEG cap on
- start up Screenflow (don't start recording)
- all audio to 48k in Audio Midi
- start screen-recording [configure] iphone + internal mic, computer audio, screen
- with 'openbci_gui_timeseries.scd' reduce impedance, close this file
- in 'openbci_gui_fftplot_with_neurofeedback-2ch.scd', reduce 50hz noise
- in 'main.scd':
	- enter the forest and start recording raw EEG and audio file;
	- check that extra is saved in text file if desired
	- manually adjust threshold for NFT
	- start moving inwards

	(more details in 'main.scd' file)

### NF presentation + performance

(was used in public presentations e.g. https://youtu.be/lFVzwZtmecc)

- adjust code between 2-4 channel, and + live input performance

1. 2-4h prior:
- setup gear (time consuming)
- test 4 speakers with sinwaves (performance code is 1243 instead of 1234)
- screensaver off
- bluetooth,dropbox off (wifi on for presentation)
- system pref: ultralight as audio in/out
- audio sampling rate: 48k (set all in/out)
- motu app: 1in + out (with sm57 setting)
- out fresh batteries in OpenBCI and test connection
- adjust all volume (mix) - with someone
- test video recording and calculate light needed
- download youtube video (m test)

2. 30min prior:
- put on wet cap and test impedance
- adjust lights in the room
- turn on recording on camera + phone + h1 zoom

3. presentation (20 min)
- questions with orientation page
- focus is one soundscape: shamanic journeying
- explain one test with m (youtube video downloaded)
- what is different between the tests and this performance?
- there is not much gaming element to this performance - why?
- 15 vs. 30 minutes
- how to listen? digital shamans (drums annd chakapa), live drumming, other sounds
- how much would you like me to explain about the mapping before the performance, maybe after is better
- listen to the static/monotone elements the digital shaman (drumming from the speakers)
- eyes open/closed
- no intent - no journey :)
- drawing after


4. performance (15 min long)
- turn wifi off;
	1. screenrecord (screen and internal mic only)
	2. with timeseries, check impedance again (adjust EEG if needed)
	3. read EEG (with fft plot + nf with coherance)

	- adjust supercollider audio to -3.1

	3. Q/A and drawing

	- limitless options for mapping eeg to sound - but it needs to be meaningful and in-line with training e.g. even timer variables that could be used for more game like rewards, musical changes

	4. plotting with audio
