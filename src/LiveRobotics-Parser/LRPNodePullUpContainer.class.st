"
I am a container for a LRP Node that should be pulled from a nested machine into its parent when desugaring syntax.
"
Class {
	#name : #LRPNodePullUpContainer,
	#superclass : #Object,
	#instVars : [
		'node',
		'container',
		'processor'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPNodePullUpContainer class >> on: aLRPNode [
	| inst |
	inst := self new.
	aLRPNode synthetic: true.
	inst node: aLRPNode.
	^ inst.
]

{ #category : #visiting }
LRPNodePullUpContainer >> acceptVisitor: aLRPNodeVisitor [
	^self
]

{ #category : #accessing }
LRPNodePullUpContainer >> container: aLRPMachine [ 
	container := aLRPMachine
]

{ #category : #'sugar-processing' }
LRPNodePullUpContainer >> deSugarIn: aBodyCollection with: vars [ 
	aBodyCollection add: self.
]

{ #category : #accessing }
LRPNodePullUpContainer >> node [
	^ node
]

{ #category : #accessing }
LRPNodePullUpContainer >> node: anObject [
	node := anObject
]

{ #category : #'sugar-processing' }
LRPNodePullUpContainer >> openIn: aNode [
	"this node is asking me to reveal my contents,
	which may need some processing"
	^processor isNil
		ifTrue: [ self node ]
		ifFalse: [ processor value: self node value: aNode ]

]

{ #category : #accessing }
LRPNodePullUpContainer >> processor [
	^ processor
]

{ #category : #accessing }
LRPNodePullUpContainer >> processor: anObject [
	processor := anObject
]
