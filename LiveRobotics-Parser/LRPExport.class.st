Class {
	#name : #LRPExport,
	#superclass : #LRPContainedElement,
	#instVars : [
		'name'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPExport class >> withName: aString [
	| inst |
	inst := self new.
	inst name: aString.
	^inst
]

{ #category : #visiting }
LRPExport >> acceptVisitor: aLRPNodeVisitor [
	^aLRPNodeVisitor visitExportNode: self
]

{ #category : #accessing }
LRPExport >> name [
	^ name
]

{ #category : #accessing }
LRPExport >> name: anObject [
	name := anObject
]

{ #category : #printing }
LRPExport >> printOn: aStream [
	aStream nextPutAll: 'LRPExport : '.
	aStream nextPutAll: self name asString.
]
