Class {
	#name : #LRPEpsilonTransition,
	#superclass : #LRPTransition,
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPEpsilonTransition class >> from: startState to: endState name: aString [
	|retval|
	retval := self new.
	retval from: startState.
	retval to: endState.
	retval name: aString.
	^ retval.
]

{ #category : #'instance creation' }
LRPEpsilonTransition class >> on: anEvent from: startState to: endState name: aString [

	self error: 'Epsilon Transitions have no events. Use from:to:name: instead.'
]

{ #category : #'syntax highlighting' }
LRPEpsilonTransition >> arrowIndex [
	^3
]

{ #category : #printing }
LRPEpsilonTransition >> printOn: aStream [

	aStream nextPutAll: 'LRPEpsilonTransition '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self from.
	aStream nextPutAll: '->'.
	aStream nextPutAll: self to.
]
