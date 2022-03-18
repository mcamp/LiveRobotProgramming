"
A LRPErrorHandler class is the top of the hierarchy of possible error handlers for LRP. It is a singleton, with a default instance of the dummy error handler.
"
Class {
	#name : #LRPErrorHandler,
	#superclass : #Object,
	#classInstVars : [
		'instance'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #accessing }
LRPErrorHandler class >> instance [
	instance isNil ifTrue: [instance := LRPDummyErrorHandler new].
	^instance
]

{ #category : #accessing }
LRPErrorHandler class >> instance: anErrorHandler [
	instance := anErrorHandler
]

{ #category : #'error handling' }
LRPErrorHandler >> duplicateVar: aVarName [ 
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> error: anException inBlock: aBlock [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> eventHasNotBool: anEvent value: anObject [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> eventNotFound: anEventName machine: aLRPMachine [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> machineNotFound: aMachineName [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> machineNotSpawnable: aMachine [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> stateNotFound: aStateName machine: aLRPMachine [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> timeoutIsNotNumber: aLRPTransition timeout: aValue [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> varNotFound: aVarName [
	^self subclassResponsibility 
]

{ #category : #'error handling' }
LRPErrorHandler >> varNotFound: aVarName transition: aTransitionName [
	^self subclassResponsibility 
]
