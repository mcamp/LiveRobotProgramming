Class {
	#name : #LRPCompareProgramTests,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'interpreter',
		'oldProgram',
		'newProgram'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #running }
LRPCompareProgramTests >> setUp [
	parser := LRPParser compiledParser.
	interpreter := LRPInterpreter new.
]

{ #category : #running }
LRPCompareProgramTests >> tearDown [
	super tearDown.
	interpreter stop.
	LRPCodeGenerator removeAllClasses
]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedMachines [

	oldProgram := '
		(machine blah)
	'.
	newProgram := '
		(machine blah)
		(machine bleh)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter firstAddedMachine name equals: 'bleh'.
	self assert: interpreter numAddedMachines equals: 1.
	

]

{ #category : #'new program' }
LRPCompareProgramTests >> testAddedMachinesNewProgram [

	oldProgram := '
		(machine blah)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	
	self assert: interpreter firstAddedMachine name equals: 'blah'.
	self assert: interpreter numAddedMachines equals: 1.
	

]

{ #category : #'nested machines' }
LRPCompareProgramTests >> testAddedNestedMachines [
	| state |
	
	oldProgram := '
		(machine blah
			(state one
				(machine nested1)
			)
		)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested1)
				(machine nested2)
			)
		)
	'.
	

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	state := interpreter firstNewMachine state: 'one'.

	self assert: state name = 'one'.
	self assert: state compareMachines added first name = 'nested2'.
	self assert: state compareMachines added size = 1.
	

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testAddedOnentryCurrentState [

	oldProgram := '
		(machine blah
			(state one
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onentry [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testAddedOnexitCurrentState [

	oldProgram := '
		(machine blah
			(state one

			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onexit [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedRemovedMachines [

	oldProgram := '
		(machine blah)
		(machine bleh)
	'.
	newProgram := '
		(machine blah)
		(machine foo)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter firstRemovedMachine name equals: 'bleh'.
	self assert: interpreter firstAddedMachine name equals: 'foo'.
	

]

{ #category : #'nested machines' }
LRPCompareProgramTests >> testAddedRemovedNestedMachines [
	| state |

	oldProgram := '
		(machine blah
			(state one
				(machine nested1)
				(machine nested3)
			)
		)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested1)
				(machine nested2)
			)
		)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	state := interpreter firstNewMachine state: 'one'.
	self assert: state name = 'one'.
	self assert: state compareMachines added first name = 'nested2'.
	self assert: state compareMachines removed first name = 'nested3'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedRemovedState [
	|machine|
	
	oldProgram := '
		(machine blah
			(state one)
			(state two)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state three)
		)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareStates removed first name = 'two'.
	self assert: machine compareStates added first name = 'three'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedRemovedTransitions [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps two -> three t2)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added first name = 't2'.
	self assert: machine compareTransitions removed first name = 't1'.
	

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testAddedRunningCurrentState [

	oldProgram := '
		(machine blah
			(state one
	
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(running [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedState [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state three)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareStates added size = 1.
	self assert: machine compareStates added first name = 'three'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testAddedTransitions [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added first name = 't2'.
	self assert: machine compareTransitions added size = 1.
	

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentAddedNestedMachine [
	
	oldProgram := '
		(machine blah
			(state one
				
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
				)
			)
		)
		(spawn blah one)
	'.
		
	interpreter newProgram: (parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name = 'one'.
	self deny: interpreter runningMachine currentState hasNestedMachines .

	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self deny: interpreter runningMachine currentState hasNestedMachines .

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentAddedNestedState [
	
	oldProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
					(state bar)
					(eps foo -> bar t1)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: interpreter runningMachine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name 
			equals: 'foo'.
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: interpreter runningMachine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name
			equals: 'foo'.

	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: interpreter runningMachine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name
			equals: 'bar'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentAddedState [
	
	oldProgram := '
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals:  'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'two'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentAddedTransition [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'two'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentAddedVariable [
	
	oldProgram := '
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(var bar := [1])
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	interpreter newProgram: (parser parse: newProgram).
	self assert: (interpreter runningMachine scope getVar: 'bar') = 1.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentChangedSpawnMachine [
	"In concurrency, we do not only keep the previous machine even when there is no spawn, but also we spawn the new machines"
	
	|machineBlah machineBleh|
	
	oldProgram := '
		(machine blah
			(state one)
		)
		(machine bleh
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
		)
		(machine bleh
			(state two)
		)
		(spawn bleh two)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachines size equals: 2.
	
	machineBlah := interpreter runningMachines detect: [ :machine| machine name = 'blah' ].
	machineBleh := interpreter runningMachines detect: [ :machine| machine name = 'bleh' ].
	self assert: machineBlah currentState name equals: 'one'.
	self assert: machineBleh currentState isNil.

	interpreter stepRun.
	machineBlah := interpreter runningMachines detect: [ :machine| machine name = 'blah' ].
	machineBleh := interpreter runningMachines detect: [ :machine| machine name = 'bleh' ].
	self assert: machineBlah currentState name equals: 'one'.
	self assert: machineBleh currentState name equals: 'two'.
]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentChangedTransitionWithSameName [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(eps two -> one t1)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentChangedTransitionWithoutName [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(eps two -> one)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentDeletedTriggeredTransition [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'two'.
	
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name = 'two'.
	self assert: interpreter runningMachine triggeredTransition isNil.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentErrorBlock [

	oldProgram := '
		(var foo := [1])
		(machine blah
			(state one
				(running [ foo := 1 + 1 ])
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(running [ foo := 1 + 1 ])
			)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name = 'one'.
	self deny: interpreter runningMachine currentState hasNestedMachines .

	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self deny: interpreter runningMachine currentState hasNestedMachines .

]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentExplicitMachineVariable [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [5])
			(state one
				(onentry [bar := 5 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.
	
	interpreter stepRun.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 10.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentExplicitModifyChainedVariable [

	oldProgram := '
		(var foo := [42])
		(var bar := [foo])
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.
	newProgram := '
		(var foo := [43]) 
		(var bar := [foo])
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter scope getVar: 'bar') = 42.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter scope getVar: 'foo') = 43.
	self assert: (interpreter scope getVar: 'bar') = 42.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentExplicitModifyVariable [

	oldProgram := '
		(var foo := [42])
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.
	newProgram := '
		(var foo := [43]) 
		(machine blah
			(state one)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter scope getVar: 'foo') = 42.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter scope getVar: 'foo') = 43.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentExplicitNestedMachineVariable [

	oldProgram := '
		(machine main
			(var bar := [1])
			(state one
				(machine nested
					(state nestedState
						(onentry [bar := 1 + bar])
					)
				)
				(onentry (spawn nested nestedState))
			)
		)
		(spawn main one)'.
		
	newProgram := '
		(machine main
			(var bar := [5])
			(state one
				(machine nested
					(state nestedState
						(onentry [bar := 1 + bar])
					)
				)
				(onentry (spawn nested nestedState))
			)
		)
		(spawn main one)'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	self assert: (interpreter runningMachine currentState 
						runningMachines first scope getVar: 'bar')
			equals: 2.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 5.
	self assert: (interpreter runningMachine currentState 	
						runningMachines first scope getVar: 'bar')
			equals: 5.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentExplictVarAddSpawn [

	LRPTestSingleton instance: 0.
	oldProgram := '
	(var foo := [1])
	(machine m
		(var bar :=[2])
		(state s (onentry [LRPTestSingleton instance:(foo + bar)]))
	)'.
	newProgram := '
	(var foo := [1])
	(machine m
		(var bar :=[2])
		(state s (onentry [LRPTestSingleton instance:(foo + bar)]))
	)
	(spawn m s)'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	self assert: LRPTestSingleton instance = 0.
	interpreter stepRun.
	"if this fails it probably is because there was an error in executing the onentry block"
	self assert: LRPTestSingleton instance = 3.
	
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentImplicitMachineVariable [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 5 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.
		
	interpreter stepRun.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 7.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentImplicitModifyVariable [

	oldProgram := '
		(var foo := [42])
		(machine blah
			(state one
				(running [foo := 43])
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(var foo := [42]) 
		(machine blah
			(state one
				(running [foo := 43])
			)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'foo') = 42.
	
	interpreter stepRun.
	self assert: (interpreter runningMachine scope getVar: 'foo') = 43.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'foo') = 43.
]

{ #category : #variables }
LRPCompareProgramTests >> testConsistentImplicitNestedMachineMachineVariable [

	oldProgram := '
		(machine main
			(var bar := [1])
			(state one
				(machine nested
					(state nestedState
						(onentry [bar := 1 + bar])		
					)
				)
				(onentry (spawn nested nestedState))
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn main one)
	'.
	newProgram := '
		(machine main
			(var bar := [1])
			(state one
				(machine nested
					(state nestedState
						(onentry [bar := 5 + bar])		
					)
				)
				(onentry (spawn nested nestedState))
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn main one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 1.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name 
			equals: 'nestedState'.
	self assert: (interpreter runningMachine currentState 
						runningMachines first scope getVar: 'bar')
			equals: 2.
		
	interpreter stepRun.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 7.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name 
			equals: 'nestedState'.
	self assert: (interpreter runningMachine currentState 
						runningMachines first scope getVar: 'bar')
			equals: 7.
	
]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentModifyState [

	oldProgram := '
		(machine blah
			(state one)
			(state two
				(onentry [1+1])
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two
				(onentry [1+2])
			)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'two'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentNestedTriggeredTransition [

	oldProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
					(state bar)
					(eps foo -> bar t2)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
					(state bar)
					(eps foo -> bar t2)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: interpreter runningMachine currentState hasNestedMachines.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name
			equals: 'bar'.	
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: interpreter runningMachine currentState hasNestedMachines.
	self assert: interpreter runningMachine currentState 
						runningMachines first currentState name 
			equals: 'bar'.
]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentRemovedState [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentRemovedTransition [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.

]

{ #category : #'harmless edits' }
LRPCompareProgramTests >> testConsistentTriggeredTransition [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'two'.
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: interpreter runningMachine currentState name equals: 'two'.
	self assert: interpreter runningMachine triggeredTransition name equals: 't1'.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testEditOnentryCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onentry [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onentry [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testEditOnentrySpawnAgainCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onentry (spawn machine state2))
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onentry (spawn machine state))
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testEditOnentrySpawnCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onentry [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onentry (spawn machine state))
			)
			(state two)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testEditOnexitCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onexit [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(onexit [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter := LRPInterpreter new.
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testEditRunningCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(running [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(running [1 + 2])
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testModifiedFromStateTransition [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps three -> two t1)
			(eps two -> three t2)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added size = 1.
	self assert: machine compareTransitions added first from = 'three'.
	self assert: machine compareTransitions removed size = 1.
	self assert: machine compareTransitions removed first from = 'one'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testModifiedFromStateTransitionWithoutName [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two)
			(eps two -> three)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps three -> two)
			(eps two -> three)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added size = 1.
	self assert: machine compareTransitions added first from = 'three'.
	self assert: machine compareTransitions removed size = 1.
	self assert: machine compareTransitions removed first from = 'one'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testModifiedToStateTransition [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> twothree t1)
			(eps two -> three t2)
		)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added size = 1.
	self assert: machine compareTransitions added first to = 'twothree'.
	self assert: machine compareTransitions removed size = 1.
	self assert: machine compareTransitions removed first to = 'two'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testModifiedToStateTransitionWithoutName [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two)
			(eps two -> three)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> twothree)
			(eps two -> three)
		)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added size = 1.
	self assert: machine compareTransitions added first to = 'twothree'.
	self assert: machine compareTransitions removed size = 1.
	self assert: machine compareTransitions removed first to = 'two'.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testNoMachineChange [

	oldProgram := '
		(machine blah)
	'.
	newProgram := '
		(machine blah)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter numAddedMachines equals: 0.
	self assert: interpreter numRemovedMachines equals: 0.
	
]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testNoStateChange [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
		)
	'.
	newProgram := '
		(machine blah
			(state one)	
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareStates added isEmpty.
	self assert: machine compareStates removed isEmpty.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testNoTransitionChange [
	| machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions added isEmpty.
	self assert: machine compareTransitions removed isEmpty.
	

]

{ #category : #'nested machines' }
LRPCompareProgramTests >> testNothingNestedMachines [
	|state|

	oldProgram := '
		(machine blah
			(state one
				(machine nested1)
			)
		)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested1)	
			)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	state := interpreter firstNewMachine state: 'one'.
	self assert: state name = 'one'.
	self assert: state compareMachines added isEmpty.
	self assert: state compareMachines removed isEmpty.
	

]

{ #category : #'new program' }
LRPCompareProgramTests >> testRadicalProgramChange [

	oldProgram := '
		(machine blah (state one))
		(spawn blah one)'.
		
	newProgram := '(machine foo (state two))
						(spawn foo two)'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	
	interpreter newProgram: (parser parse: newProgram).

	self assert: interpreter numRemovedMachines equals: 1.
	self assert: interpreter firstRemovedMachine name equals: 'blah'.
	self assert: interpreter numAddedMachines equals: 1.
	self assert: interpreter firstAddedMachine name equals: 'foo'.
	
	interpreter stepRun.
	self assert: interpreter runningMachine name equals: 'foo'.
	
	interpreter newProgram: 	(parser parse: '(machine x)').
	interpreter stepRun.
	
	"there is no spawn statement"
	interpreter stepRun.
	self assert: interpreter runningMachine isNil
]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemoveCurrentMachine [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine bleh
			(state one)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter := LRPInterpreter new.
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemoveCurrentNestedMachine [

	oldProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)	
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
		
	interpreter stepRun.
	
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: interpreter runningMachine currentState hasNestedMachines.
	self assert: interpreter runningMachine currentState runningMachines first currentState name = 'foo'.
	
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemoveCurrentNestedState [

	oldProgram := '
		(machine blah
			(state one
				(machine nested
					(state foo)
					(state bar)
				)
				(onentry (spawn nested foo))
			)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested
					(state bar)
				)
				(onentry (spawn nested foo))	
			)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
		
	interpreter stepRun.
	
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: interpreter runningMachine currentState hasNestedMachines.
	self assert: interpreter runningMachine currentState runningMachines first currentState name = 'foo'.
	
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemoveCurrentState [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'nested machines' }
LRPCompareProgramTests >> testRemoveNotLexicallyNestedMachines [

	oldProgram := '
		(machine foo (state s) )
		(machine bar
			(state t (onentry (spawn foo s))))
		(spawn bar t)
	'.
	newProgram := '
		(machine bar
			(state t (onentry (spawn foo s))))
		(spawn bar t)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine currentState runningMachines first name equals: 'foo'.
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.
	self assert: interpreter runningMachine equals: nil.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testRemovedMachines [

	oldProgram := '
		(machine blah)
		(machine bleh)
	'.
	newProgram := '
		(machine blah)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter firstRemovedMachine name equals: 'bleh'.
	self assert: interpreter numRemovedMachines equals: 1.
	

]

{ #category : #'nested machines' }
LRPCompareProgramTests >> testRemovedNestedMachines [
	|state|

	oldProgram := '
		(machine blah
			(state one
				(machine nested1)
				(machine nested2)
			)
		)
	'.
	newProgram := '
		(machine blah
			(state one
				(machine nested1)	
			)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	state := interpreter firstNewMachine state: 'one'.
	self assert: state name = 'one'.
	self assert: state compareMachines removed first name = 'nested2'.
	self assert: state compareMachines removed size = 1.
	

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemovedOnentryCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onentry [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemovedOnexitCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(onexit [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
	
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testRemovedRunningCurrentState [

	oldProgram := '
		(machine blah
			(state one
				(running [1 + 1])
			)
			(state two)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one
				
			)
			(state two)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.

	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testRemovedState [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
		)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareStates removed first name = 'two'.
	self assert: machine compareStates removed size = 1.
	

]

{ #category : #'change reporting' }
LRPCompareProgramTests >> testRemovedTransitions [
	|machine|

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
	'.
	newProgram := '
		(machine blah
			(state one)
			(state two)
			(state three)
			(eps one -> two t1)
			
		)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter newProgram: (parser parse: newProgram).
	
	machine := interpreter firstNewMachine.
	self assert: machine name = 'blah'.
	self assert: machine compareTransitions removed first name = 't2'.
	self assert: machine compareTransitions removed size = 1.
	

]

{ #category : #'harmful edits' }
LRPCompareProgramTests >> testTransitionRemoveCurrentState [

	oldProgram := '
		(machine blah
			(state one)
			(state two)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(state one)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	interpreter newProgram: 	(parser parse: oldProgram).
		
	interpreter stepRun.
	interpreter stepRun.
	
	self assert: interpreter runningMachine currentState name = 'two'.
	
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: interpreter restarted.

]

{ #category : #variables }
LRPCompareProgramTests >> testVarAddRemoveState [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).

	
	interpreter stepRun.
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.

	interpreter stepRun.

	self assert: (interpreter runningMachine currentState name) equals: 'two'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	
	interpreter stepRun.
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 3.

	interpreter newProgram: 	(parser parse: oldProgram).
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 3.


]

{ #category : #variables }
LRPCompareProgramTests >> testVarAddingState [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).

	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.
	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'two'.
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 3.

	
	interpreter newProgram: (parser parse: newProgram).
	
	self assert: (interpreter runningMachine scope getVar: 'bar') = 3.

	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'two'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 3.
]

{ #category : #variables }
LRPCompareProgramTests >> testVarChangesWSideEffects [

	LRPTestSingleton instance: 41.
	oldProgram := '
	(var foo := [LRPTestSingleton instance])
	(var bar := [LRPTestSingleton instance: (LRPTestSingleton instance + 1). foo+1])
	'.
	newProgram := '
	(var foo := [LRPTestSingleton instance])
	(var bar := [LRPTestSingleton instance: (LRPTestSingleton instance + 1). foo+1])
	(machine m)'.

	interpreter newProgram: 	(parser parse: oldProgram).
	self assert: (interpreter scope getVar: 'foo') = 41.
	interpreter newProgram: (parser parse: newProgram).
	self assert: (interpreter scope getVar: 'foo') = 41.

]

{ #category : #variables }
LRPCompareProgramTests >> testVarRemoveAddState [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).

	
	interpreter stepRun.
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	
	
	interpreter newProgram: (parser parse: newProgram).
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.

	interpreter stepRun.

	self assert: (interpreter runningMachine currentState name) equals: 'two'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.
	
	interpreter stepRun.
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 3.

	interpreter newProgram: 	(parser parse: oldProgram).
	self assert: (interpreter runningMachine currentState name) equals: 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 3.


]

{ #category : #variables }
LRPCompareProgramTests >> testVarRemovingState [

	oldProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(state three)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.
	newProgram := '
		(machine blah
			(var bar := [1])
			(state one
				(onentry [bar := 1 + bar])
			)
			(state two)
			(eps one -> two t1)
			(eps two -> one t2)
		)
		(spawn blah one)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).

	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name = 'one'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.
	
	
	interpreter newProgram: (parser parse: newProgram).
	interpreter stepRun.

	self assert: interpreter runningMachine currentState name = 'two'.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.
]

{ #category : #variables }
LRPCompareProgramTests >> testVarUpdateOfInactiveMachine [
	"doing a program update actually should also copy over states of machines that are not the current machine"
	| sstate |

	oldProgram := '
(machine foo
	(var top :=[false])
	(state s
		(machine bar
			(var x :=[0])
			(state ns
				(onentry [x:= x+1. top := true]))
		)
		(onentry (spawn bar ns)))
	(state t
		(onentry [top := false]))
	(on [top] s -> t)
	(on [top not] t -> s)
)
(spawn foo s)'.
	
	newProgram := '
(machine foo
	(var top :=[false])
	(state s
		(machine bar
			(var x :=[0])
			(state ns
				(onentry [x:= x+1. top := true]))
		)
		(onentry (spawn bar ns)))
	(state t
		(onentry [top := false]))
	(on [top] s -> t)
	(on [top not] t -> s)
)
(spawn foo s)
	'.

	interpreter newProgram: 	(parser parse: oldProgram).

	interpreter stepRun.
	"in state ns"
	sstate := interpreter runningMachine states first.
	self assert: sstate name equals: 's'.
	self assert: interpreter runningMachine currentState
						runningMachines first currentState name equals: 'ns'.
	self assert: ((sstate machines at: 1) scope getVar: 'x') equals: 1.
	
	interpreter stepRun.
	"in state t"
	self assert: interpreter runningMachine currentState name equals: 't'.
	self assert: ((sstate machines at: 1) scope getVar: 'x')equals: 1.
	
	interpreter newProgram: (parser parse: newProgram).
	"still in the same state, and the inactive machine variables have the right value"
	self assert: interpreter runningMachine currentState name equals: 't'.
	sstate := interpreter runningMachine states first.
	self assert: sstate name equals: 's'.
	self assert: ((sstate machines at: 1)  scope getVar: 'x')equals: 1.

]
