"
A LRPTestSingleton class is a class that provides a singleton for easy access of the Smalltalk world from within the LRP world, to be used in tests.

"
Class {
	#name : #LRPTestSingleton,
	#superclass : #Object,
	#classInstVars : [
		'instance'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #accessing }
LRPTestSingleton class >> instance [
	^ instance
]

{ #category : #accessing }
LRPTestSingleton class >> instance: anObject [
	instance := anObject
]
