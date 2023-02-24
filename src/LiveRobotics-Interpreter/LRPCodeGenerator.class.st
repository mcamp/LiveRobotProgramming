"
I am responsible for managing the code of the class hierarchy that is the scope of LRP variables 
"
Class {
	#name : #LRPCodeGenerator,
	#superclass : #Object,
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #classes }
LRPCodeGenerator class >> addCVar: aName to: aClass [

	aClass addClassVariable: (aName asSymbol => LRPNotifyingClassVar).

]

{ #category : #classes }
LRPCodeGenerator class >> generateClassFor: aMachine withSuper: aClass [
	| classname vars  |

	classname := String streamContents: [ :str|
		str nextPutAll: 'LRPGC'.
		str nextPutAll: aMachine fullName.
		str nextPutAll: '_'.
		str nextPutAll: Date today ddmmyyyy asString.
		str nextPutAll: '_'.
		str nextPutAll: Time now asMilliSeconds asString].
	classname := classname copyReplaceAll: '/' with: '_'.
	
	vars := self makeVarArrayFor: aMachine variables inClass: aClass. 

	^SystemAnnouncer uniqueInstance 
		suspendAllWhile: [
			aClass subclass: classname asSymbol
			slots: {}
			classVariables: vars
			package: 'LiveRobotics-InterpreterGenerated']


]

{ #category : #classes }
LRPCodeGenerator class >> generateNamedClass: aName withCode: anArray [
	| classname generated vars |
	"This is supposed to be the root class of the scope hierarchy,
	so it will include an observers collection"

	classname := String streamContents: [ :str|
		str nextPutAll: 'LRPGC'.
		str nextPutAll: aName.
		str nextPutAll: '_'.
		str nextPutAll: Date today ddmmyyyy asString.
		str nextPutAll: '_'.
		str nextPutAll: Time now asMilliSeconds asString].
	classname := classname copyReplaceAll: '/' with: '_'.
	
	vars := self makeVarArrayFor:(anArray select: [ :stat| stat class = LRPVariable])
					inClass: Object. 
	
	vars add: #lrp_observers_collection => ClassVariable.
	vars add: #robot => ClassVariable.
	
	SystemAnnouncer uniqueInstance suspendAllWhile: [
			generated := Object subclass: classname asSymbol
						slots: { }
						classVariables: vars
						package: 'LiveRobotics-InterpreterGenerated'].
	generated class compileSilently:
	'observers
		lrp_observers_collection ifNil:[lrp_observers_collection := OrderedCollection new.].
		^lrp_observers_collection'.
	
	^generated


]

{ #category : #classes }
LRPCodeGenerator class >> makeVarArrayFor: lrpVariables inClass: aClass [
	| vars |
	vars := OrderedCollection new.
	lrpVariables do: [ :mvar | |varname|
		varname := (mvar name asSymbol).
		(aClass usesClassVarNamed: varname)
			ifTrue: [ LRPErrorHandler instance duplicateVar: varname  ]
			ifFalse: [vars add: varname => LRPNotifyingClassVar]].
	^ vars
]

{ #category : #classes }
LRPCodeGenerator class >> removeAllClasses [
	SystemAnnouncer uniqueInstance 
		suspendAllWhile:[
			(Smalltalk organization classesInCategory: #'LiveRobotics-InterpreterGenerated')
				"Don't log removal"
				do: [: cls | cls removeFromSystem: false ]]
]

{ #category : #classes }
LRPCodeGenerator class >> removeCVar: aName from: aClass [

	aClass removeClassVarNamed: aName asSymbol.
]

{ #category : #classes }
LRPCodeGenerator >> addIVar: aName to: aClass withAccesors: aBoolean [
	
	aClass addInstVarNamed: aName asSymbol.
	aBoolean ifTrue: [
		(RBCreateAccessorsForVariableRefactoring
			variable: aName
			class: aClass
			classVariable: false) execute.
		]
]

{ #category : #blocks }
LRPCodeGenerator >> compileBlock: aBlockNode forScope: aMachineScope [
	"the block is added as a generated method of the class of the scope"
	| cls selector methstr codeNode|
	
	cls := aMachineScope class.
	selector := String streamContents: [ :str|
		str nextPutAll: 'blockGen/'.
		str nextPutAll: Date today ddmmyyyy asString.
		str nextPutAll: '/'.
		str nextPutAll: Time now asMilliSeconds asString].
	selector := selector copyReplaceAll: '/' with: '_'.
	
	"added return value to the block node"
	codeNode := aBlockNode body.
	codeNode addReturn.
	
	methstr := String streamContents:[ :str |
		str nextPutAll: selector.
		str nextPut: Character cr.
		str nextPutAll: codeNode formattedCode.].
	
	cls compileSilently: methstr.
	^LRPMethodWrapper instance: aMachineScope selector: selector asSymbol.
]

{ #category : #testing }
LRPCodeGenerator >> hasIVar: aName on: aClass [ 
	
	^aClass instanceVariables anySatisfy: [ :varName| varName = aName ]

]

{ #category : #classes }
LRPCodeGenerator >> removeIVar: aName from: aClass withAccesors: aBoolean [

	aClass removeInstVarNamed: aName.
	aBoolean ifTrue: [ 
		"this used to be removeSelectorSilently: but then the RPackage was not updated
		-> Monticello crash when gathering changes"
		aClass removeSelector: aName asSymbol.
		aClass removeSelector: (aName,':') asSymbol. ]
]
