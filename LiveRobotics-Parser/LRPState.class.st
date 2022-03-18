Class {
	#name : #LRPState,
	#superclass : #LRPContainedElement,
	#instVars : [
		'name',
		'body',
		'runningMachines',
		'startTime',
		'compareMachines'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPState class >> name: aString body: anArray [
	|retval|
	retval := self new.
	retval name: aString.
	retval body: anArray.
	^retval
]

{ #category : #visiting }
LRPState >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitStateNode: self.
	self body do:[:aNode| aNode acceptVisitor: aLRPNodeVisitor]
]

{ #category : #accessing }
LRPState >> body [
	^ body
]

{ #category : #accessing }
LRPState >> body: anObject [
	body := anObject.
	body do: [ :aBodyElement|
		(aBodyElement isKindOf: LRPContainedElement)
			ifTrue: [aBodyElement container: self] ].
]

{ #category : #'sugar-processing' }
LRPState >> deSugarIn: newBody with: variableCollection [
	newBody add: self.	
	self machines do: [ :machine|
		machine body
			select: [:node | node class = LRPNodePullUpContainer  ]
			thenDo: [ :puc | newBody add: (puc openIn: self) ].
		machine body:
			(machine body reject: [ :node | node class = LRPNodePullUpContainer])].

]

{ #category : #find }
LRPState >> findBestLRPNodeFor: anInteger [
	
	body ifEmpty: [ ^self ].
	^body findBestLRPNodeFor: anInteger.
]

{ #category : #accessing }
LRPState >> fullName [
	^self container fullName, '/', self name 
]

{ #category : #accessing }
LRPState >> machines [
	^self body select:[:item | item class = LRPMachine]
]

{ #category : #accessing }
LRPState >> name [
	^ name
]

{ #category : #accessing }
LRPState >> name: anObject [
	name := anObject
]

{ #category : #'error handing' }
LRPState >> onErrorNode: aBlock [ 

	^body do:[:aNode| aNode onErrorNode: aBlock ]
]

{ #category : #printing }
LRPState >> printOn: aStream [
	aStream nextPutAll: 'LRPState '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self body asString.
	
]
