"
I take care of  comparison operations between a set of old and new AST nodes, and also optionally hold the root machine of this set of nodes. 
"
Class {
	#name : #LRPCompareNodes,
	#superclass : #Object,
	#instVars : [
		'oldNodes',
		'newNodes',
		'oldRootNode'
	],
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #'instance creation' }
LRPCompareNodes class >> old: oldNodes new: newNodes oldRoot: rootNode [
	| retval |
	retval := self new.
	retval old: oldNodes new: newNodes oldRoot: rootNode.
	^retval
	
]

{ #category : #comparison }
LRPCompareNodes >> added [
	oldNodes ifNil:[^newNodes].
	^newNodes minusWithWeakFunction: oldNodes .
]

{ #category : #accessing }
LRPCompareNodes >> firstNewNode [

	^newNodes first
	
]

{ #category : #accessing }
LRPCompareNodes >> getVariable: aString [

	^oldRootNode scope getVar: aString
]

{ #category : #testing }
LRPCompareNodes >> isVariableUnchanged: aVariable [
	"Was the variable defined previously and is the program text the same"
	"I should be holding variables for this to work"

	oldNodes isNotNil
		ifTrue: [|oldvar name|
			name := aVariable name.
			oldvar := oldNodes detect:[:var | var name = name ] ifNone: [^false].
			^(((oldvar wasInitialized) or: [ oldvar shouldNotInitialize])
				and: [aVariable sourceText = oldvar sourceText])]
		ifFalse: [ ^false ]
]

{ #category : #'initialize - release' }
LRPCompareNodes >> old: oldN new: newN oldRoot: rootNode [

	oldNodes := oldN.
	newNodes := newN.
	oldRootNode := rootNode.
]

{ #category : #accessing }
LRPCompareNodes >> oldRootTriggeredTransition [

	^ oldRootNode triggeredTransition 
]

{ #category : #propagate }
LRPCompareNodes >> propagateChanges [

	oldNodes ifNil:[^self].

	newNodes do:[:aNewNode|
		|oldNode|
		oldNode := (oldNodes detect: [:anOldNode | anOldNode name = aNewNode name] ifNone: [nil]).
		oldNode ifNotNil:[
				aNewNode prepareChangesWith: oldNode.
			]
	]
]

{ #category : #comparison }
LRPCompareNodes >> removed [

	oldNodes ifNil:[^#()].
	^oldNodes minusWithWeakFunction: newNodes .
]
