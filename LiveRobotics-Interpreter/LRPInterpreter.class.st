"
I am the interpreter for LRP programs.

To init a program without user interface, use:
self start: aProgram.

To initialize me with an interface, use:
self startWithUI: aLRPUI

To initialize a proram with user interface, use:
self start: aProgram ui: aLRPUI
"
Class {
	#name : #LRPInterpreter,
	#superclass : #Object,
	#instVars : [
		'scope',
		'ui',
		'rate',
		'runningProcess',
		'runningAST',
		'withLoop',
		'pause',
		'compareAST',
		'restarted',
		'withExecution',
		'bridgeInstance',
		'parser',
		'runningMachine',
		'runningMachines',
		'announcer'
	],
	#classVars : [
		'LRPRootPath'
	],
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #processing }
LRPInterpreter class >> finishAll [

	self allInstances do: [:interpreter|
		interpreter terminateProcess.
		interpreter cleanUp.]
]

{ #category : #preferences }
LRPInterpreter class >> lrpRootPath [
	LRPRootPath isNil ifTrue: [ LRPRootPath := FileSystem workingDirectory fullName].
	^LRPRootPath
]

{ #category : #preferences }
LRPInterpreter class >> lrpRootPath: aFileRef [
	LRPRootPath := aFileRef
]

{ #category : #preferences }
LRPInterpreter class >> lrpSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #liveRobotProgramming) 
		label: 'Live Robot Programming';
		noOrdering;
		description: 'All settings concerned with LRP' ;
		with: [	
			(aBuilder setting: #lrpRootPath)
				type: #Directory;
				label: 'The root directory for all LRP code';
				description: 'By default the Pharo working directory. Set this to the root of the modules repository.']
]

{ #category : #'instance creation' }
LRPInterpreter class >> start: aProgram ui: aLRPUI [
	|ret|
	ret := self new.
	ret start: aProgram ui: aLRPUI.
	^ret.
]

{ #category : #'instance creation' }
LRPInterpreter class >> startWithUI: aLRPUI [
	^self start: '' ui: aLRPUI.
]

{ #category : #'adding - removing' }
LRPInterpreter >> addRunningMachine: aMachineName [
	"always adds the machine since this part of a program update action"
	|machine|
	
	machine := scope machines at: aMachineName.
	runningMachines add: machine.
	^machine.
]

{ #category : #'adding - removing' }
LRPInterpreter >> addRunningMachine: aMachineName scope: aScope [

	|machine|
	
	machine := 
		aScope machines 
				at: aMachineName
				ifAbsent: [
					LRPErrorHandler instance machineNotFound: aMachineName.
					nil.
				].

	machine ifNotNil: [
		"an already running machine may not be spawned again"
		(machine initState notNil or: [ machine currentState notNil ])
			ifTrue: [ LRPErrorHandler instance machineNotSpawnable: aMachineName. ^nil].
		runningMachines add: machine ].
	^machine.

	
]

{ #category : #watchpoints }
LRPInterpreter >> addWatchpointWithCursorPosition: anInteger [
	|generatedNode lrpNode|
	
	lrpNode := self program findBestLRPNodeFor: anInteger.
	lrpNode acceptWatchpoint ifFalse: [^nil].
	
	generatedNode := self generatedNodeForCursorPosition: anInteger.
	(RFValueReification entities 
		anySatisfy: [:validReification| validReification = generatedNode class ])
			ifFalse: [^nil].
	lrpNode watchpoint: (Watchpoint in: generatedNode).
	
	^lrpNode watchpoint
]

{ #category : #accessing }
LRPInterpreter >> announcer [
	^announcer
]

{ #category : #accessing }
LRPInterpreter >> bridgeInstance [
	^ bridgeInstance
]

{ #category : #accessing }
LRPInterpreter >> bridgeInstance: anObject [
	bridgeInstance := anObject
]

{ #category : #accessing }
LRPInterpreter >> bridgeVars [
	^ bridgeInstance vars
]

{ #category : #'force changes' }
LRPInterpreter >> changeToState: aLRPState withActions: aBoolean [
	| commonRoot oldPause|
	
	oldPause := pause.
	self pauseProcess.

	commonRoot := self findActiveSuperOf: aLRPState container.
	commonRoot isNil
		ifFalse: [	
			commonRoot finishWithAction: aBoolean.
			commonRoot container isNil
				ifTrue: [ "if this machine was spawned at root, it should be removed"
					runningMachines remove: commonRoot ifAbsent: [nil] ]
				ifFalse: [ commonRoot container runningMachines remove: commonRoot ].
			].
		
	self recursivelySetState: aLRPState withActions: aBoolean spawn: true.
	
	self pauseInterpreter: oldPause.
]

{ #category : #'initialize-release' }
LRPInterpreter >> cleanUp [
	scope ifNotNil: [ scope cleanUp].
]

{ #category : #'force changes' }
LRPInterpreter >> findActiveSuperOf: aMachine [
	
	aMachine currentState isNil
		ifTrue: [
			aMachine container isNil
				ifTrue: [ ^nil ]
				ifFalse: [ ^ self findActiveSuperOf: aMachine container container ]]
		ifFalse: [ ^aMachine  ]

]

{ #category : #'force changes' }
LRPInterpreter >> findCorrespondingState: aState [
	|names machine|
	
	names := $/ split: aState fullName.
	machine := scope machines at: names second.
	
	^machine findInnerChild: names allButFirst.
]

{ #category : #'program - comparison' }
LRPInterpreter >> firstAddedMachine [
	"convenience method for the tests: first added machine"
	^compareAST addedMachines first
]

{ #category : #'program - comparison' }
LRPInterpreter >> firstNewMachine [
	"convenience method for the tests: first new machine"
	^compareAST firstNewMachine
]

{ #category : #'program - comparison' }
LRPInterpreter >> firstRemovedMachine [
	"convenience method for the tests: first removed machine"
	^compareAST removedMachines first
]

{ #category : #watchpoints }
LRPInterpreter >> generatedNodeForCursorPosition: aNumber [
	|node wrapper outerScope|
	node := self program findBestLRPNodeFor: aNumber.
	outerScope := node outerScope.

	outerScope ifNil: [ outerScope := scope ].
	 
	wrapper := outerScope blocks at: node block.
	
	^ wrapper generatedNodeFor: aNumber - node block start.

	
]

{ #category : #'program - processing' }
LRPInterpreter >> hasProcessTerminated [
	
	^runningProcess isNil
		ifTrue:[true]
		ifFalse:[runningProcess isTerminated].
]

{ #category : #'initialize-release' }
LRPInterpreter >> initialize [

	super initialize.
	withLoop := false.
	pause := false.
	rate := 10.
	withExecution := true.
	compareAST := LRPCompare new.
	restarted := true.
	runningMachines := OrderedCollection new.
	announcer := Announcer new.
	
	self setupBridge
]

{ #category : #interpret }
LRPInterpreter >> interpret: anArray [
	"This method interpret and execute for the FIRST TIME a LRP Program
	anArray is the top-level node of the AST.
	 This should only contain variables, machines, spawn statements and sugar that is not interpreted"
	| vars oldScope |
	oldScope := scope.
	scope := LRPSlotVarScope rootFor: self withCode: anArray.
	self bridgeInstance setVariablesInScope: scope.

	"variable initialization"
	vars := anArray select: [:node | node class = LRPVariable ].
	compareAST isFirstProgram 
		ifTrue: [ 	"there is no previous program"
			vars do: [:var| self interpretVariable: var withScope: scope andVariableCompare: nil]]
		ifFalse: [ |oldVars compare machine|
			"a bit of a ugly hack due to the inconsistencies of being the top level node"
			oldVars := compareAST oldVariables.
			machine := LRPMachine new.
			machine scope: oldScope.
			compare := LRPCompareNodes old: oldVars new: nil oldRoot: machine.
			vars do: [:var|
				self interpretVariable: var withScope: scope andVariableCompare: compare ]].
		
	vars do: [:var| self scope initializeVariable: var].
	
	"we should first interpret the machines before we can do a spawn"
	anArray
		select: [:node | node class = LRPMachine ]
		thenDo: [:machine | self interpretMachine: machine withScope: scope].
	
	"Do all the spawn"
	anArray 
		select: [ :node | node class = LRPSpawn ] 
		thenDo:[:spawn | self spawn: spawn machine in: spawn state withScope: scope.].
	
	"Run the main loop "
	self runMainLoop.

]

{ #category : #interpret }
LRPInterpreter >> interpret: anArray withScope: aScope [

	anArray do:[:aParseNode| aParseNode interpretWith: self scope: aScope]
	
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretAction: anAction withScope: aScope type: aSymbol [
	| block |
	"a block or a spawn, the latter in the case of an onentry spawn"
	block := anAction block.
	anAction interpretedBlock: (
		 block isBlock 
			ifTrue:[ self interpretBlock: block withScope: aScope]
			ifFalse: [block]).

]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretBlock: aBlock withScope: aScope [
	"Note that I return a block and thus do not compile aBlock yet!"
	
	^[(aScope interpretBlock: aBlock withInterpreter: self)
					ifError:[:err| LRPErrorHandler instance error: err inBlock: aBlock. false]]
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretEpsilonTransition: aTransition withScope: aScope [
	
	aScope addTransition: aTransition.
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretEvent: aEvent withScope: aScope [

	aEvent triggerBlock: (self interpretBlock: aEvent trigger withScope: aScope).
	aScope addEvent: aEvent.
	
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretMachine: aMachine withScope: aScope [
	| childScope |
	
	childScope := aScope childScopeFor: aMachine.
	aScope addMachine: aMachine.
	aMachine scope: childScope.

	"the API for first interpretation of variables is different from states and transitions
	so no double dispatch over the entire body with a self interpret: aMachine body withScope: childScope. "
	aMachine allVariables do: [ :aVar | self interpretVariable: aVar withScope: childScope andVariableCompare: aMachine compareVariables ].
	
	"skip the double dispatch to make it a bit faster"
	aMachine allStates do: [ :aState | self interpretState: aState withScope: childScope ].
	aMachine allEvents do: [ :anEvent | self interpretEvent: anEvent withScope: childScope ].
	"here we need to do a double dispatch because there are different transition classes"
	self interpret: aMachine allTransitions withScope: childScope.

]

{ #category : #interpret }
LRPInterpreter >> interpretProgram: aLRPProgram [
	| ast |
	"Includes module support, so recurses and flattens the import hierarchy from back to front."

	ast := aLRPProgram ast.
	
	"just add the imported machine AST's to the AST that is interpreted"
	ast addAll: aLRPProgram resolvedImports.
		
	self interpret: ast.

]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretState: aState withScope: aScope [
	
	aScope addState: aState.
	self interpret: aState body withScope: aScope.
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretTimeoutTransition: aTransition withScope: aScope [
	|value eventname|

	"if eventname is string, is a variable, else is an integer"
	eventname := aTransition eventname .

	eventname isString
		ifTrue: [value := (aScope containsVariable: eventname)
									ifTrue: [eventname]
									ifFalse: [
												LRPErrorHandler instance
														varNotFound: eventname
														transition: aTransition.
												nil ]]
		ifFalse: [value := eventname ].
	aTransition maxTime: value.
	aScope addTransition: aTransition.
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretTransition: aTransition withScope: aScope [
			 
	aScope addTransition: aTransition.
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretVariable: aVariable withScope: aScope andVariableCompare: comp [

	"first check if the parent scope does not define the var"
	(aScope inheritsVariable: aVariable name)
		ifTrue: [
			LRPErrorHandler instance duplicateVar: aVariable name.
			^ self].

	comp isNil ifFalse: [ 
		(comp isVariableUnchanged: aVariable)
			ifTrue: ["copy over the old value and don't initialize later"
				aVariable doNotInitialize.
				aScope addVariable: aVariable with: (comp getVariable: aVariable name).
				^self]].
			
	"treat this as a new variable that should be initialized"
	aVariable doInitialize.
	aScope addVariable: aVariable
				with: (self interpretBlock: aVariable value withScope: aScope).
	^self
]

{ #category : #'interpret-nodes' }
LRPInterpreter >> interpretWildcardTransition: aTransition withScope: aScope [
	
	aScope addTransition: aTransition.
]

{ #category : #'program - testing' }
LRPInterpreter >> isFirstExecution [
	^runningMachines isEmpty.
]

{ #category : #'userinterface api' }
LRPInterpreter >> jumpTo: aLRPState [
	 
	self changeToState: (self findCorrespondingState: aLRPState) withActions: false.
]

{ #category : #executing }
LRPInterpreter >> mainLoop [
	
	[withLoop] whileTrue:[
		pause ifFalse: [self stepRun].
		self rate = 0 ifFalse:[(Delay forSeconds: 1/(self rate) asFloat)wait]. 
	]
	
]

{ #category : #interpret }
LRPInterpreter >> newProgram: aParsedProgram [
	"when called from the UI withLoop should actually be true"
	| oldPause |

	withLoop := false.

	compareAST newAST: aParsedProgram.
	
	runningAST := aParsedProgram.
	
	oldPause := pause.
	self pauseProcess.
	self restartOrContinue. 
	self pauseInterpreter: oldPause.

	
]

{ #category : #'userinterface api' }
LRPInterpreter >> newProgramForUI: aLRPProgram [

	| oldPause ast |

	withLoop := true.

	ast := aLRPProgram ast.
	ast addAll: aLRPProgram resolvedImports.

	compareAST newAST: ast.	
	runningAST := ast.
	
	oldPause := pause.
	self pauseProcess.
	self restartOrContinue. 
	self pauseInterpreter: oldPause.	
]

{ #category : #'userinterface notify' }
LRPInterpreter >> notifyHighlightState: aLRPState [

	ui ifNotNil:[ui highlightState: aLRPState].
	
	self announcer 
		announce: (LRPChangeStateAnnouncement new
						currentState: aLRPState;
						yourself).
]

{ #category : #'userinterface notify' }
LRPInterpreter >> notifyHighlightTransition: aLRPTransition [

	ui ifNotNil:[ui highlightTransition: aLRPTransition]
]

{ #category : #'program - comparison' }
LRPInterpreter >> numAddedMachines [
	"convenience method for the tests: number of added machines"
	^compareAST addedMachines size
]

{ #category : #'program - comparison' }
LRPInterpreter >> numRemovedMachines [
	"convenience method for the tests: number of removed machines"
	^compareAST removedMachines size
]

{ #category : #accessing }
LRPInterpreter >> parser [
	^parser ifNil: [ parser := LRPParser compiledParser]
]

{ #category : #accessing }
LRPInterpreter >> pause [
	^ pause
]

{ #category : #accessing }
LRPInterpreter >> pause: anObject [
	pause := anObject
]

{ #category : #'userinterface api' }
LRPInterpreter >> pauseInterpreter: aBoolean [
	
	aBoolean
		ifTrue:[self pauseProcess ]
		ifFalse:[self resumeProcess].
]

{ #category : #'program - processing' }
LRPInterpreter >> pauseProcess [
	
	pause := true.
]

{ #category : #accessing }
LRPInterpreter >> program [
	compareAST ifNil: [ ^nil ].
	^compareAST newAST
]

{ #category : #accessing }
LRPInterpreter >> rate [
	^ rate
]

{ #category : #accessing }
LRPInterpreter >> rate: anObject [
	rate := anObject
]

{ #category : #'force changes' }
LRPInterpreter >> recursivelySetState: aLRPState withActions: actBoolean spawn: spawnBoolean [
	|machine|
	
	machine := aLRPState container.
	machine container isNil
	ifTrue: [ runningMachines add: machine ]
	ifFalse: [ "we are not yet in the root machine"
		self recursivelySetState: machine container withActions: actBoolean spawn: false.].
	"this adds my machine to my container if it is not nil"
	self setCurrentState: aLRPState withActions: actBoolean spawn: spawnBoolean.
]

{ #category : #'adding - removing' }
LRPInterpreter >> removeRunningMachine: aMachineName [
	
	runningMachines removeAllSuchThat: [ :machine| machine name = aMachineName ]
	
]

{ #category : #'userinterface api' }
LRPInterpreter >> removedMachines [
	^compareAST removedMachines
]

{ #category : #'userinterface api' }
LRPInterpreter >> restartFromUI: aParsedProgram [
	"this is a temporary hack to make code sent from the UI work."

	compareAST clear.
	self newProgramForUI: aParsedProgram
]

{ #category : #'live program' }
LRPInterpreter >> restartInterpreter [
	restarted := true.
	self terminateProcess.
	"need to reset init state of all machines
	otherwise they will not be spawned in the interpret:"
	runningMachines do: [:machine | machine initState: nil ].
	runningMachines := OrderedCollection new.
	self interpret: runningAST.
]

{ #category : #'live program' }
LRPInterpreter >> restartOrContinue [

	self isFirstExecution
		ifTrue:[ self restartInterpreter]
		ifFalse:[ |exec oldMachines |
			oldMachines := runningMachines.
			"patch: we need an empty collection for the interpret: command to work"
			runningMachines := OrderedCollection new.
			
			exec := withExecution.
			withExecution := false.
			
			self interpret: runningAST.
		
			withExecution := exec.

			(self updateCurrentStaTXWith: oldMachines)
				ifTrue:[restarted := false.] 
				ifFalse:[self restartInterpreter].	
		]
]

{ #category : #accessing }
LRPInterpreter >> restarted [
	^ restarted
]

{ #category : #'program - processing' }
LRPInterpreter >> resumeProcess [
	
	pause := false.
]

{ #category : #executing }
LRPInterpreter >> runMainLoop [
	withExecution
		ifTrue:[
			withLoop 
				ifTrue:[ runningProcess := [self mainLoop] fork]
				ifFalse:[self mainLoop].
		]		

	
]

{ #category : #accessing }
LRPInterpreter >> runningMachine [
	"backward compatibility"
	^ runningMachines ifEmpty: [nil] ifNotEmpty: [runningMachines first]
]

{ #category : #accessing }
LRPInterpreter >> runningMachines [
	^ runningMachines
]

{ #category : #accessing }
LRPInterpreter >> runningProcess [
	^ runningProcess
]

{ #category : #accessing }
LRPInterpreter >> runningProcess: anObject [
	runningProcess := anObject
]

{ #category : #accessing }
LRPInterpreter >> scope [
	^ scope
]

{ #category : #accessing }
LRPInterpreter >> scope: anObject [
	scope := anObject
]

{ #category : #'force changes' }
LRPInterpreter >> setCurrentState: aLRPState withActions: aBoolean spawn: anotherBoolean [
	|machine|
	machine := aLRPState container.
	self runningMachine 
		ifNil: [self spawn: machine name in: aLRPState name withScope:scope ].
	machine setCurrentState: aLRPState name actions: aBoolean spawn: anotherBoolean interpreter: self.
	machine container ifNotNil:[machine container runningMachines add: machine]
]

{ #category : #'initialize-release' }
LRPInterpreter >> setupBridge [
	|bridges|
	
	bridges := LRPAbstractBridge allSubclasses.
	bridges isEmpty
		ifTrue: [ bridgeInstance := LRPAbstractBridge uniqueInstance ]
		ifFalse: [ bridgeInstance := bridges first uniqueInstance 	]
]

{ #category : #executing }
LRPInterpreter >> spawn: machineName in: initState withScope: aScope [
	|machine|
	machine := self addRunningMachine: machineName scope: aScope.
	machine ifNil: [ ^self ].
	machine initState: initState.
	machine initializeVariables.
	
]

{ #category : #'initialize-release' }
LRPInterpreter >> start: aProgram ui: aLRPUI [
	
	ui := (aLRPUI openOnInterpreter: self).
	ui window value whenClosedDo: [runningProcess ifNotNil: #terminate].
	self bridgeInstance openInterfaceFor: self
	
]

{ #category : #executing }
LRPInterpreter >> stepRun [

	runningMachines do: [ :machine| machine stepRunFor: self]
]

{ #category : #'userinterface api' }
LRPInterpreter >> stop [

	self terminateProcess.
	self cleanUp.
]

{ #category : #'program - processing' }
LRPInterpreter >> terminateProcess [
	
	runningProcess ifNotNil:[runningProcess terminate].
]

{ #category : #'userinterface api' }
LRPInterpreter >> transitionTo: aLRPState [

	self changeToState: (self findCorrespondingState: aLRPState) withActions: true.
]

{ #category : #accessing }
LRPInterpreter >> ui [
	^ ui
]

{ #category : #accessing }
LRPInterpreter >> ui: anObject [
	ui := anObject
]

{ #category : #'live program' }
LRPInterpreter >> update: aMachine withCurrentState: oldState withCurrentTransition: oldTransition [
	| newState |
	"recursively update the current state and last triggered transition
	 of the  machine to be those of the previous machine.
	 Return false if the machine was changed, i.e. the interpreter should reset."
	
	"There is no old current state"
	oldState ifNil: [^false].
	aMachine compareStates ifNil: [^false].
	
	"Currently active state was removed"
	(aMachine compareStates removed anySatisfy: [:aState| aState name = oldState name]) ifTrue: [^false].

	newState := aMachine state: oldState name.
	
	"Currently active state was modified"		
	(newState equalActions: oldState ) ifFalse:[^false].
	
	oldTransition ifNotNil: [ 
			aMachine compareTransitions removed 
				detect: [:aTransition| aTransition name = oldTransition name] 			
				ifNone: [	aMachine setTriggeredTransition: (oldTransition name)]].
				
	aMachine setCurrentState: (oldState name) actions: false interpreter: self.
	
	"is there a nested machine"
	oldState hasNestedMachines 
				ifTrue:[
					"if it was removed, the state was modified"
					(aMachine currentState compareMachines removed
						anySatisfy:[:reMachine| reMachine name = oldState nestedMachine name])
						ifTrue:[^false]]
				"no nested machine, we're done"
				ifFalse: [^true].

	"recurse in every nested machine"
	^aMachine currentState updateAllRunningMachines:  oldState runningMachines with: self.

]

{ #category : #'live program' }
LRPInterpreter >> updateCurrentStaTXWith: oldMachines [
	^oldMachines allSatisfy: [ :machine | self updateCurrentStaTXWithMachine: machine ]

	
	
]

{ #category : #'live program' }
LRPInterpreter >> updateCurrentStaTXWithMachine: oldMachine [
	"Update the current state and last triggered transition
	 of the executing machine to be those of the old machine.
	 Return false if the the interpreter should reset."
	
	"doesnt have an old machine to update from"
	oldMachine ifNil:[^true].
	
	"old machine should be removed"
	(compareAST removedMachines anySatisfy:[:aMachine| aMachine name = oldMachine name])
		ifTrue:[ ^false].
		
	^self updateRunningMachineWith: oldMachine.

	
	
]

{ #category : #'live program' }
LRPInterpreter >> updateRunningMachineWith: oldMachine [
	
	|machine|
	
	self removeRunningMachine: oldMachine name.
	machine := self addRunningMachine: oldMachine name.
	
	^ self
		update: machine
		withCurrentState: oldMachine currentState
		withCurrentTransition: oldMachine triggeredTransition
]

{ #category : #'userinterface notify' }
LRPInterpreter >> varChanged: aVar [
	ui ifNotNil: [:theui | theui varChange: aVar inMachine: self runningMachine].
]

{ #category : #'userinterface api' }
LRPInterpreter >> variablesInScopeOf: aMachine [
	"returns an ordered collection of bindings"
	"each binding is an association variable AST node -> valueholder"
	
	|variables|
	
	variables := OrderedCollection new.
	"Variables of the root"
	variables addAll: (runningAST select: [:aNode| aNode class = LRPVariable ]).
	"variables of the machine and parent"
	variables addAll: aMachine varsAndParentVars.
	
	"If the variable has not been initialized it must still be visualized.
	Only remove synthetic variables"
	^variables
		reject: [ :aVar | aVar synthetic ]
		thenCollect: [ :aVar| (aVar -> (aMachine scope getVar: aVar name))]
]

{ #category : #accessing }
LRPInterpreter >> withLoop [
	^ withLoop
]

{ #category : #accessing }
LRPInterpreter >> withLoop: anObject [
	withLoop := anObject
]
