"
I am a bridge to JetStorm, to be able to connect to Lego Mindstorms EV3 kits.

To load JetStorm:
Gofer it
	smalltalkhubUser: 'JLaval' project: 'JetStorm';
	configuration;
	loadBleedingEdge
"
Class {
	#name : #LRPJetStormBridge,
	#superclass : #LRPAbstractBridge,
	#classVars : [
		'defaultIP',
		'ev3Instance'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #accessing }
LRPJetStormBridge class >> defaultIP [
	^ defaultIP
]

{ #category : #accessing }
LRPJetStormBridge class >> defaultIP: anObject [
	defaultIP := anObject
]

{ #category : #accessing }
LRPJetStormBridge class >> ev3Instance [
	^ ev3Instance
]

{ #category : #accessing }
LRPJetStormBridge class >> ev3Instance: anObject [
	ev3Instance := anObject
]

{ #category : #accessing }
LRPJetStormBridge >> defaultIP [

	^self class defaultIP.
]

{ #category : #accessing }
LRPJetStormBridge >> defaultIP: anIP [

	self class defaultIP: anIP.
]

{ #category : #accessing }
LRPJetStormBridge >> ev3Instance [

	^self class ev3Instance.
]

{ #category : #accessing }
LRPJetStormBridge >> ev3Instance: anEv3Brick [

	self class ev3Instance: anEv3Brick.
]

{ #category : #generating }
LRPJetStormBridge >> generateAuxMethods [

	self generateFullStopMethod
]

{ #category : #'generating - aux' }
LRPJetStormBridge >> generateFullStopMethod [

	self addMethod: 'fullStop'
				source: '
	self motorA stopBrake: true reply: false.
	self motorB stopBrake: true reply: false.
	self motorC stopBrake: true reply: false.
	self motorD stopBrake: true reply: false.'.
]

{ #category : #generating }
LRPJetStormBridge >> generateMethods [

	self generateMotorMethods.
	self generateSensorMethods.
	self generateAuxMethods.
]

{ #category : #generating }
LRPJetStormBridge >> generateMotorMethods [

	#(A B C D) do:[:motor|
		self addMethod: ('motor',motor)
				source: ('^__lrpBridge ev3Instance motor',motor).
	]
]

{ #category : #generating }
LRPJetStormBridge >> generateSensorMethods [

	#(1 2 3 4) do:[:sensor|
		self addMethod: ('sensor',sensor asString)
				source: ('^__lrpBridge ev3Instance sensor',sensor asString).
	]
]

{ #category : #setup }
LRPJetStormBridge >> newInstanceWithIP: anIP [

	self defaultIP: anIP.
	self ev3Instance: (Ev3Brick newIp: anIP daisyChain: #EV3).
	self ev3Instance detectSensors.
]

{ #category : #ui }
LRPJetStormBridge >> openUIFor: anInterpreter [
	
	self setupEV3IP.
	self generateMethods.
	^LRPEv3BrickUI new setEv3Instance: self ev3Instance; openWithSpec.
]

{ #category : #setup }
LRPJetStormBridge >> resetAndNewInstanceWithIP: anIP [

	self ev3Instance ifNotNil: [
		[self ev3Instance bridge disconnect] ifError:["do nothing"]
	].
	self newInstanceWithIP: anIP.
]

{ #category : #setup }
LRPJetStormBridge >> setupEV3IP [
	|eV3IP|
	
	eV3IP := ((LRPEV3IPRequest new defaultIP: self defaultIP) signal).
	eV3IP ifNil:[
		self error: 'No IP address given'.
	] ifNotNil:[
		self resetAndNewInstanceWithIP: eV3IP.
	].
]
