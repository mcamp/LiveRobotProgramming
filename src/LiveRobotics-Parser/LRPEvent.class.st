Class {
	#name : #LRPEvent,
	#superclass : #LRPContainedElement,
	#instVars : [
		'name',
		'trigger',
		'triggerBlock'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPEvent class >> named: aString trigger: aBlock [
	|retval|
	retval := self new.
	retval name: aString.
	retval trigger: aBlock.
	^ retval
]

{ #category : #visiting }
LRPEvent >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitEventNode: self
]

{ #category : #testing }
LRPEvent >> acceptWatchpoint [
	^true
]

{ #category : #accessing }
LRPEvent >> block [ 
	^trigger
]

{ #category : #accessing }
LRPEvent >> name [
	^ name
]

{ #category : #accessing }
LRPEvent >> name: anObject [
	name := anObject
]

{ #category : #printing }
LRPEvent >> printOn: aStream [
	aStream nextPutAll: 'LRPEvent '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: self trigger asString.
	
]

{ #category : #accessing }
LRPEvent >> trigger [
	^ trigger
]

{ #category : #accessing }
LRPEvent >> trigger: anObject [
	trigger := anObject
]
