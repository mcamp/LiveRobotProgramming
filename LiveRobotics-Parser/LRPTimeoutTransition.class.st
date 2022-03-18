Class {
	#name : #LRPTimeoutTransition,
	#superclass : #LRPTransition,
	#instVars : [
		'maxTime'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #printing }
LRPTimeoutTransition >> printOn: aStream [

	aStream nextPutAll: 'LRPTimeoutTransition '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self from.
	aStream nextPutAll: '->'.
	aStream nextPutAll: self to.
	aStream nextPutAll: ' on '.
	aStream nextPutAll: self eventname asString.
]
