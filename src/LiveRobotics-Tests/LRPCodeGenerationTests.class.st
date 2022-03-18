Class {
	#name : #LRPCodeGenerationTests,
	#superclass : #TestCase,
	#instVars : [
		'mocksub'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #running }
LRPCodeGenerationTests >> setUp [
	| classname |
	classname := String streamContents: [ :str|
		str nextPutAll: 'LRPMockTestClass'.
		str nextPutAll: '_'.
		str nextPutAll: Date today ddmmyyyy asString.
		str nextPutAll: '_'.
		str nextPutAll: Time now asMilliSeconds asString].
	classname := classname copyReplaceAll: '/' with: '_'.

	SystemAnnouncer uniqueInstance 
		suspendAllWhile: [
			mocksub := 
				LRPTestMock subclass: classname asSymbol
					instanceVariableNames: ''
					classVariableNames: ''
					package: 'LiveRobotics-InterpreterGenerated'].
]

{ #category : #running }
LRPCodeGenerationTests >> tearDown [
	mocksub removeFromSystemUnlogged  

]

{ #category : #'managing classes' }
LRPCodeGenerationTests >> testAddRemoveClassvars [

	self deny:( mocksub hasClassVarNamed: #foo).
	LRPCodeGenerator addCVar: #foo to: mocksub.
	self assert: (mocksub hasClassVarNamed: #foo).
	mocksub writeClassVariableNamed: #foo value: 42.
	self assert: (mocksub readClassVariableNamed: #foo) = 42.
	
	LRPCodeGenerator removeCVar: #foo from: mocksub.
	self deny:( mocksub hasClassVarNamed: #foo).
]

{ #category : #'managing classes' }
LRPCodeGenerationTests >> testAddRemoveInstvars [
	| gen inst |
	
	gen := LRPCodeGenerator new.
	inst := mocksub new.
	
	self deny: (mocksub canPerform: #foo).
	self deny: (mocksub hasInstVarNamed: #foo).
	gen addIVar: #foo to: mocksub withAccesors: true.
	self assert: inst foo = nil.
	inst foo:42.
	self assert: inst foo = 42.
	
	gen removeIVar: #foo from: mocksub withAccesors: true.
	self deny: (mocksub canPerform: #foo).
	self deny: (mocksub hasInstVarNamed: #foo).
]

{ #category : #'block compilation' }
LRPCodeGenerationTests >> testBlockCompilationWithVarAccess [
	| gen res1 res2 inst foo|
	gen := LRPCodeGenerator new.
	gen addIVar: #foo to: mocksub withAccesors: true.
	inst := mocksub new.
	res1 := gen compileBlock: [foo] sourceNode forScope: inst.
	res2 := gen compileBlock: [foo:= 42] sourceNode forScope: inst.

	self assert: inst foo isNil.
	self assert: res1 value isNil.
	res2 value.
	self assert: res1 value = 42.
	self assert: inst foo = 42.
]

{ #category : #'managing classes' }
LRPCodeGenerationTests >> testCleanupClasses [
	Object subclass: #LRPGCTestClass
		instanceVariableNames: ''
		classVariableNames: ''
		category: 'LiveRobotics-InterpreterGenerated'.
	"sanity check"
	self assert:
		(Smalltalk organization classesInCategory: #'LiveRobotics-InterpreterGenerated') size > 0. 	
			
	LRPCodeGenerator removeAllClasses.
	self assert:
		(Smalltalk organization classesInCategory: #'LiveRobotics-InterpreterGenerated') size = 0 
]

{ #category : #'managing classes' }
LRPCodeGenerationTests >> testGenerateAClass [
	| cls machines vars|
	
	machines := LRPParser compiledParser parse:'(machine m (var a := [1]) (var b := [2]))'.
	
	cls := LRPCodeGenerator generateClassFor: (machines at:1) withSuper: Object.

	self assert: cls notNil.
	self assert: cls superclass = Object.
	vars := cls classVariables.
	self assert: vars size = 2.
	self assert: (vars at: 1) key = #a.
	self assert: (vars at: 2) key = #b.
	cls removeFromSystem.

]

{ #category : #'block compilation' }
LRPCodeGenerationTests >> testSimpleBlockCompilation [
	| gen res |
	gen := LRPCodeGenerator new.
	
	res := gen compileBlock: [42] sourceNode forScope: mocksub new.
	self assert: res value = 42.
]
