Class {
	#name : #LRPNode,
	#superclass : #Object,
	#instVars : [
		'start',
		'stop',
		'nameRange',
		'watchpoint',
		'sourceText',
		'synthetic'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #visiting }
LRPNode >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitAnyNode: self.
]

{ #category : #testing }
LRPNode >> acceptWatchpoint [

	^false
]

{ #category : #'sugar-processing' }
LRPNode >> deSugarIn: newBody with: variableCollection [
	newBody add: self.
]

{ #category : #find }
LRPNode >> findBestLRPNodeFor: anInteger [
	
	(self stringPositionContains: anInteger) 
		ifTrue: [^self ]
		ifFalse: [ ^nil ]

]

{ #category : #'gt-inspector-extension' }
LRPNode >> gtInspectorDetailsIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite text
		title: 'Source Code';
		display: self sourceText.
]

{ #category : #testing }
LRPNode >> hasWatchpoint [
	^watchpoint isNotNil.
]

{ #category : #testing }
LRPNode >> isError [

	^false.
]

{ #category : #accessing }
LRPNode >> nameRange [
	nameRange ifNil: [self halt: 'Error in setting up range info for styling.' ].
	^ nameRange
]

{ #category : #accessing }
LRPNode >> nameRange: anObject [
	nameRange := anObject
]

{ #category : #'error handing' }
LRPNode >> onErrorNode: aBlock [ 
	"do nothing"
]

{ #category : #accessing }
LRPNode >> sourceText [
	^ sourceText
]

{ #category : #accessing }
LRPNode >> start [
	^ start
]

{ #category : #accessing }
LRPNode >> start: anObject [
	start := anObject
]

{ #category : #accessing }
LRPNode >> start: aNumber stop: anotherNumber source: aString [
	
	start := aNumber.
	stop := anotherNumber.
	sourceText := aString copyFrom: aNumber to: anotherNumber. 

]

{ #category : #accessing }
LRPNode >> stop [
	^ stop
]

{ #category : #accessing }
LRPNode >> stop: anObject [
	stop := anObject
]

{ #category : #testing }
LRPNode >> stringPositionContains: anInteger [
	
	^(self start to: self stop) anySatisfy: [:index| index = anInteger]
]

{ #category : #accessing }
LRPNode >> synthetic [
	synthetic isNil ifTrue: [synthetic := false].
	^ synthetic
]

{ #category : #accessing }
LRPNode >> synthetic: anObject [
	synthetic := anObject
]

{ #category : #accessing }
LRPNode >> watchpoint [
	^ watchpoint
]

{ #category : #accessing }
LRPNode >> watchpoint: anObject [
	watchpoint := anObject
]
