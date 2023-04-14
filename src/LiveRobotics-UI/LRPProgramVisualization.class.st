"
A LRPProgramVisualization is the program visualization part of the LRP User Interface

The Instance Variables contain the widgets, except for:
- lastmodel : the result of the last succesful parse
- interpreter : the interpreter 
- selected: the name of the state machine selected for visualization
- vizstate: the state of the visualization

"
Class {
	#name : #LRPProgramVisualization,
	#superclass : #SpPresenter,
	#instVars : [
		'treelabel',
		'treeview',
		'varlabel',
		'varview',
		'varvalue',
		'varinsp',
		'layoutbutton',
		'followbutton',
		'machineview',
		'lastmodel',
		'interpreter',
		'selection',
		'vizstate',
		'code',
		'blockid'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #layout }
LRPProgramVisualization class >> defaultLayout [
	<spec: #default>
	^ SpecLayout composed 
		newRow: [:trow|
			"column of the tree view and variable editor"
			trow newColumn: [ :col |
				col add: #treelabel height: (self toolbarHeight); add: #treeview;
					addSplitter;
					newRow: [:row | row add: #varlabel; add: #varinsp] height: (self toolbarHeight);
					add: #varview;
					add: #varvalue	height: (self toolbarHeight)] width: 150;
			"addSplitter;"
			"column of the machine visualization"
			newColumn: [ :col |
				col newRow: [: row |
					row add: #layoutbutton ; add: #followbutton ] height: (self toolbarHeight);
				add: #machineview ]]
]

{ #category : #highlighting }
LRPProgramVisualization >> addHighlightTo: aNodeOrNil [
	"only used to highlight a node when building the graph"

	aNodeOrNil ifNotNil: [|name|
		name := aNodeOrNil name.
		self vizstate 
			forNode: name
			do: [:node| node trachelShape color: (Color black).].
		self vizstate
			resetHighNodeTo: name
			withBlock: [:node | ]].
]

{ #category : #operations }
LRPProgramVisualization >> addLayoutAutoPause [
	"This alarm is only valid if no other alarm has been scheduled since.
	 Hence every time this method is executed blockid is increased."
	blockid := blockid + 1.
	World
		addAlarm: #value:
		withArguments: (Array with: blockid)
		for: [:id |	id = blockid ifTrue: [ layoutbutton state: true ]]
		at: Time millisecondClockValue + 10000.

]

{ #category : #visualization }
LRPProgramVisualization >> addNodesOf: aMachine [
	| elements |
	
	elements := aMachine states
			reject: [ :is | is synthetic ] 
			thenCollect: [:state | self elementForState: state ].
	vizstate view addAll: elements.
	self addHighlightTo: aMachine currentState.

	^RTGroup newFrom: elements
]

{ #category : #visualization }
LRPProgramVisualization >> addStarStateTo: aView andElements: elements [
	|star|
	star := (RTEllipse new size: 20; color: (Color lightGray)) elementOn: '*'.
	star
		@ (RTLabeled new color: Color black; view: aView)
		@ RTDraggable.
	aView add: star.
	elements add: star.
	self vizstate layout addNode: star.
	^star
]

{ #category : #visualization }
LRPProgramVisualization >> addTransitionsOf: aMachine withElements: elements [
	|view edges  transblock|

	view := vizstate view.
	
	transblock :=
		[:trans| trans ->
			(self buildTransition: trans withElements: elements forView: view)].
	edges := OrderedCollection new.
	
	edges addAll:
		((aMachine transitions collect: transblock) reject: [:e| e value isNil]).
	edges addAll:
		((aMachine eps collect: transblock) reject: [:e| e value isNil]).
	edges addAll:
		((aMachine ontime collect: transblock) reject: [:e| e value isNil]).

	(aMachine wildtrans reject: [:is | is synthetic ]) size > 0 ifTrue: [
		self addStarStateTo: view andElements: elements.
		edges addAll: ((aMachine wildtrans collect: transblock)	reject: [:e| e value isNil])].
	vizstate edges: edges.
	view addAll: (edges collect: [:e | e value]).
]

{ #category : #operations }
LRPProgramVisualization >> allMachines [
	| recurseBlock retval|
	retval := OrderedCollection new.
	recurseBlock := [:machine| retval add: machine.
		machine states flatCollect: [:state | state machines do: recurseBlock]].

	self machines do: recurseBlock.

	^retval
]

{ #category : #initialization }
LRPProgramVisualization >> buildMachineOnCanvas: aCanvas [
	|machine|
	machine := (self machineForName: self selection).
	machine isNil ifFalse: [
		self visualizeMachine: machine onView: aCanvas view.
		self addLayoutAutoPause]
	
]

{ #category : #initialization }
LRPProgramVisualization >> buildMachineOnView: aView andCanvas: aCanvas [
	|machine|
	machine := (self machineForName: self selection).
	machine isNil ifFalse: [
		self visualizeMachine: machine onView: aView.
		self addLayoutAutoPause]
	
]

{ #category : #'tree visualization' }
LRPProgramVisualization >> buildMachineShapesFor: machines [
	| maels |
	self flag: #TODO.
	maels := RSGroup new.
	
	machines do: [:machine | | shape bcolor icolor|
			bcolor := (machine fullName = self selection)
							ifTrue: [ Color black ]
							ifFalse: [ Color white].
			icolor := machine currentState isNil
							ifTrue: [ Color lightGray ]
							ifFalse: [ Color black ].
			shape := RSComposite new.
			shape add: (RSLabel new text: machine name; color: (Color black)).
			shape add: ((RSBox new borderColor: bcolor)" borderWidth: 3;" color: icolor; size: 15).
			RSVerticalLineLayout new alignCenter; gapSize: 0; on: shape shapes.
			maels add: (shape model: machine).
		].

	"maels do: [ :mach |
		mach when: TRMouseClick do: [ :click | self switchVizTo: mach model fullName.]]."
	
	maels @ RSDraggable.
	 ^maels
]

{ #category : #'tree visualization' }
LRPProgramVisualization >> buildMachineShapesFor: machines andView: aView [
	| maels |
	
	maels := RTGroup new.
	
	machines do: [:machine | | shape bcolor icolor|
			bcolor := (machine fullName = self selection)
							ifTrue: [ Color black ]
							ifFalse: [ Color white].
			icolor := machine currentState isNil
							ifTrue: [ Color lightGray ]
							ifFalse: [ Color black ].
			shape := RTCompositeShape new.
			shape add: (RTLabel new text: [:ma | ma name ]; color: (Color black)).
			shape add: ((RTBox new borderColor: bcolor) borderWidth: 3; color: icolor; size: 15).
			shape vertical.
			maels add: (shape elementOn: machine).
		].

	maels do: [ :mach |
		mach when: TRMouseClick do: [ :click | self switchVizTo: mach model fullName.]].
	
	maels @ RTDraggable.
	 ^maels
]

{ #category : #visualization }
LRPProgramVisualization >> buildTransition: trans withElements: elems forView: view [
	"adds the transition to missingtrans if from or to are absent"
	| efrom eto edge arrow |
	
	trans synthetic ifTrue: [ ^nil].
	
	efrom := elems detect: [ :el | el model = trans from ]
							ifNone: [self vizstate missingtrans add: trans. ^nil].
	eto := elems detect: [ :el | el model = trans to ]
							ifNone: [self vizstate missingtrans add: trans. ^nil].
 
	arrow := RTArrowedLine new
		color: trans color;
		withOffsetIfMultiple;
		width: 3.
	arrow head width: 3.
	edge := arrow edgeFrom: efrom to: eto.
	edge model: trans identifier. 
	edge when: TRMouseClick do: [ :e | self code text widget moveCursorToIndex: trans start].

	trans name = '' ifFalse: [ 
		edge	@ (RTLabeled new
			text: trans name; color: trans color;
			view: view;	offsetOnEdge: 0.7)].

	^ edge
]

{ #category : #'tree visualization' }
LRPProgramVisualization >> buildTreeOnCanvas: aCanvas [
	| machines maels |
	self flag:#TODO.

	machines := self allMachines.
	"(self selection isNil and: [machines isNotEmpty ])
		ifTrue: [	self selection: machines first fullName. machineview refresh.]."

	maels := self buildMachineShapesFor: machines.
	aCanvas addAll: maels.
	
	RSLineBuilder line 
			canvas: aCanvas;
			objects: machines;
			shape: (RSLine new
				color: (Color black);
				width: 2;
				attachPoint: RSHorizontalAttachPoint new);
			connectFrom: #containerMachine to: #yourself.
	
	RSTreeLayout new verticalGap: 40; horizontalGap: 20;	 on: maels.
	"aView @ RTDraggableView."
	"(RSGroup withAll: aCanvas elements) translateTo: 0 @ 0"
]

{ #category : #'tree visualization' }
LRPProgramVisualization >> buildTreeOnView: aView andCanvas: aCanvas [
	| machines maels |

	machines := self allMachines.
	(self selection isNil and: [machines isNotEmpty ])
		ifTrue: [	self selection: machines first fullName. machineview refresh.].

	maels := self buildMachineShapesFor: machines andView: aView.
	aView addAll: maels.
	
	RTEdgeBuilder new 
			view: aView;
			objects: machines;
			shape: (RTLine new
				color: (Color black);
				width: 2;
				attachPoint: RTShorterDistanceAttachPoint new);
			connectFrom: #containerMachine to: #yourself.
	
	RTTreeLayout new verticalGap: 40; horizontalGap: 20;	 on: maels.
	aView @ RTDraggableView.
	(RTGroup withAll: aView elements) translateTo: 0 @ 0
]

{ #category : #accessing }
LRPProgramVisualization >> code [
	^ code
]

{ #category : #accessing }
LRPProgramVisualization >> code: anObject [
	code := anObject
]

{ #category : #initialization }
LRPProgramVisualization >> connectPresenters [
	"self halt.
	varview whenSelectionChanged: [|item|
		item := varview selectedItem.
		item ifNotNil: [ 
			((item key wasInitialized) or: [ item key shouldNotInitialize  ])
				ifTrue: [ varvalue text: item value. varvalue enable]
				ifFalse: [ varvalue text: ''. varvalue disable ]]
		].
	"
"	varvalue acceptBlock: [:text| | theitem |
		theitem := varview selectedItem.
		theitem ifNotNil: [|val scope|"
			"Treat this as a special case, otherwise can never set a variable to nil."
"			text = 'nil'
				ifTrue: [ val := nil ]
				ifFalse: [
					val := [OpalCompiler evaluate: text] ifError: [ text ]."
					"Returns nil on syntax error"
"					val ifNil: [ val := text ]	].					
			scope := (self machineForName: self selection) scope.
			scope setVariable: theitem key name withValue: val]]."
"
	varinsp action: [|machine|
		machine := self machineForName: self selection.
		machine ifNotNil: [machine scope inspect.]].
	
	layoutbutton activationAction: [ self vizstate freeze ].
	layoutbutton deactivationAction: [ self vizstate thaw ]."
	
]

{ #category : #layout }
LRPProgramVisualization >> defaultLayout [

	^ self newBoxLayoutLeftToRight 
			"column of the tree view and variable editor"
		add: (self newBoxLayoutTopToBottom 
					add: treelabel expand: false; 
					add: treeview;
					"addSplitter;"
					add: (self newBoxLayoutLeftToRight 
								add: varlabel; 
								add: varinsp;
								yourself) expand: false;
					add: varview;
					add: varvalue expand: false;
					yourself) width: 150;
			"addSplitter;"
			"column of the machine visualization"
		add:(self newBoxLayoutTopToBottom 
					add: (self newBoxLayoutLeftToRight 
								add: layoutbutton;
								add: followbutton;
								yourself) expand: false;
					add: machineview;
					yourself);
		yourself
]

{ #category : #visualization }
LRPProgramVisualization >> elementForState: aState [
	|elt nested|

	nested := aState machines.

	elt := (RTEllipse new size: 30; color: (Color white)).
	nested	 size > 0
		ifTrue: [ elt borderColor: (Color gray); borderWidth: 3 ]
		ifFalse: [ elt	borderColor: (Color black); borderWidth: 1].
	elt := elt elementOn: aState name asString.
	elt @ (RTLabeled new view: (self vizstate view); color: Color black) @ RTDraggable.
	elt when: TRMouseClick do: [ :e | self code text widget moveCursorToIndex: aState start ].
	nested size = 1 ifTrue: [
		elt @ ((RTPopup text: 'Nested: ',nested first name)
					backgroundColor: (Color r: 0.86 g: 0.86 b: 0.86);
					alphaPopupBackground: 1;
					borderColor: Color lightGray) ].
	nested size > 1 ifTrue: [
		elt @ ((RTPopup text: 'Multiple Nested')
					backgroundColor: (Color r: 0.86 g: 0.86 b: 0.86);
					alphaPopupBackground: 1;
					borderColor: Color lightGray) ].
	elt @ (RTMenuActivable new 
			item: 'Transition here'
			action: [ :e |
							self code interpreter transitionTo: aState.
							self highlightNode: aState name];
			item: 'Teleport here'
			action: [ :e |
							self code interpreter jumpTo: aState.
							self highlightNode: aState name];
			item: 'Inspect me'
			action: [:e | aState inspect]).
	^elt
]

{ #category : #accessing }
LRPProgramVisualization >> followbutton [
	^ followbutton
]

{ #category : #accessing }
LRPProgramVisualization >> followbutton: anObject [
	followbutton := anObject
]

{ #category : #highlighting }
LRPProgramVisualization >> highlightEdge: aName [
	self vizstate
		forEdge: aName
		do: [:edge | edge value shape color: (edge key highlightColor)].
	self vizstate
		resetHighEdgeTo: aName
		withBlock: [:edge | edge value shape color: (edge key color)].
	vizstate view signalUpdate.

]

{ #category : #highlighting }
LRPProgramVisualization >> highlightNode: aName [
	"do not re-highlight already highlighted node, otherwise it will be turned gray"
	self vizstate highNodeName = aName ifFalse: [ 
		self vizstate 
			forNode: aName
			do: [:node| node trachelShape color: (Color black) ].
		self vizstate
			resetHighNodeTo: aName
			withBlock: [:node | node trachelShape color: (Color gray).].
		vizstate view signalUpdate.]
	
]

{ #category : #api }
LRPProgramVisualization >> highlightState: aLRPState [
	|container|
	"if called by the interpreter before the view was set. See issue #15"
	self vizstate view isNil ifTrue:[^self].
	
	"if there is no machine selected"
	self selection isNil ifTrue: [^self].

	aLRPState ifNil: [self highlightNode: ''. ^self  ].
	
	container := aLRPState container fullName.
	
	container = self selection 
		"I am visualizing this machine"
		ifTrue: [ self highlightNode: aLRPState name ]
		ifFalse: [ self followbutton state
				ifTrue: [self switchVizTo: container.]
				ifFalse: [self updateHighlightOtherMachine: aLRPState.
							treeview refresh.]]
]

{ #category : #api }
LRPProgramVisualization >> highlightTransition: aLRPTransition [

	"if called by the interpreter before the view was set. See issue #15"
	self vizstate view isNil ifTrue:[^self].

	aLRPTransition isNil
		ifTrue: [ self highlightEdge: '' ]
		ifFalse: [aLRPTransition container fullName = self selection
						ifTrue: [ self highlightEdge: aLRPTransition name ]
						ifFalse: [ self highlightEdge: '' ]
			].
]

{ #category : #initialization }
LRPProgramVisualization >> initializeWidgets [
	self flag:#TODO.
	treelabel := self newLabel.
	treeview := self instantiate: SpRoassalPresenter.
	varlabel := self newLabel.
	varview := self newNullPresenter. "multicolumn"
	varvalue := self newTextInput.
	varinsp := self newButton.
	layoutbutton := self newCheckBox.
	followbutton := self newCheckBox.
	machineview := self newNullPresenter. "self instantiate: SpRoassalPresenter."

	treelabel label: '      Machines:'.
	treeview script: [:canvas| self buildTreeOnCanvas: canvas ].
	varlabel label: '   Variables '.
	"varview displayBlock: self varViewBlock."

	"varvalue isCodeCompletionAllowed: false; autoAccept: false; acceptOnCR: true."
	"varvalue ghostText: 'Select initialized var'."
	varinsp enabled: true; label: 'Inspect'.
	
	layoutbutton label: 'Freeze Movement'.
	blockid := 0.
	followbutton label: 'Follow Highlight'.
	"machineview script: [:view :canvas| self buildMachineOnView: view andCanvas: canvas.]."
	

]

{ #category : #api }
LRPProgramVisualization >> interpreter [
	^ interpreter
]

{ #category : #api }
LRPProgramVisualization >> interpreter: anObject [
	interpreter := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> lastmodel [
	^ lastmodel
]

{ #category : #accessing }
LRPProgramVisualization >> lastmodel: anObject [
	lastmodel := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> layoutbutton [
	^ layoutbutton
]

{ #category : #accessing }
LRPProgramVisualization >> layoutbutton: anObject [
	layoutbutton := anObject
]

{ #category : #operations }
LRPProgramVisualization >> machineForName: aString [
	|machines|
	machines :=
		(self machines collect: [:ma| ma forName: aString])
			reject: [:ma | ma isNil ].
	machines size = 1
		ifTrue: [^ machines at: 1 ]
		ifFalse: [^ nil  ]
]

{ #category : #accessing }
LRPProgramVisualization >> machinelabel [
	^ machinelabel
]

{ #category : #accessing }
LRPProgramVisualization >> machinelabel: anObject [
	machinelabel := anObject
]

{ #category : #operations }
LRPProgramVisualization >> machines [
	self lastmodel isNil 
		ifTrue: [ ^#() ]
		ifFalse: [^(self lastmodel select:[:i| i class = LRPMachine])].
]

{ #category : #accessing }
LRPProgramVisualization >> machineview [
	^ machineview
]

{ #category : #accessing }
LRPProgramVisualization >> machineview: anObject [
	machineview := anObject
]

{ #category : #operations }
LRPProgramVisualization >> populateVariables [
	| machine |
	
	machine := (self machineForName: self selection).
	machine isNil
		ifTrue: [ varview items: #().]
		ifFalse: [|vars|
			vars := (interpreter variablesInScopeOf: machine).
			varview items: vars.].
]

{ #category : #accessing }
LRPProgramVisualization >> selection [
	^ selection
]

{ #category : #accessing }
LRPProgramVisualization >> selection: anObject [
	selection := anObject
]

{ #category : #visualization }
LRPProgramVisualization >> switchVizTo: aMachineName [
	"let's have a look at a different machine"

	self vizstate layout ifNotNil: [ :anim| anim stopAndRemove].  "Remove the animation"
	self vizstate recordPositionsAs: self selection.
	self selection: aMachineName.
	treeview refresh.
	machineview refresh.
	self populateVariables.
	self layoutbutton state ifTrue:[self vizstate freeze].
]

{ #category : #accessing }
LRPProgramVisualization >> treelabel [
	^ treelabel
]

{ #category : #accessing }
LRPProgramVisualization >> treelabel: anObject [
	treelabel := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> treeview [
	^ treeview
]

{ #category : #accessing }
LRPProgramVisualization >> treeview: anObject [
	treeview := anObject
]

{ #category : #visualization }
LRPProgramVisualization >> updateCurrentMachineVis [
	|  machine |
	
	machine := self machineForName: self selection.
	machine compareStates isNil ifTrue:[^self]. "Machine was nonexistant before"

	layoutbutton state: false.
	self updateStatesOf: machine.
	self updateStarStateOf: machine.
	self updateTransitionsOf: machine.
	self addLayoutAutoPause.
]

{ #category : #highlighting }
LRPProgramVisualization >> updateHighlightOtherMachine: aLRPState [
	|container|
	
	container := aLRPState container fullName.
	(self selection beginsWith: container)
			"it is a parent machine that changes, unhighlight"		
			 ifTrue: [self highlightNode: '']
			"if it is a child machine that changes, highlight the corresponding state"
			ifFalse: [(container beginsWith: self selection)
					ifTrue: [self highlightNode: (aLRPState container stateOfParentMachine: self selection) name ]]
]

{ #category : #visualization }
LRPProgramVisualization >> updateStarStateOf: aMachine [
	| view elements|
	
	view := self vizstate view.	
	elements := view elements.
	
	(aMachine wildtrans reject: [:is | is synthetic ])
		size > 0
			ifTrue: [
				(elements anySatisfy: [:elt | elt model = '*'])
					ifFalse: [ self addStarStateTo: view andElements: elements.] ]
			ifFalse: [
				elements detect: [:elt | elt model = '*' ]
							ifFound: [: elt | view removeElement: elt].
				] .
]

{ #category : #visualization }
LRPProgramVisualization >> updateStatesOf: aMachine [
	| view |
	
	view := self vizstate view.	

	(aMachine compareStates added reject: [:is | is synthetic ])
		do:[:state| |elt|
			elt := (self elementForState: state).
			view add: elt.
			self vizstate layout addNode: elt].

	(aMachine compareStates removed reject: [:is | is synthetic ])
		do: [:state | view removeElement: (view elementFromModel: state name)	].
]

{ #category : #visualization }
LRPProgramVisualization >> updateTransitionsOf: aMachine [
	| view elements|
	
	view := self vizstate view.	
	elements := view elements.

	aMachine compareTransitions removed do: [:trans | |edge|
		edge := (self vizstate view edgeFromModel: trans identifier).
		edge isNil
			ifTrue: [|oldtrans|
				"also consider that invisible transitions due to sugar can have been removed"
				oldtrans := self vizstate missingtrans detect: [ :t | t identifier = trans identifier ] ifNone: [nil].
				oldtrans ifNotNil: [self vizstate missingtrans remove: oldtrans]]
			ifFalse: [edge remove]].
	
	aMachine compareTransitions added do: [:trans | |edge|
		edge := self buildTransition: trans withElements: elements forView: view.
		edge ifNotNil: [view add: edge] ].
	
	aMachine compareStates removed do: [:state |
		aMachine allTransitions do: [:trans | (trans from = state name) | (trans to = state name) ifTrue: [ 
				(self vizstate view edgeFromModel: trans identifier)
					ifNotNilDo: [:edge | edge remove].
				self vizstate missingtrans add: trans]]].
	
	aMachine compareStates added isEmpty ifFalse: [|missing|
		missing := self vizstate missingtrans. 
		self vizstate missingtrans: OrderedCollection new.
		missing do: [:trans | |edge| 
			edge := self buildTransition: trans withElements: elements forView: view.
			edge ifNotNil: [view add: edge]]].
	

]

{ #category : #visualization }
LRPProgramVisualization >> updateVis [
	| removed |
	
	"Not showing a machine right now"	
	self selection isNil ifTrue: [
		treeview refresh.
		"self populateVariables."
		^self].
	
	removed := interpreter removedMachines.
	
	"Currently vis'd machine is removed"
	(removed anySatisfy: [ :mach| self selection beginsWith: mach fullName]) ifTrue: [ 
		self selection: nil.
		"this sanity check is required"
		self vizstate view isNil ifFalse: [self vizstate view cleanAll].
		treeview refresh.
		self populateVariables.
		^self].
	
	"self updateCurrentMachineVis."
	
	"added := interpreter compareAST addedMachines."
	"DOES NOT TAKE INTO ACCOUNT NESTED MACHINES
	((added isEmpty) & (removed isEmpty)) ifFalse: [treeview refresh]."
	treeview refresh.
	"self populateVariables."
]

{ #category : #api }
LRPProgramVisualization >> varChange: aVariable inMachine: aLRPMachine [ 
	"The machine we get is the root machine, not the machine where the var was changed,
	Plus we get the variable of the scope class, not of LRP.
	So we cannot update very intelligently. We just check for variable name."

	(varview listItems anySatisfy: [:assoc| assoc key name = aVariable key])
		ifTrue: [self populateVariables.]

]

{ #category : #initialization }
LRPProgramVisualization >> varViewBlock [
	^ [ :item | | var val |
		var := item key. 
		val := ((var wasInitialized) or: [ var shouldNotInitialize ])
				ifTrue: [ item value ]
				ifFalse: [ '-- no value yet --' ].
		{var name asString . val asString} ]
]

{ #category : #accessing }
LRPProgramVisualization >> varinsp [
	^ varinsp
]

{ #category : #accessing }
LRPProgramVisualization >> varinsp: anObject [
	varinsp := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> varlabel [
	^ varlabel
]

{ #category : #accessing }
LRPProgramVisualization >> varlabel: anObject [
	varlabel := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> varset [
	^ varset
]

{ #category : #accessing }
LRPProgramVisualization >> varset: anObject [
	varset := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> varvalue [
	^ varvalue
]

{ #category : #accessing }
LRPProgramVisualization >> varvalue: anObject [
	varvalue := anObject
]

{ #category : #accessing }
LRPProgramVisualization >> varview [
	^ varview
]

{ #category : #accessing }
LRPProgramVisualization >> varview: anObject [
	varview := anObject
]

{ #category : #visualization }
LRPProgramVisualization >> visualizeMachine: aMachine onView: aView [
	| elements roassalLayout stepping |
	self flag: #TODO.
	self vizstate newView: aView.
	
	elements := self addNodesOf: aMachine.
	self vizstate setPositionsFor: self selection.	
	
	roassalLayout := RSForceBasedLayout new
					charge: -450; length: 100; 
					doNotUseProgressBar; applyOn: elements; yourself.
	roassalLayout initialLayout: RSNoLayout new.	
	"stepping := RSSpringLayoutStepping new 
						layoutWithoutPreparing: roassalLayout; inView: aView;
						afterBlock: [ aView canvas camera focusOnCenter].
	self vizstate layout: stepping."
	
	self addTransitionsOf: aMachine withElements: elements.
]

{ #category : #accessing }
LRPProgramVisualization >> vizstate [
	vizstate isNil ifTrue: [ vizstate := LRPVisualizationState new ].
	^ vizstate
]

{ #category : #accessing }
LRPProgramVisualization >> vizstate: anObject [
	vizstate := anObject
]
