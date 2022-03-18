Class {
	#name : #LRPErrorNode,
	#superclass : #LRPContainedElement,
	#instVars : [
		'failPosition'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #visiting }
LRPErrorNode >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitErrorNode: self.
]

{ #category : #accessing }
LRPErrorNode >> failPosition [
	^ failPosition
]

{ #category : #accessing }
LRPErrorNode >> failPosition: anObject [
	failPosition := anObject
]

{ #category : #testing }
LRPErrorNode >> isError [
	^true
]

{ #category : #'error handing' }
LRPErrorNode >> onErrorNode: aBlock [ 

	aBlock value.

]
