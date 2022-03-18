Class {
	#name : #LRPAbstractBridge,
	#superclass : #Object,
	#instVars : [
		'generatedVars',
		'codeGenerator',
		'ui'
	],
	#classVars : [
		'uniqueInstance'
	],
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #cleanup }
LRPAbstractBridge class >> cleanUp [

	uniqueInstance ifNotNil: [uniqueInstance cleanUp].
	uniqueInstance := nil.
]

{ #category : #'instance creation' }
LRPAbstractBridge class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'variable generation' }
LRPAbstractBridge >> addIVar: aVarName [ 

	codeGenerator addIVar: aVarName to: generatedVars class withAccesors: true.
]

{ #category : #'method generation' }
LRPAbstractBridge >> addMethod: aMethodName source: aSourceCode [

	|sourceCode|
	
	sourceCode := aMethodName, String cr, aSourceCode.
	generatedVars class compile: sourceCode classified: 'generated - ', self class asString.
	
]

{ #category : #initialization }
LRPAbstractBridge >> cleanUp [

	generatedVars class removeFromSystem.
	self closeUI.
]

{ #category : #'variable generation' }
LRPAbstractBridge >> cleanVariableClass [
	
	generatedVars removeFromSystem.
]

{ #category : #api }
LRPAbstractBridge >> closeUI [
	ui ifNotNil: [ ui delete ].
]

{ #category : #'variable generation' }
LRPAbstractBridge >> generateBridgeVariable [
	
	self addIVar: '__lrpBridge'.
	generatedVars perform: '__lrpBridge:' asSymbol with: self.
]

{ #category : #'variable generation' }
LRPAbstractBridge >> generateVariableClass [
	
	SystemAnnouncer uniqueInstance suspendAllWhile: [
		generatedVars := 
			(Object subclass: (self class asString, '_GeneratedVars') asSymbol
				instanceVariableNames: ''
				classVariableNames: ''
				category: 'LiveRobotics-InterpreterGenerated') new].
]

{ #category : #testing }
LRPAbstractBridge >> hasIVar: aVarName [

	^codeGenerator hasIVar: aVarName on: generatedVars class
]

{ #category : #initialization }
LRPAbstractBridge >> initialize [

	super initialize.
	codeGenerator := LRPCodeGenerator new.
	self generateVariableClass.
	self generateBridgeVariable.
]

{ #category : #initialization }
LRPAbstractBridge >> openInterfaceFor: anInterpreter [
	ui := self openUIFor: anInterpreter.
]

{ #category : #api }
LRPAbstractBridge >> openUIFor: anInterpreter [
	"Subclasses should implement this reasonably"
	"Return the object that should receive a delete message when closed,
	or nil for none"
	^nil
]

{ #category : #'variable generation' }
LRPAbstractBridge >> removeIVar: aVarName [ 

	codeGenerator removeIVar: aVarName from: generatedVars class withAccesors: true.
]

{ #category : #'method generation' }
LRPAbstractBridge >> removeMethod: aSelector [

	
	generatedVars class removeSelector: aSelector
	
]

{ #category : #'variable generation' }
LRPAbstractBridge >> setIVar: aVarName with: anObject [

	generatedVars perform: (aVarName,':')asSymbol with: anObject.
]

{ #category : #api }
LRPAbstractBridge >> setVariablesInScope: aScope [

	aScope setVariable: #robot withValue: self vars.
]

{ #category : #accessing }
LRPAbstractBridge >> vars [
	
	^ generatedVars.
]
