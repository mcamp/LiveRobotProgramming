Class {
	#name : #LRPSpawn,
	#superclass : #LRPNode,
	#instVars : [
		'machine',
		'state'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPSpawn class >> machine: machineName state: stateName [
	|retval|
	retval := self new.
	retval machine: machineName.
	retval state: stateName.
	^retval
]

{ #category : #visiting }
LRPSpawn >> acceptVisitor: aLRPNodeVisitor [
	^aLRPNodeVisitor visitSpawnNode: self
]

{ #category : #find }
LRPSpawn >> findBestLRPNodeFor: anInteger [
	^self.
]

{ #category : #accessing }
LRPSpawn >> machine [
	^ machine
]

{ #category : #accessing }
LRPSpawn >> machine: anObject [
	machine := anObject
]

{ #category : #printing }
LRPSpawn >> printOn: aStream [
	aStream nextPutAll: 'LRPSpawn '.
	aStream nextPutAll: machine asString.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: state asString.
]

{ #category : #accessing }
LRPSpawn >> state [
	^ state
]

{ #category : #accessing }
LRPSpawn >> state: anObject [
	state := anObject
]
