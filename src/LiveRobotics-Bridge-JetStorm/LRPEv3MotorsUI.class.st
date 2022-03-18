Class {
	#name : #LRPEv3MotorsUI,
	#superclass : #ComposableModel,
	#instVars : [
		'stopButton',
		'buttonA',
		'buttonB',
		'buttonC',
		'buttonD',
		'label',
		'ev3Instance'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #specs }
LRPEv3MotorsUI class >> defaultSpec [

	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn add: #label height: self toolbarHeight.
			mainColumn newRow: [ :row| row add: #buttonA. row add: #buttonB. row add: #buttonC. row add: #buttonD ] height: self toolbarHeight * 2.
			mainColumn add: #stopButton height: self toolbarHeight * 2.
	];
	yourself.
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonA [
	^ buttonA
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonA: anObject [
	buttonA := anObject
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonB [
	^ buttonB
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonB: anObject [
	buttonB := anObject
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonC [
	^ buttonC
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonC: anObject [
	buttonC := anObject
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonD [
	^ buttonD
]

{ #category : #accessing }
LRPEv3MotorsUI >> buttonD: anObject [
	buttonD := anObject
]

{ #category : #accessing }
LRPEv3MotorsUI >> ev3Instance [
	^ ev3Instance
]

{ #category : #accessing }
LRPEv3MotorsUI >> ev3Instance: anObject [
	ev3Instance := anObject
]

{ #category : #initialization }
LRPEv3MotorsUI >> initializeWidgets [
	
	buttonA := self newButton.
	buttonB := self newButton.
	buttonC := self newButton.
	buttonD := self newButton.
	stopButton := self newButton.
	label := self newLabel.
	
	buttonA label: 'Motor A'.
	buttonB label: 'Motor B'.
	buttonC label: 'Motor C'.
	buttonD label: 'Motor D'.
	stopButton label: 'STOP all motors'.
	label label: 'Motors:'.
	
	buttonA action: [ ev3Instance motorA inspect.	].
	buttonB action: [ ev3Instance motorB inspect.	].
	buttonC action: [ ev3Instance motorC inspect.	].
	buttonD action: [ 	ev3Instance motorD inspect.	].
	stopButton action: [
		ev3Instance motorA stop.
		ev3Instance motorB stop.
		ev3Instance motorC stop.
		ev3Instance motorD stop. ].
]

{ #category : #accessing }
LRPEv3MotorsUI >> label [
	^ label
]

{ #category : #accessing }
LRPEv3MotorsUI >> label: anObject [
	label := anObject
]

{ #category : #protocol }
LRPEv3MotorsUI >> setEv3Instance: anEv3Brick [
	
	ev3Instance := anEv3Brick.
]

{ #category : #accessing }
LRPEv3MotorsUI >> stopButton [
	^ stopButton
]

{ #category : #accessing }
LRPEv3MotorsUI >> stopButton: anObject [
	stopButton := anObject
]
