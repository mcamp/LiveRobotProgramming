"
A LRPSlotVarScope is an implementation of the LRP variable scope environment that relies on slots to do notification of variable changes.

"
Class {
	#name : #LRPSlotVarScope,
	#superclass : #Object,
	#instVars : [
		'machines',
		'states',
		'vars',
		'events',
		'transitions',
		'staticVars',
		'codeGenerator',
		'blocks',
		'rootAST'
	],
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #'instance creation' }
LRPSlotVarScope class >> rootFor: anInterpreter withCode: anArray [
	| inst cls |
	inst := self new.
	
	cls := LRPCodeGenerator generateNamedClass: 'RootMachine' withCode: anArray.
	cls observers add: anInterpreter.
	inst vars: cls.
	inst rootAST: anArray.
	^inst.
	
]

{ #category : #adding }
LRPSlotVarScope >> addEvent: anEvent [
	
	self events at: anEvent name put: anEvent.
]

{ #category : #adding }
LRPSlotVarScope >> addMachine: aMachine [
	
	self machines at: aMachine name put: aMachine
]

{ #category : #adding }
LRPSlotVarScope >> addState: aState [
	
	self states at: aState name put: aState
]

{ #category : #adding }
LRPSlotVarScope >> addTransition: aTransition [
	
	self transitions at: aTransition name put: aTransition
]

{ #category : #adding }
LRPSlotVarScope >> addVariable: aVariable with: anInitializer [
	| cls sym |
	"the variable already exists in the scope class,
	this needs to be initialized later with initializeVariable:"
	cls := self vars.
	sym := aVariable name asSymbol.

	cls writeClassVariableNamed: sym value: anInitializer.
]

{ #category : #accessing }
LRPSlotVarScope >> allVariables [
	"Return associations name -> value"
	| retval recurse |
	retval := OrderedCollection new.

	"This is a recursive lambda."
	recurse := nil.
	recurse := [:scopeclass |
		(scopeclass = Object) ifFalse: [
			retval addAll: (scopeclass classVariables reject: [:var |
					(var key = #lrp_observers_collection) or: [var key = #robot]]).
			recurse value: scopeclass superclass.
			]].
	recurse value: self vars.
	
	^ retval.
]

{ #category : #accessing }
LRPSlotVarScope >> blocks [
	^ blocks
]

{ #category : #children }
LRPSlotVarScope >> childScopeFor: aMachine [
	| retval cls |
	
	retval := self copy.
	
	cls := LRPCodeGenerator generateClassFor: aMachine withSuper: self vars.
	retval vars: cls.
	^retval.
]

{ #category : #'initialize-release' }
LRPSlotVarScope >> cleanUp [
	self vars ifNotNil: [ :v | self removeVarClass: v ]
]

{ #category : #testing }
LRPSlotVarScope >> containsVariable: aVariable [
	^ self vars usesClassVarNamed: aVariable
]

{ #category : #accessing }
LRPSlotVarScope >> events [
	^ events
]

{ #category : #'initialize-release' }
LRPSlotVarScope >> finalize [
	self cleanUp
]

{ #category : #accessing }
LRPSlotVarScope >> getVar: aString [

	^self
		getVariable: aString asSymbol
		fromScopeClass: self vars
		ifAbsent: [LRPErrorHandler instance varNotFound: aString. nil]



]

{ #category : #accessing }
LRPSlotVarScope >> getVariable: sym fromScopeClass: cls ifAbsent: aBlock [

	(cls hasClassVarNamed: sym) 
		ifTrue: [^ cls readClassVariableNamed: sym ]
		ifFalse: [|supercls|
			supercls := cls superclass.
			supercls = Object
				ifTrue: [^ aBlock value]
				ifFalse:[^ self getVariable: sym fromScopeClass: supercls ifAbsent: aBlock]]


]

{ #category : #'gt-inspector-extension' }
LRPSlotVarScope >> gtInspectorDetailsIn: composite [
	<gtInspectorPresentationOrder: 0>

	composite table
		title: 'Details';
		display: [ self allVariables ];
		column: 'Variable' evaluated: #key;
		column: 'Value' evaluated: #value modified: [:text :assoc || val |
			"Treat this as a special case, otherwise can never set a variable to nil."
			text = 'nil'
				ifTrue: [ val := nil ]
				ifFalse: [
					val := [OpalCompiler evaluate: text] ifError: [ text ].
					"Returns nil on syntax error"
					val ifNil: [ val := text ]].
			self setVariable: assoc key withValue: val.];
		send: #value 
]

{ #category : #testing }
LRPSlotVarScope >> inheritsVariable: aVariable [
	"checks if the superclass has the variable"
	^ self vars superclass usesClassVarNamed: aVariable
]

{ #category : #'initialize-release' }
LRPSlotVarScope >> initialize [

	states := Dictionary new.
	machines := Dictionary new.
	transitions := Dictionary new.
	events := Dictionary new.
	codeGenerator := LRPCodeGenerator new.
	blocks := Dictionary new.
	
	"for finalize to be called when I am garbage collected"
	WeakRegistry default add: self.
]

{ #category : #interpretation }
LRPSlotVarScope >> initializeVariable: aVariable [
	| sym cls init val|
	sym := aVariable name asSymbol.
	cls := self vars.

	init := (cls readClassVariableNamed: sym).
	
	aVariable shouldInitialize
					ifTrue: [
						aVariable willInitialize.
						val := init value.
						val = cls ifTrue: [val := nil]]
					ifFalse: [ val := init ].
	
	cls writeClassVariableNamed: sym value: val.

]

{ #category : #interpretation }
LRPSlotVarScope >> interpretBlock: aBlock withInterpreter: aLRPInterpreter [

	^self blocks
		at: aBlock
		ifAbsentPut: [ codeGenerator compileBlock: aBlock forScope: self vars ].
]

{ #category : #accessing }
LRPSlotVarScope >> machines [
	^ machines
]

{ #category : #adding }
LRPSlotVarScope >> newVariable: aVariable withValue: aValue [
	"Only ment to be used by the bridge when adding variables to the root scope"
	| cls sym |
	cls := self vars.
	sym := aVariable asSymbol.

	LRPCodeGenerator addCVar: sym to: cls.
	cls writeClassVariableNamed: sym value: aValue.
]

{ #category : #copying }
LRPSlotVarScope >> postCopy [

	machines := machines copy.
	states := states copy.
	events := events copy.
	transitions := transitions copy.
]

{ #category : #'initialize-release' }
LRPSlotVarScope >> removeVarClass: aVarClass [
	"first remove the subclasses, recursively"
	
	SystemAnnouncer uniqueInstance 
		suspendAllWhile:[
				aVarClass subclasses do: [:sub| self removeVarClass: sub].
				aVarClass removeFromSystem.]

]

{ #category : #accessing }
LRPSlotVarScope >> rootAST [
	^ rootAST
]

{ #category : #accessing }
LRPSlotVarScope >> rootAST: anObject [
	rootAST := anObject
]

{ #category : #accessing }
LRPSlotVarScope >> setVariable: sym fromScopeClass: cls withValue: aValue [
	
	(cls hasClassVarNamed: sym) 
		ifTrue: [ cls writeClassVariableNamed: sym value: aValue]
		ifFalse: [|supercls|
			supercls := cls superclass.
			supercls = Object
				ifTrue: [^ self error: 'Trying to write a variable that does not exist']
				ifFalse:[^ self setVariable: sym fromScopeClass: supercls withValue: aValue]]

]

{ #category : #accessing }
LRPSlotVarScope >> setVariable: varkey withValue: aValue [
	| cls sym |
	sym := varkey asSymbol.
	cls := self vars.
	
	^self setVariable: sym fromScopeClass: cls withValue: aValue.
]

{ #category : #accessing }
LRPSlotVarScope >> states [
	^ states
]

{ #category : #accessing }
LRPSlotVarScope >> transitions [
	^ transitions
]

{ #category : #accessing }
LRPSlotVarScope >> vars [
	^ vars
]

{ #category : #accessing }
LRPSlotVarScope >> vars: anObject [
	vars := anObject
]
