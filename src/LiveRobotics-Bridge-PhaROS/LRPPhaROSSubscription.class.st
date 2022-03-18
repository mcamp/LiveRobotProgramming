Class {
	#name : #LRPPhaROSSubscription,
	#superclass : #LRPPhaROSTopic,
	#instVars : [
		'phaROSFlux'
	],
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #accessing }
LRPPhaROSSubscription >> phaROSFlux [
	^ phaROSFlux
]

{ #category : #accessing }
LRPPhaROSSubscription >> phaROSFlux: anObject [
	phaROSFlux := anObject
]

{ #category : #printing }
LRPPhaROSSubscription >> printOn: aStream [

	aStream nextPutAll: varName.
	aStream nextPutAll:  ' <- '.
	aStream nextPutAll:  topicID.
	aStream nextPutAll: ' ['.
	aStream nextPutAll: type.
	aStream nextPutAll: ']'.
]
