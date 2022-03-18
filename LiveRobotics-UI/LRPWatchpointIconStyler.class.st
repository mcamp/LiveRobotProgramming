"
I am in charge of styling watchpoints inside LRP
"
Class {
	#name : #LRPWatchpointIconStyler,
	#superclass : #Object,
	#instVars : [
		'view'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #style }
LRPWatchpointIconStyler >> style: aLRPNode [

	|r|
	aLRPNode hasWatchpoint ifFalse: [ ^self ].
	
	r := LRPWatchpointTextSegmentMorph from: aLRPNode start to: aLRPNode stop.
	r color: (Color purple alpha: 0.1).
	r icon: Smalltalk ui icons haloView.
	r iconBlock: [:seg :event|  WatchpointWindow openOn: aLRPNode watchpoint  ].
	r label: (aLRPNode watchpoint asString).
	r changeable: false.
	
	view addSegment: r
]

{ #category : #accessing }
LRPWatchpointIconStyler >> view [
	^ view
]

{ #category : #accessing }
LRPWatchpointIconStyler >> view: anObject [
	view := anObject
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitActionNode: aLRPActionNode [
	self style: aLRPActionNode
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitAnyNode: aLRPNode [
	self style: aLRPNode
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitComment: aLRPNode [

]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitErrorNode: anErrorNode [
	
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitEventNode: aLRPEventNode [
	self style: aLRPEventNode 
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitExportNode: anExportNode [
	^self
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitImportNode: anImportNode [
	^self
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitMachineNode: aLRPMachineNode [

	self style: aLRPMachineNode
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitStateNode: aLRPStateNode [
	self style: aLRPStateNode
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitSugarNode: aNode [
	^self
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitTransitionNode: aLRPTransitionNode [
				
]

{ #category : #visitor }
LRPWatchpointIconStyler >> visitVariableNode: aLRPVariableNode [
	self style: aLRPVariableNode
]
