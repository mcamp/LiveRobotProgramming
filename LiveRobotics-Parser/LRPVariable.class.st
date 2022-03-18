Class {
	#name : #LRPVariable,
	#superclass : #LRPContainedElement,
	#instVars : [
		'name',
		'value',
		'init'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #installation }
LRPVariable class >> name: aString value: aValue [
	|retval|
	retval := self new.
	retval name: aString.
	retval value: aValue.
	^retval
]

{ #category : #visiting }
LRPVariable >> acceptVisitor: aLRPNodeVisitor [
	"visitVariableNode is implemented by refactoring browser visitors and may cause problems"
	aLRPNodeVisitor visitLRPVariableNode: self
]

{ #category : #testing }
LRPVariable >> acceptWatchpoint [
	^true
]

{ #category : #accessing }
LRPVariable >> block [
	^value
]

{ #category : #'sugar-processing' }
LRPVariable >> deSugarIn: newBody with: vars [
	"Not really sugar expansion but checking of duplicte vars"
	(vars anySatisfy: [ :var | var name = self name ])
		ifTrue: [ LRPErrorHandler instance duplicateVar: self name  ]
		ifFalse: [ newBody add: self. vars add: self. ].
]

{ #category : #find }
LRPVariable >> findBestLRPNodeFor: anInteger [
	^self
]

{ #category : #accessing }
LRPVariable >> name [
	^ name
]

{ #category : #accessing }
LRPVariable >> name: anObject [
	name := anObject
]

{ #category : #printing }
LRPVariable >> printOn: aStream [
	aStream nextPutAll: 'LRPVariable '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self value asString.
	
]

{ #category : #accessing }
LRPVariable >> value [
	^ value
]

{ #category : #accessing }
LRPVariable >> value: anObject [
	value := anObject
]
