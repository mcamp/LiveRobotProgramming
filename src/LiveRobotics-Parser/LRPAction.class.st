Class {
	#name : #LRPAction,
	#superclass : #LRPContainedElement,
	#instVars : [
		'block',
		'textBlock',
		'interpretedBlock',
		'keywordEnd'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPAction class >> block: aBlock [
	|retval|
	retval := self new.
	retval block: aBlock.
	retval textBlock: aBlock copy. 
	^ retval
]

{ #category : #visiting }
LRPAction >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitActionNode: self.
]

{ #category : #testing }
LRPAction >> acceptWatchpoint [
	^true
]

{ #category : #accessing }
LRPAction >> block [
	^ block
]

{ #category : #accessing }
LRPAction >> block: anObject [
	block := anObject
]

{ #category : #accessing }
LRPAction >> keywordEnd [
	keywordEnd ifNil: [ self halt: 'Error in setting up range info for styling' ].
	^ keywordEnd
]

{ #category : #accessing }
LRPAction >> keywordEnd: anObject [
	keywordEnd := anObject
]

{ #category : #printing }
LRPAction >> printOn: aStream [

	aStream nextPutAll: self class name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self block asString.
]

{ #category : #accessing }
LRPAction >> textBlock [
	^ textBlock
]

{ #category : #accessing }
LRPAction >> textBlock: anObject [
	textBlock := anObject
]

{ #category : #accessing }
LRPAction >> wrapperNode [
	^block
]
