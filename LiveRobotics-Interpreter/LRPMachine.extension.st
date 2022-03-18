Extension { #name : #LRPMachine }

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> changeCurrentState: aState interpreter: anInterpreter [

	self currentState onexitExecution.
	self setCurrentState: aState actions: true interpreter: anInterpreter.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> compareStates [
	^ compareStates
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> compareTransitions [
	^ compareTransitions
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> compareVariables [
	^ compareVariables
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> currentState [
	^ currentState
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> currentState: anObject [
	currentState := anObject
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> elementsToSearchFullName [
	
	^self states
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> event: anEventName [
	
	|events|
	
	events := self events select:[:event| event name = anEventName].
	^events isEmpty
		ifTrue:[nil]
		ifFalse:[events first]
	
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> finish [
	self finishWithAction: true.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> finishWithAction: aBoolean [

	aBoolean
		ifTrue:[
			self currentState onexitExecution.
			self currentState cleanNestedMachine.
			]
		ifFalse: [self currentState cleanNestedMachineNoExecution].
	self initState: nil.
	self currentState: nil. 
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> forgetCompare [
	
	compareStates := nil.
	compareTransitions := nil.
	compareVariables := nil.

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> fullName [
	self container isNil 
		ifTrue: [ ^'/',self name]
		ifFalse: [^self container fullName, '/', self name ].
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> hasCurrentState [

	^self currentState isNotNil.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> initOnState: aStateName scope: aLRPScope interpreter: anInterpreter [
	"this is NOT run on top level machine spawn"

	"a bit of optimisation"
	self variables size = 0 ifFalse: [
		self allVariables do: [ :aVar | anInterpreter interpretVariable: aVar withScope: self scope andVariableCompare: self compareVariables].
		self initializeVariables].

	currentState := nil.
	self initState: aStateName.
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> initState [
	^ initState
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> initState: anObject [
	initState := anObject
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> initializeVariables [
	self variables do: [:var| self scope initializeVariable: var]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretMachine: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> machinesInScope [
	| retval |
	retval := OrderedCollection new.
	self container isNil
		ifTrue: [ retval addAll: (self scope rootAST select: [:item|
							(item class = LRPMachine) and: [ item ~= self ]])]
		ifFalse: [
			retval addAll: (self container machines reject: [:machine| machine = self]).
			retval addAll: self container container machinesInScope ].
	
	^retval
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> matchedTransition [
	
	^self matchedTransitionFromState: currentState.
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> matchedTransitionFromState: aState [
	"match a transition with an event from the state aState
	return the matched transition if there is any, nil is there is not transition"
	
	|txs |
	"every transition from aState"
	txs := self allTransitions select: [ :transition| transition isFromState: aState].
	
	"check the events on every transition, until one event return true"
	^txs detect: 
		[:tx| 
			(tx checkWith: self) and:
			[
				(self state: tx to) 
					ifNil: [LRPErrorHandler instance stateNotFound: tx to machine: self name. false] 
					ifNotNil:[true]
			]	
		] ifNone: [nil].
	
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> prepareChangesWith: anOldMachine [
	
	compareStates := LRPCompareNodes
			old: anOldMachine states
			new: self states
			oldRoot: anOldMachine.
	compareStates propagateChanges.
	
	compareTransitions := LRPCompareNodes
			old: anOldMachine allTransitions
			new: self allTransitions
			oldRoot: anOldMachine.

	compareVariables := LRPCompareNodes
		old: anOldMachine allVariables
		new: self allVariables
		oldRoot: anOldMachine.

	anOldMachine forgetCompare
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> scope [
	^ scope
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> scope: anObject [
	scope := anObject
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> setCurrentState: aState actions: actBool interpreter: anInterpreter [
	|newCurrentState|
		
	newCurrentState := self state: aState.

	newCurrentState ifNil: [^ LRPErrorHandler instance stateNotFound: aState machine: self name].
	self currentState: newCurrentState.
	newCurrentState startTime: Time now asMilliSeconds.
	
	"when actBool is false we are migrating state and not interpreting"
	actBool ifTrue:[
		anInterpreter notifyHighlightState: newCurrentState.
		newCurrentState onentryExecutionSpawn: true interpreter: anInterpreter.
	].
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> setCurrentState: aState actions: actBool spawn: spawnBool interpreter: anInterpreter [
	|newCurrentState|
	"This is only used in forced state transitions: transition to and jump to"
		
	newCurrentState := self state: aState.

	newCurrentState ifNil: [^ LRPErrorHandler instance stateNotFound: aState machine: self name].
	self currentState: newCurrentState.
	newCurrentState startTime: Time now asMilliSeconds.

	anInterpreter notifyHighlightState: newCurrentState.	

	"when actBool is false we are jumping instead of doing a transition"
	actBool ifTrue: [ newCurrentState onentryExecutionWith: anInterpreter].
	"at the state we jump/transition to, we need to execute spawn statements, if any"
	spawnBool ifTrue: [ newCurrentState onentrySpawnWith: anInterpreter].

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> setTriggeredTransition: aString [
	
	triggeredTransition := self allTransitions
		detect: [:aTransition| aTransition name = aString]
		ifNone: [nil]
	

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> startTimeRunningState [

	^self currentState startTime.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> state: aStateName [
	
	^self states detect: [:state| state name = aStateName] ifNone: [  nil ].

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> stepRunFor: anInterpreter [
	"a step in the execution of a machine could be one of the followings actions:
	-If there is no state initialize the variables and go to the initial state
	-Change the current state via a transition matching the actual state
	-Execute ''running action'' when there is an action and there is no transition matching the current state
	"
	
	|transition|
	
	self currentState isNil
		ifTrue: [	self setCurrentState: self initState actions: true interpreter: anInterpreter]
		ifFalse: [  
			transition := self matchedTransition.
			transition isNil
				ifTrue:[
					self currentState runningExecutionFor: anInterpreter .
				]
				ifFalse:[
					triggeredTransition := transition.
					anInterpreter notifyHighlightTransition: triggeredTransition.
					self 	changeCurrentState: transition to interpreter: anInterpreter.
				]
		].

]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> triggeredTransition [
	^ triggeredTransition
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPMachine >> weakEqualNode: aMachine [

	^self name = aMachine name.
]
