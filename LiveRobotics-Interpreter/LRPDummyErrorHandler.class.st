"
A LRPDummyErrorHandler class is an error handler that ignores all errors.
"
Class {
	#name : #LRPDummyErrorHandler,
	#superclass : #LRPErrorHandler,
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #'error handling' }
LRPDummyErrorHandler >> duplicateVar: aVarName [ 
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> error: anException inBlock: aBlock [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> eventHasNotBool: anEvent value: anObject [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> eventNotFound: anEventName machine: aLRPMachine [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> machineNotFound: aMachineName [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> machineNotSpawnable: aMachine [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> stateNotFound: aStateName machine: aLRPMachine [
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> timeoutIsNotNumber: aLRPTransition [
	
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> timeoutIsNotNumber: aLRPTransition timeout: aValue [
	
]

{ #category : #'error handling' }
LRPDummyErrorHandler >> varNotFound: aVarName [

]

{ #category : #'error handling' }
LRPDummyErrorHandler >> varNotFound: aVarName transition: aTransitionName [

]
