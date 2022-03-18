"
I am a queue that transfers program updates to the interpreter.

I use a separate thread to send the updates so that the user interface is more responsive.
"
Class {
	#name : #LRPProgramUpdateQueue,
	#superclass : #Object,
	#instVars : [
		'queue',
		'parser',
		'interpreter',
		'thread',
		'ui'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #'instance creation' }
LRPProgramUpdateQueue class >> forInterpreter: anInterpreter parser: aParser andUI: aUI [
	| inst |
	inst := self new.
	inst interpreter: anInterpreter;
		parser: aParser;
		ui: aUI.
	^inst
]

{ #category : #'initialize - release' }
LRPProgramUpdateQueue >> cleanUp [
	"thread terminate."
]

{ #category : #'initialize - release' }
LRPProgramUpdateQueue >> initialize [
	super initialize.
	"queue := AtomicSharedQueue new.
	thread := [|program|
		[ true ] whileTrue: [ 
			program := queue next."
			"for modules this should be
			interpreter newProgramForUI: program. (parser resolveImports: program)"
			"interpreter newProgramForUI: program.
			ui updateWith: program.]
		] fork. "
]

{ #category : #accessing }
LRPProgramUpdateQueue >> interpreter: anObject [
	interpreter := anObject
]

{ #category : #adding }
LRPProgramUpdateQueue >> newProgram: aProgram [
	"remove all programs that have not yet been visualized, they are obsolete."
"	queue flush.
	queue nextPut: aProgram."
	
	
	self flag: #Fixme.
	"Do not use the queue, it leads to concurrency issues in the varable view"
	interpreter newProgramForUI: (LRPProgram fromAST: aProgram).
	ui updateWith: aProgram.
]

{ #category : #accessing }
LRPProgramUpdateQueue >> parser: anObject [
	parser := anObject
]

{ #category : #accessing }
LRPProgramUpdateQueue >> ui: anObject [
	ui := anObject
]
