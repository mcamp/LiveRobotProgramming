Class {
	#name : #LRPEv3SensorButtonInfoUI,
	#superclass : #ComposableModel,
	#instVars : [
		'button',
		'label',
		'sensorInstance'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #specs }
LRPEv3SensorButtonInfoUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn add:  #button height: self toolbarHeight * 2.
			mainColumn add:  #label height: self toolbarHeight * 2.
		];
		yourself.
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> button [
	^ button
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> button: anObject [
	button := anObject
]

{ #category : #initialization }
LRPEv3SensorButtonInfoUI >> initializeWidgets [
	
	button := self newButton.
	label := self newLabel.
	button action: [ sensorInstance inspect ]
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> label [
	^ label
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> label: anObject [
	label := anObject
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> sensorInstance [
	^ sensorInstance
]

{ #category : #accessing }
LRPEv3SensorButtonInfoUI >> sensorInstance: anObject [
	sensorInstance := anObject
]

{ #category : #protocol }
LRPEv3SensorButtonInfoUI >> setSensorInstance: anEv3Sensor [

	sensorInstance := anEv3Sensor.
	button label: 'sensor ',(sensorInstance brickPort + 1) asString.
	label label: sensorInstance getSensorType.
]
