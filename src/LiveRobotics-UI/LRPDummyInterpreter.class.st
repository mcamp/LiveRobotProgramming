"
A LRPDummyInterpreter is a standin for the intertpreter, to allow the UI to run without an interpreter without it having to check for interpreter absence all over the place.

"
Class {
	#name : #LRPDummyInterpreter,
	#superclass : #Object,
	#category : #'LiveRobotics-UI'
}

{ #category : #api }
LRPDummyInterpreter >> newProgram: aProgram [
]

{ #category : #api }
LRPDummyInterpreter >> pauseInterpreter: aBoolean [
]

{ #category : #api }
LRPDummyInterpreter >> rate: aNumber [ 

]

{ #category : #api }
LRPDummyInterpreter >> restartInterpreter: aProgram [
]

{ #category : #api }
LRPDummyInterpreter >> stepRun [
]

{ #category : #api }
LRPDummyInterpreter >> variablesInScopeOf: aMachine [
	^#()
]
