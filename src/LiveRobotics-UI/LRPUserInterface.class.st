"
A LRPUserInterface is the user interface for LRP

Instance Variables
	codePane: the code editor
	visPane:	the interpreter visualization
"
Class {
	#name : #LRPUserInterface,
	#superclass : #ComposableModel,
	#instVars : [
		'codePane',
		'visPane'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #specs }
LRPUserInterface class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed 
		"one top-level column with one top-level row"
		newColumn: [:tcol|
			tcol newRow: [:trow|
				trow add: #codePane width: 550;
					"addSplitter;"
					add: #visPane ]].
]

{ #category : #specs }
LRPUserInterface class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'Live Robot Programming')
		order: 0.1; 
		icon: (Smalltalk ui icons iconNamed: #windowIcon);
		label: 'Live Robot Programming';
		action:[ LRPInterpreter startWithUI: self]
]

{ #category : #opening }
LRPUserInterface class >> open [
	|inst|
	inst := self new.
	inst openWithSpec.
	^inst
]

{ #category : #opening }
LRPUserInterface class >> openOnInterpreter: anInterpreter [
	|inst|
	inst := self open.
	inst interpreter: anInterpreter.
	^inst
]

{ #category : #specs }
LRPUserInterface class >> title [
	^'Live Robot Programming UI'
]

{ #category : #'initialize-release' }
LRPUserInterface >> actionOnClose [

	LRPAbstractBridge cleanUp.
	self codePane cleanUp.
	LRPErrorHandler instance delete.
]

{ #category : #accessing }
LRPUserInterface >> codePane [
	^ codePane
]

{ #category : #accessing }
LRPUserInterface >> codePane: anObject [
	codePane := anObject
]

{ #category : #accessing }
LRPUserInterface >> extent [
	^1000@600
]

{ #category : #api }
LRPUserInterface >> highlightState: aLRPState [ 

	visPane highlightState: aLRPState 
]

{ #category : #api }
LRPUserInterface >> highlightTransition: aLRPTransition [ 
	visPane highlightTransition: aLRPTransition 
]

{ #category : #'initialize-release' }
LRPUserInterface >> initialize [
	| errorHandler win |
	super initialize.
	errorHandler := LRPErrorHandlerUI new.
	errorHandler styler: self codePane styler.
	win := errorHandler openWithSpec.
	win widget widget deleteCloseBox.
	LRPErrorHandler instance: errorHandler.
]

{ #category : #'initialize-release' }
LRPUserInterface >> initializePresenter [
	
	codePane codeChangeBlock: [ :model |
		"due to bad(?) error handling of rubric"	
		[visPane lastmodel: model.
		visPane updateVis.] on: Error do: [ :error | error debug.]
	].

	self whenWindowChanged: [  
		self window whenClosedDo: [ self actionOnClose ]
	].
]

{ #category : #'initialize-release' }
LRPUserInterface >> initializeWidgets [

	codePane := self instantiate: LRPProgramEditor.
	visPane := self instantiate: LRPProgramVisualization.
	visPane code: codePane.
]

{ #category : #api }
LRPUserInterface >> interpreter: anInterpreter [
	codePane interpreter: anInterpreter.
	visPane interpreter: anInterpreter.
]

{ #category : #api }
LRPUserInterface >> varChange: aVar inMachine: aMachine [

	self visPane varChange: aVar inMachine: aMachine
]

{ #category : #accessing }
LRPUserInterface >> visPane [
	^ visPane
]

{ #category : #accessing }
LRPUserInterface >> visPane: anObject [
	visPane := anObject
]
