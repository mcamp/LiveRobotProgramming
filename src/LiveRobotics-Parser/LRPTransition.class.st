Class {
	#name : #LRPTransition,
	#superclass : #LRPContainedElement,
	#instVars : [
		'name',
		'from',
		'to',
		'eventname',
		'arrowRange',
		'keywordEnd'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPTransition class >> on: anEvent from: startState to: endState name: aString [
	|retval|
	retval := self new.
	retval eventname: anEvent.
	retval from: startState.
	retval to: endState.
	retval name: aString.
	^ retval.
]

{ #category : #visiting }
LRPTransition >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitTransitionNode: self.
]

{ #category : #'syntax highlighting' }
LRPTransition >> arrowIndex [
	^ 4
]

{ #category : #accessing }
LRPTransition >> arrowRange [
	^ arrowRange
]

{ #category : #accessing }
LRPTransition >> arrowRange: anObject [
	arrowRange := anObject
]

{ #category : #'syntax highlighting' }
LRPTransition >> arrowRangeFor: aTokenArray [
	| index |
	index := self arrowIndex.
	^ ((aTokenArray at: index ) stop + 1
						to: (aTokenArray at: index + 2) start -1)
]

{ #category : #accessing }
LRPTransition >> eventname [
	^ eventname
]

{ #category : #accessing }
LRPTransition >> eventname: anObject [
	eventname := anObject
]

{ #category : #accessing }
LRPTransition >> from [
	^ from
]

{ #category : #accessing }
LRPTransition >> from: anObject [
	from := anObject
]

{ #category : #accessing }
LRPTransition >> identifier [
	^self className , self from , self to , self name.
]

{ #category : #accessing }
LRPTransition >> keywordEnd [
	^ keywordEnd
]

{ #category : #accessing }
LRPTransition >> keywordEnd: anObject [
	keywordEnd := anObject
]

{ #category : #accessing }
LRPTransition >> name [
	^ name
]

{ #category : #accessing }
LRPTransition >> name: anObject [
	name := anObject
]

{ #category : #printing }
LRPTransition >> printOn: aStream [

	aStream nextPutAll: 'LRPTransition '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self from.
	aStream nextPutAll: '->'.
	aStream nextPutAll: self to.
	aStream nextPutAll: ' on '.
	aStream nextPutAll: self eventname.
	
]

{ #category : #'syntax highlighting' }
LRPTransition >> setRangesFor: aTokenArray [
	| ident index |
	index := self arrowIndex.
	ident := (aTokenArray at: index + 3).
	ident
		ifNil: [ self nameRange: (1 to: 1) ]
		ifNotNil: [ self nameRange: (ident start to: ident stop) ].
	self
		start: (aTokenArray first start) stop: (aTokenArray last stop) source: aTokenArray first collection;
		arrowRange: (self arrowRangeFor: aTokenArray);
		keywordEnd: (aTokenArray at: 3) start -1
]

{ #category : #accessing }
LRPTransition >> to [
	^ to
]

{ #category : #accessing }
LRPTransition >> to: anObject [
	to := anObject
]
