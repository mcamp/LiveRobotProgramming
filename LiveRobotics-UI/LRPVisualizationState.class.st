"
A LRPVisualizationState is responsible for keeping  and operating on the relevant state of a LRPProgramVisualization
"
Class {
	#name : #LRPVisualizationState,
	#superclass : #Object,
	#instVars : [
		'view',
		'layout',
		'highnode',
		'highedge',
		'edges',
		'missingtrans',
		'oldPositions',
		'rand'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #operations }
LRPVisualizationState >> edgeFromName: aName [
	"if edges is nil we have not built the viz yet 
	but the interpreter is already running. So ignore highlights for now"
	edges ifNil: [ ^nil ].
	^edges
		detect: [:edgeassoc | edgeassoc key name = aName]
		ifNone: [nil].
]

{ #category : #accessing }
LRPVisualizationState >> edges [
	^edges
]

{ #category : #accessing }
LRPVisualizationState >> edges: anObject [
	edges := anObject
]

{ #category : #operations }
LRPVisualizationState >> forEdge: aName do: aBlock [
	|edge|
	edge := self edgeFromName: aName.
	edge isNil ifFalse: [ aBlock value: edge . edge value update].

]

{ #category : #operations }
LRPVisualizationState >> forNode: aName do: aBlock [
	|node|
	node := view elementFromModel: aName.
	node isNil ifFalse: [ aBlock value: node . view signalUpdate].

]

{ #category : #operations }
LRPVisualizationState >> freeze [

	view ifNotNil: [
		view canvas removeAnimation: self layout. 
		RTActiveAnimation new inView: view ]
]

{ #category : #accessing }
LRPVisualizationState >> highNodeName [
	^self highnode
		ifNil: ['']
		ifNotNil: [:node | node model].
]

{ #category : #accessing }
LRPVisualizationState >> highnode [
	^ highnode
]

{ #category : #accessing }
LRPVisualizationState >> highnode: anObject [
	highnode := anObject
]

{ #category : #initialization }
LRPVisualizationState >> initialize [
	super initialize.
	oldPositions := Dictionary new.
	rand := Random seed: Time now seconds. 
]

{ #category : #accessing }
LRPVisualizationState >> layout [
	^ layout
]

{ #category : #accessing }
LRPVisualizationState >> layout: anObject [
	layout := anObject
]

{ #category : #accessing }
LRPVisualizationState >> missingtrans [
	"initialized when a niew view is set"
	^ missingtrans
]

{ #category : #accessing }
LRPVisualizationState >> missingtrans: anObject [
	missingtrans := anObject
]

{ #category : #accessing }
LRPVisualizationState >> newView: aRTView [
	view := aRTView.
	missingtrans := OrderedCollection new.
]

{ #category : #operations }
LRPVisualizationState >> recordPositionsAs: aMachineName [
	"record element positions such that they can be restored when this machine is viewed again"
	| posDict |
	
	"Check if we are not visualizing anything"
	view isNil ifTrue: [^self].
	
	posDict := Dictionary new.
	view elements do: [ :elt | posDict at: elt model put: elt position ].
	oldPositions at: aMachineName put: posDict.
	
]

{ #category : #operations }
LRPVisualizationState >> resetHighEdgeTo: aName withBlock: aBlock [
	highedge isNil ifFalse:
		[ aBlock value: highedge. highedge value update.].
	highedge := self edgeFromName: aName.
]

{ #category : #operations }
LRPVisualizationState >> resetHighNodeTo: aName withBlock: aBlock [
	highnode isNil ifFalse: [ aBlock value: highnode. highnode update. ].
	highnode := view elementFromModel: aName.
]

{ #category : #operations }
LRPVisualizationState >> setPositionsFor: aMachineName [
	"Either set previously saved positions, or randomize initial positions"
	
	oldPositions
		at: aMachineName
		ifPresent: [:posDict | view elements do: [ :elt| | pos |
				pos := posDict at: elt model ifAbsent: [0 @ ((rand nextInt: 20)-10)].
				elt translateTo: pos. ]]
		ifAbsent: [view elements do: [ :el | el translateTo: 0 @ ((rand nextInt: 20)-10) ]].
	view canvas camera focusOnCenter.
]

{ #category : #operations }
LRPVisualizationState >> thaw [
	view ifNotNil: [ | canvas |
		canvas := view canvas.
		canvas animations removeAll.
		canvas addAnimation: self layout ]
]

{ #category : #accessing }
LRPVisualizationState >> view [
	^ view
]
