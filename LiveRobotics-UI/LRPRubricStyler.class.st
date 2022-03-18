"
A LRPRubricStyler is for styling LRPcode when using the Rubric text editor.

Color choices are taken from SHTextStylerST80 class >> blueStyleTable
"
Class {
	#name : #LRPRubricStyler,
	#superclass : #SHRBTextStyler,
	#instVars : [
		'nodes',
		'attrName',
		'attrKeyword',
		'attrComment',
		'attrVar',
		'attrSelfSuper'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #api }
LRPRubricStyler >> addIcon: anIcon at: aPosition withLabel: aString [
	|sm|
	
	"Do not add multiple icons for the same line"
	(view segments anySatisfy: [ :seg | seg lastIndex = aPosition]) 
		ifTrue: [^self].
	
	sm := RubUnderlinedSegmentMorph from: aPosition -1 to: aPosition.
	sm icon: anIcon.
	sm changeable: false.
	sm label: aString.
	view addSegment: sm.
	view rulers do: [ :r | r textChanged ]
]

{ #category : #api }
LRPRubricStyler >> addUnderlineFrom: start to: stop color: aColor [
	|r|
	"Do not add multiple lines for the same stop position"
	(view segments anySatisfy: [ :seg | seg lastIndex = stop]) 
		ifTrue: [^self].
	
	r := RubUnderlinedSegmentMorph from:  start to:  stop.
	r underlineColor: aColor.
	r changeable: false.
	
	view addSegment: r
]

{ #category : #accessing }
LRPRubricStyler >> iconProvider [
	" For 2.0/3.0 compatibility "
	^ (Smalltalk respondsTo: #ui)
		ifTrue: [ (Smalltalk perform: #ui) icons]
		ifFalse: [ UITheme current ]
]

{ #category : #initialization }
LRPRubricStyler >> initialize [
	super initialize.
	
	attrName := {TextColor new color: Color magenta muchDarker; yourself}.
	attrKeyword := {TextEmphasis italic}.
	attrComment := {TextColor new color: Color veryDarkGray ; yourself}.
	attrVar := {TextColor new color: Color blue darker; yourself}.
	attrSelfSuper := {TextColor new color: Color red . TextEmphasis underlined}.
	
]

{ #category : #private }
LRPRubricStyler >> methodOrBlockTempDeclStyleFor: aSequenceNode [
	^ #blockPatternTempVar
]

{ #category : #accessing }
LRPRubricStyler >> nodes [
	^nodes ifNil:[nodes := parser parse: text]
]

{ #category : #accessing }
LRPRubricStyler >> nodes: anArrayLRPNodes [
	nodes := anArrayLRPNodes
]

{ #category : #api }
LRPRubricStyler >> style: aText nodes: astColl [

	view segments do:[:aSegment| aSegment ifNotNil:[aSegment delete]].
	"sometimes it's not deleted unless you do it twice"
	view segments do:[:aSegment| aSegment ifNotNil:[aSegment delete]].

	text := aText.	
	charAttr := Array new: aText size withAll: (self attributesFor: #default).
	bracketLevel := 0.
	parentheseLevel:=0.
	astColl do:[:aNode| aNode acceptVisitor: self].
	aText runs: (RunArray newFrom: charAttr).

]

{ #category : #private }
LRPRubricStyler >> styleTempBars: aSequenceNode [
	| tempBarAttribute |
	tempBarAttribute :=  #blockTempBar.
	aSequenceNode leftBar
		ifNotNil: [ :pos | self addStyle: tempBarAttribute from: pos to: pos ].
	aSequenceNode rightBar
		ifNotNil: [ :pos | self addStyle: tempBarAttribute from: pos to: pos ]
]

{ #category : #visiting }
LRPRubricStyler >> visitActionNode: aLRPActionNode [

	"if it is a syntactic sugar generated node, start will be nil"
	aLRPActionNode start isNil ifTrue: [ ^self ].
						
	charAttr
			from: aLRPActionNode start + 1 
			to: aLRPActionNode keywordEnd
			put: attrKeyword.
	
	aLRPActionNode block acceptVisitor: self.
]

{ #category : #visiting }
LRPRubricStyler >> visitAnyNode: aLRPNode [

	^self
]

{ #category : #visiting }
LRPRubricStyler >> visitAssignmentNode: anAssignmentNode [
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value.
]

{ #category : #visiting }
LRPRubricStyler >> visitComment: aLRPNode [

	charAttr  
			from: aLRPNode start 
			to: aLRPNode stop
			put: attrComment.
]

{ #category : #visiting }
LRPRubricStyler >> visitErrorNode: anErrorNode [

	self addUnderlineFrom: anErrorNode start
			to: anErrorNode stop
			color: Color lightRed.
			
	self addIcon: Smalltalk ui icons smallWarningIcon
		at: anErrorNode failPosition
		withLabel: 'Parse Error' 

]

{ #category : #visiting }
LRPRubricStyler >> visitEventNode: aLRPEventNode [
	"syntactic sugar nodes have no ranges since they do not exist in the source text"
	aLRPEventNode start isNil ifTrue: [^self].

	charAttr
			from: aLRPEventNode start + 1 
			to: aLRPEventNode nameRange first - 1
			put: attrKeyword.	

	charAttr
			from: aLRPEventNode nameRange first 
			to: aLRPEventNode nameRange last
			put: attrName.
	
	self visitBlockNode: aLRPEventNode trigger.
]

{ #category : #visiting }
LRPRubricStyler >> visitExportNode: aLRPExportNode [
	
	charAttr 
			from: aLRPExportNode start + 1 
			to: aLRPExportNode nameRange first - 1
			put: attrKeyword.

	charAttr
			from: aLRPExportNode nameRange first 
			to: aLRPExportNode nameRange last
			put: attrName 
	
]

{ #category : #visiting }
LRPRubricStyler >> visitImportNode: aLRPImportNode [
	
	charAttr 
			from: aLRPImportNode start + 1 
			to: aLRPImportNode nameRange first - 1
			put: attrKeyword.	

	charAttr
			from: aLRPImportNode nameRange first 
			to: aLRPImportNode nameRange last
			put: attrName
	
]

{ #category : #visiting }
LRPRubricStyler >> visitLRPVariableNode: aLRPVariableNode [
	| range |
	
	"if it is a syntactic sugar generated node, start or stop will be nil"
	((aLRPVariableNode start isNil) or: [aLRPVariableNode stop isNil]) ifTrue: [^self].
	
	range := aLRPVariableNode nameRange.

	charAttr 
			from: aLRPVariableNode start + 1 
			to: range first - 1
			put: attrKeyword.	
	
	charAttr 
			from: range first 
			to: range last
			put: attrVar .
	
	self visitBlockNode: aLRPVariableNode value.


	
	
]

{ #category : #visiting }
LRPRubricStyler >> visitMachineNode: aLRPMachineNode [
	| range |
	range := aLRPMachineNode nameRange.

	charAttr  
			from: aLRPMachineNode start + 1 
			to: range first - 1
			put: attrKeyword.	
	
	charAttr
			from: range first
			to: range last
			put: attrName.
			

]

{ #category : #visiting }
LRPRubricStyler >> visitSelfNode: aSelfNode [
	self
		addAttributes: attrSelfSuper
		forNode: aSelfNode
]

{ #category : #visiting }
LRPRubricStyler >> visitSpawnNode: aLRPSpawnNode [
	
	charAttr
			from: aLRPSpawnNode start + 1 
			to: aLRPSpawnNode nameRange first - 1
			put: attrKeyword .


]

{ #category : #visiting }
LRPRubricStyler >> visitStateNode: aLRPStateNode [
	
	"if it is a syntactic sugar generated node, start or stop will be nil"
	((aLRPStateNode start isNil) or: [aLRPStateNode stop isNil]) ifTrue: [^self].

	charAttr
			from: aLRPStateNode start + 1 
			to: aLRPStateNode nameRange first - 1
			put: attrKeyword .

	charAttr 
			from: aLRPStateNode nameRange first 
			to: aLRPStateNode nameRange last
			put: attrName.

	aLRPStateNode body do:[:node| node acceptVisitor: self].

]

{ #category : #visiting }
LRPRubricStyler >> visitSugarNode: aLRPSugarNode [
	
	charAttr 
			from: aLRPSugarNode start + 1 
			to: aLRPSugarNode nameRange first - 1
			put: attrKeyword.	
]

{ #category : #visiting }
LRPRubricStyler >> visitSuperNode: aSuperNode [
	self
		addAttributes: attrSelfSuper 
		forNode: aSuperNode
]

{ #category : #visiting }
LRPRubricStyler >> visitTransitionNode: aLRPTransitionNode [
	
	"if it is a syntactic sugar generated node, start or stop will be nil"
	((aLRPTransitionNode start isNil) or: [aLRPTransitionNode stop isNil]) ifTrue: [^self].
						
	charAttr
			from: aLRPTransitionNode start + 1  
			to: aLRPTransitionNode keywordEnd
			put: {TextColor new color: aLRPTransitionNode highlightColor; yourself.
					TextEmphasis italic}.
	charAttr
			from: aLRPTransitionNode nameRange first 
			to: aLRPTransitionNode nameRange last
			put: attrName.

	charAttr
			from: aLRPTransitionNode arrowRange first 
			to: aLRPTransitionNode arrowRange last
			put: {TextColor new color: aLRPTransitionNode highlightColor; yourself.
						TextEmphasis bold}
]

{ #category : #visiting }
LRPRubricStyler >> visitVariableNode: aVariableNode [
	self
		addAttributes: attrVar
		forNode: aVariableNode
]
