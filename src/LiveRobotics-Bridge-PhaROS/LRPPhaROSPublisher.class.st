Class {
	#name : #LRPPhaROSPublisher,
	#superclass : #LRPPhaROSTopic,
	#instVars : [
		'phaROSPublisher'
	],
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #accessing }
LRPPhaROSPublisher >> phaROSPublisher [
	^ phaROSPublisher
]

{ #category : #accessing }
LRPPhaROSPublisher >> phaROSPublisher: anObject [
	phaROSPublisher := anObject
]

{ #category : #printing }
LRPPhaROSPublisher >> printOn: aStream [

	aStream nextPutAll: varName.
	aStream nextPutAll:  ' -> '.
	aStream nextPutAll:  topicID.
	aStream nextPutAll: ' ['.
	aStream nextPutAll: type.
	aStream nextPutAll: ']'.
]
