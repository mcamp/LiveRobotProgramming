Class {
	#name : #LRPMachine,
	#superclass : #LRPContainedElement,
	#instVars : [
		'initState',
		'name',
		'body',
		'currentState',
		'scope',
		'triggeredTransition',
		'compareStates',
		'compareTransitions',
		'compareVariables'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPMachine class >> name: aString body: anArray [
	|retval|
	retval := self new.
	retval name: aString.
	retval body: anArray.
	^retval
]

{ #category : #visiting }
LRPMachine >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitMachineNode: self.
	self body do:[:aNode| aNode acceptVisitor: aLRPNodeVisitor]
]

{ #category : #accessing }
LRPMachine >> allEvents [
		^self body select:[:item | item isKindOf: LRPEvent]
]

{ #category : #accessing }
LRPMachine >> allStates [
	^self body select:[:item | item isKindOf: LRPState]
]

{ #category : #accessing }
LRPMachine >> allTransitions [
	^self body select:[:item | item isKindOf: LRPTransition]
]

{ #category : #accessing }
LRPMachine >> allVariables [
	^self body select:[:item | item isKindOf: LRPVariable]
]

{ #category : #accessing }
LRPMachine >> body [
	^ body
]

{ #category : #accessing }
LRPMachine >> body: anObject [
	body := anObject.
	body do: [ :aBodyElement| aBodyElement container: self ].
]

{ #category : #accessing }
LRPMachine >> containerMachine [
	self container isNil
		ifTrue: [ ^nil ]
		ifFalse: [ ^self container container ]
]

{ #category : #accessing }
LRPMachine >> eps [
	^self body select:[:item | item isMemberOf: LRPEpsilonTransition]
]

{ #category : #accessing }
LRPMachine >> events [
	^self body select:[:item | item class = LRPEvent]
]

{ #category : #find }
LRPMachine >> findBestLRPNodeFor: anInteger [
	
	body ifEmpty: [ ^self ].
	^(body findBestLRPNodeFor: anInteger)
		ifNil: [self]
		ifNotNil: [:aNode| ^aNode].
]

{ #category : #accessing }
LRPMachine >> machines [
	^self body select:[:item | item class = LRPMachine]
]

{ #category : #accessing }
LRPMachine >> name [
	^ name
]

{ #category : #accessing }
LRPMachine >> name: anObject [
	name := anObject
]

{ #category : #'error handing' }
LRPMachine >> onErrorNode: aBlock [

	^body do: [ :aNode| aNode onErrorNode: aBlock]
]

{ #category : #accessing }
LRPMachine >> ontime [
	^self body select:[:item | item isMemberOf: LRPTimeoutTransition]
]

{ #category : #accessing }
LRPMachine >> outerScope [ 
	^self scope.
]

{ #category : #printing }
LRPMachine >> printOn: aStream [
	aStream nextPutAll: 'LRPMachine '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' :\(\' withCRs .
	self body do: [ :elt | elt printOn: aStream ] separatedBy: [ aStream nextPut: Character cr ].
	aStream nextPutAll: self body asString.
	aStream nextPutAll: '\)\' withCRs .

	
]

{ #category : #accessing }
LRPMachine >> states [
	^self body select:[:item | item class = LRPState]
]

{ #category : #accessing }
LRPMachine >> transitions [
	^self body select:[:item | item isMemberOf: LRPTransition]
]

{ #category : #accessing }
LRPMachine >> variables [
	^self body select:[:item | item class = LRPVariable]
]

{ #category : #accessing }
LRPMachine >> varsAndParentVars [
	"returns all variables"
	|recblock |
	recblock := [  ].
	recblock := [ :aMachine| |variables|
		aMachine ifNil:[
			OrderedCollection new.	
		] ifNotNil: [
			variables := recblock value: aMachine containerMachine.
			variables addAll: aMachine variables.
			variables
		]
	].

	^recblock value: self.
	

]

{ #category : #accessing }
LRPMachine >> wildtrans [
	^self body select:[:item | item class = LRPWildcardTransition]
]
