Class {
	#name : #LRPImport,
	#superclass : #LRPContainedElement,
	#instVars : [
		'filename'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPImport class >> filename: aString [
	| inst |
	inst := self new.
	inst filename: aString.
	^inst
]

{ #category : #visiting }
LRPImport >> acceptVisitor: aLRPNodeVisitor [
	^aLRPNodeVisitor visitImportNode: self
]

{ #category : #accessing }
LRPImport >> filename [
	^ filename
]

{ #category : #accessing }
LRPImport >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
LRPImport >> fullpath [
	^LRPInterpreter lrpRootPath asFileReference resolve: (filename copyFrom: 2 to: (filename size -1))
]

{ #category : #printing }
LRPImport >> printOn: aStream [
	aStream nextPutAll: 'LRPImport : '.
	aStream nextPutAll: self filename asString.
]
