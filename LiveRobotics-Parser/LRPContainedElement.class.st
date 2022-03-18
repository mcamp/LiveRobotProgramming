Class {
	#name : #LRPContainedElement,
	#superclass : #LRPNode,
	#instVars : [
		'container'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #accessing }
LRPContainedElement >> container [
	^ container
]

{ #category : #accessing }
LRPContainedElement >> container: anObject [
	container := anObject
]

{ #category : #accessing }
LRPContainedElement >> outerScope [
	self container ifNotNil: [^self container outerScope].
	^nil.
]
