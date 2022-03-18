Class {
	#name : #LRPComment,
	#superclass : #LRPContainedElement,
	#instVars : [
		'text'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPComment class >> text: aString [
	^ self new text: aString

]

{ #category : #visiting }
LRPComment >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitComment: self
]

{ #category : #printing }
LRPComment >> printOn: aStream [
	aStream nextPutAll: 'LRPComment : '.
	aStream nextPutAll: self text asString.
]

{ #category : #accessing }
LRPComment >> text [
	^ text
]

{ #category : #accessing }
LRPComment >> text: anObject [
	text := anObject
]
