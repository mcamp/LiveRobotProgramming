Extension { #name : #LRPState }

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> addRunningMachineNamed: aString [

	|machineToAdd|

	machineToAdd := self machineNamed: aString.
			
	machineToAdd ifNotNil: [
		machineToAdd initState ifNotNil: [ LRPErrorHandler instance machineNotSpawnable: aString. ^nil]	.
		self runningMachines add: machineToAdd ].
	^machineToAdd.
		
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> blocksOnentry [
	^ self onInterpretedActions: LRPOnEntry.

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> blocksOnexit [
   ^self onInterpretedActions: LRPOnExit
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> blocksRunning [
	^self onInterpretedActions: LRPRunning
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> cleanNestedMachine [
	self hasNestedMachines ifTrue:[
		self runningMachines do: [ :machine| machine finishWithAction: true ].	
	].
	self runningMachines removeAll.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> cleanNestedMachineNoExecution [
	self hasNestedMachines ifTrue:[
		self runningMachines do: [ :machine| machine finishWithAction: false ].	
	].
	self runningMachines removeAll.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> compareMachines [
	^ compareMachines
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> elementsToSearchFullName [
	
	^self machines
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> equalActions: aState [

	^(self equalOnentries: aState) and: [ (self equalOnexits: aState) and:[self equalRunnings:aState]]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> equalActions: aSymbol state: aState [

	|selfActions anotherActions|
	
	selfActions := self perform: aSymbol.
	anotherActions := aState perform: aSymbol.
	
	"if both empty, they have not changed"
	(selfActions isEmpty and:[anotherActions isEmpty]) ifTrue:[^true].
	
	"if different sizes, they have changed"
	(selfActions size = anotherActions size) ifFalse: [^false ].
	
	
	
	"all elements are the same, order matters"
	selfActions with: anotherActions do: [:selfAction :anotherAction|
		"if different class, they have changed"
		"(selfActions class = anotherActions class) ifFalse:[^false]."
		(selfAction equalNode: anotherAction) ifFalse: [ ^false ]
	].
	^ true
	
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> equalOnentries: aState [
	^self equalActions: #onentry state: aState
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> equalOnexits: aState [
	^self equalActions: #onexit state: aState
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> equalRunnings: aState [
	^self equalActions: #running state: aState
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> forgetCompare [

	compareMachines := nil.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> hasNestedMachines [
	^self runningMachines isNotEmpty.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretState: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> machineNamed: aString [
	^self machines
			detect: [:machine | machine name = aString ] 
			ifNone: [	self container machinesInScope
							detect: [ :machine | machine name = aString ]
							ifNone: [LRPErrorHandler instance machineNotFound: aString. nil]].
		
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onInterpretedActions: anAction [
	
	^(self onactions: anAction) collect: [:action| action interpretedBlock]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onactions: anAction [

	^self body select:[:item | item class = anAction].
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onentry [
	^ self onactions: LRPOnEntry.

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onentryExecutionSpawn: aBoolean interpreter: anInterpreter [
	
	self blocksOnentry do: [:action|
		action isBlock
			ifTrue: [ action value ]
			ifFalse: [ aBoolean ifTrue: [ self spawnNestedMachine: action with: anInterpreter ]]
	].
	

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onentryExecutionWith: anInterpreter [
	
	self blocksOnentry do: [:action|
		action isBlock	ifTrue: [ action value ]].
	

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onentrySpawnWith: anInterpreter [
	
	self blocksOnentry do: [:action|
		action isBlock ifFalse: [ self spawnNestedMachine: action with: anInterpreter ]
	].
	

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onexit [
   ^self onactions: LRPOnExit
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> onexitExecution [
	self cleanNestedMachine.
   self blocksOnexit do: [:block| block value].
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> prepareChangesWith: anOldState [

	compareMachines := LRPCompareNodes
		old: anOldState machines
		new: self machines
		oldRoot: anOldState.

	compareMachines propagateChanges.
	anOldState forgetCompare.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> running [
	^self onactions: LRPRunning
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> runningExecutionFor: anInterpreter [
	self blocksRunning do: [:block| block value].
	self hasNestedMachines ifTrue:[ 
		self runningMachines do: [:machine| machine stepRunFor: anInterpreter ]
	].
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> runningMachines [
	^ runningMachines ifNil: [ runningMachines := OrderedCollection new ]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> spawnNestedMachine: aSpawn with: anInterpreter [
	
	|machine|
	machine := self addRunningMachineNamed: aSpawn machine.
	machine ifNil:[^self].
	machine initOnState: aSpawn state scope: container scope interpreter: anInterpreter.
	
	machine stepRunFor: anInterpreter.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> startTime [
	^ startTime
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> startTime: anObject [
	startTime := anObject
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> updateAllRunningMachines: oldMachines with: anInterpreter [
	 
	self runningMachines removeAll.
	^oldMachines allSatisfy: [:oldMachine| |newMachine|
		newMachine := self addRunningMachineNamed: oldMachine name.
		newMachine
			ifNil: [ false ]
			ifNotNil: [  
				anInterpreter
					update: newMachine
					withCurrentState: oldMachine currentState
					withCurrentTransition: oldMachine triggeredTransition]
	]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPState >> weakEqualNode: aState [

	^self name = aState name.
]
