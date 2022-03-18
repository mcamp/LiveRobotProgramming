Class {
	#name : #LRPEv3BrickUI,
	#superclass : #ComposableModel,
	#instVars : [
		'motors',
		'sensors',
		'ev3Instance'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #specs }
LRPEv3BrickUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn add: #motors.
			mainColumn add: #sensors.
		];
		yourself.
]

{ #category : #specs }
LRPEv3BrickUI class >> title [
	^'Ev3 Brick'
]

{ #category : #accessing }
LRPEv3BrickUI >> ev3Instance [
	^ ev3Instance
]

{ #category : #accessing }
LRPEv3BrickUI >> ev3Instance: anObject [
	ev3Instance := anObject
]

{ #category : #accessing }
LRPEv3BrickUI >> extent [
	^300@330
]

{ #category : #initialization }
LRPEv3BrickUI >> initializeWidgets [
	
	motors := LRPEv3MotorsUI new.
	sensors := LRPEv3SensorsUI new.
	
]

{ #category : #accessing }
LRPEv3BrickUI >> motors [
	^ motors
]

{ #category : #accessing }
LRPEv3BrickUI >> motors: anObject [
	motors := anObject
]

{ #category : #accessing }
LRPEv3BrickUI >> sensors [
	^ sensors
]

{ #category : #accessing }
LRPEv3BrickUI >> sensors: anObject [
	sensors := anObject
]

{ #category : #protocol }
LRPEv3BrickUI >> setEv3Instance: anEv3Brick [

	ev3Instance := anEv3Brick.
	motors setEv3Instance: ev3Instance.
	sensors setEv3Instance: ev3Instance.
	
]
