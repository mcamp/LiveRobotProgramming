Class {
	#name : #LRPEv3SensorsUI,
	#superclass : #ComposableModel,
	#instVars : [
		'label',
		'sensor1',
		'sensor2',
		'sensor3',
		'sensor4',
		'ev3Instance'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #specs }
LRPEv3SensorsUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn add:  #label height: (self toolbarHeight).
			mainColumn newRow: 
				[ :row|	row add: #sensor1. row add: #sensor2. row add: #sensor3. row add: #sensor4.] 
		];
		yourself.
]

{ #category : #accessing }
LRPEv3SensorsUI >> ev3Instance [
	^ ev3Instance
]

{ #category : #accessing }
LRPEv3SensorsUI >> ev3Instance: anObject [
	ev3Instance := anObject
]

{ #category : #initialization }
LRPEv3SensorsUI >> initializeWidgets [
	
	sensor1 := LRPEv3SensorButtonInfoUI new.
	sensor2 := LRPEv3SensorButtonInfoUI new.
	sensor3 := LRPEv3SensorButtonInfoUI new.
	sensor4 := LRPEv3SensorButtonInfoUI new.
	label := self newLabel.
	
	label label: 'Sensors:'	
	
	
]

{ #category : #accessing }
LRPEv3SensorsUI >> label [
	^ label
]

{ #category : #accessing }
LRPEv3SensorsUI >> label: anObject [
	label := anObject
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor1 [
	^ sensor1
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor1: anObject [
	sensor1 := anObject
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor2 [
	^ sensor2
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor2: anObject [
	sensor2 := anObject
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor3 [
	^ sensor3
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor3: anObject [
	sensor3 := anObject
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor4 [
	^ sensor4
]

{ #category : #accessing }
LRPEv3SensorsUI >> sensor4: anObject [
	sensor4 := anObject
]

{ #category : #protocol }
LRPEv3SensorsUI >> setEv3Instance: anEv3Brick [

	ev3Instance := anEv3Brick.
	sensor1 setSensorInstance: ev3Instance sensor1.
	sensor2 setSensorInstance: ev3Instance sensor2.
	sensor3 setSensorInstance: ev3Instance sensor3.
	sensor4 setSensorInstance: ev3Instance sensor4.
]
