"
I hold the previous and current AST of the code, as well as the LRPCompareNodes that represents their difference.
"
Class {
	#name : #LRPCompare,
	#superclass : #Object,
	#instVars : [
		'oldAST',
		'newAST',
		'compareMachines'
	],
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #comparison }
LRPCompare >> addedMachines [

	^compareMachines added.
]

{ #category : #initialization }
LRPCompare >> clear [

	oldAST := nil.
	newAST := nil.
	compareMachines := LRPCompareNodes new.

]

{ #category : #comparison }
LRPCompare >> firstNewMachine [

	^compareMachines firstNewNode
]

{ #category : #initialization }
LRPCompare >> initialize [

	super initialize.
	self clear.

]

{ #category : #comparison }
LRPCompare >> isFirstProgram [
	^oldAST isNil
]

{ #category : #accessing }
LRPCompare >> newAST [
	^ newAST
]

{ #category : #accessing }
LRPCompare >> newAST: new [
	"save previous new AST as old AST, set new AST, propagate the changes"
	| oldN newN |
	
	oldAST := newAST.
	newAST := new.

	newN := new
		ifNil: [ nil ]
		ifNotNil:[(newAST select:[:item| item class = LRPMachine])].

	oldN := oldAST
		ifNil: [ nil ]
		ifNotNil:[(oldAST select:[:item| item class = LRPMachine])].

	compareMachines := LRPCompareNodes old: oldN new: newN oldRoot: nil.
	compareMachines propagateChanges.
]

{ #category : #comparison }
LRPCompare >> oldVariables [
	^oldAST select: [ :node | node class = LRPVariable]
]

{ #category : #comparison }
LRPCompare >> removedMachines [

	^compareMachines removed
]
