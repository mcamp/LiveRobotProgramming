Class {
	#name : #LRPInterpretationTests,
	#superclass : #LRPAbstractInterpretationTests,
	#category : #'LiveRobotics-Tests'
}

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceOutsideStateNestedMachine [
	^'
	(var count :=[0])
	(var running := [false])
	(machine Test
		(state init
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state b
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state c
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state nested
			(machine NestedTest
				(state nestedInit
					(onentry [count := count + 1])
					(onexit [count := count + 1])
				)
				(state nestedB
					(onentry [count := count + 1])
					(running [running := true])
					(onexit [count := count + 1])
				)
				(state nestedC
					(onentry [count := count + 1])
					(onexit [count := count + 1])
				)
				
				(eps nestedInit -> nestedB tninb)
				(on eventFalse nestedB -> nestedC tninc)
				(event eventFalse [false])
			)
			(onentry (spawn NestedTest nestedInit))

		)
		
		(eps init -> b tib)
		(on eventFalse b -> c tbc)
		(eps b -> nested tbn)
		(event eventFalse [false])
	)
	'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceOutsideStateNestedMachineWithSpawn [
	^ self forceOutsideStateNestedMachine, String cr, '(spawn Test init)'.
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceSpawnNestedStateMachine [
^'(var test := [false])
(machine top
    (state first
        (machine nested
            (state nfirst (onentry [test := true])))
        (onentry (spawn nested nfirst)))
    (state second)
)
(spawn top second)'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateMachine [
	^'
	(var count :=[0])
	(var running := [false])
	(machine Test
		(state init
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state b
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state c
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state d
			(onentry [count := count + 1])
			(running [running := true])
			(onexit [count := count + 1])
		)
		
		(on eventFalse init -> b tib)
		(on eventFalse init -> c tic)
		(on eventFalse c -> d tcd)
		(event eventFalse [false])
	)
	'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateMachinePost [
	^'
	(var count :=[0])
	(var running := [false])
	(machine Test
		(state init
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state b
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state c
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state d
			(onentry [count := count + 1])
			(running [running := true])
			(onexit [count := count + 1])
		)
		(state e)
		
		(on eventFalse init -> b tib)
		(on eventFalse init -> c tic)
		(on eventFalse c -> d tcd)
		(event eventFalse [false])
	)
	(spawn Test init)'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateMachinePre [
	^'
	(var count :=[0])
	(var running := [false])
	(machine Test
		(state init
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state b
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state c
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state d
			(onentry [count := count + 1])
			(running [running := true])
			(onexit [count := count + 1])
		)
		
		(on eventFalse init -> b tib)
		(on eventFalse init -> c tic)
		(on eventFalse c -> d tcd)
		(event eventFalse [false])
	)
	(spawn Test init)'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateMachineWithSpawn [
	^ self forceStateMachine, String cr, '(spawn Test init)'.
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateNestedMachine [
	^'
	(var count :=[0])
	(var running := [false])
	(machine Test
		(state init
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state b
			(onentry [count := count + 1])
			(onexit [count := count + 1])
		)
		(state c
			(onentry [count := count + 1])
			(running [running := true])
			(onexit [count := count + 1])
		)
		(state nested
			(machine NestedTest
				(state nestedInit
					(onentry [count := count + 1])
					(onexit [count := count + 1])
				)
				(state nestedB
					(onentry [count := count + 1])
					(running [running := true])
					(onexit [count := count + 1])
				)
				(state nestedC
					(onentry [count := count + 1])
					(onexit [count := count + 1])
				)
				(on eventFalse nestedInit -> nestedB tninb)
				(on eventFalse nestedB -> nestedC tninc)
				(event eventFalse [false])
			)
			(onentry (spawn NestedTest nestedInit))

		)
		
		(on eventFalse init -> b tib)
		(on eventFalse b -> c tbc)
		(on eventFalse b -> nested tbn)
		(event eventFalse [false])
	)
	'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> forceStateNestedMachineWithSpawn [
	^ self forceStateNestedMachine, String cr, '(spawn Test init)'.
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> parallelTestStateMachine [
	^self parallelTestStateMachineRoot1, self parallelTestStateMachineRoot2

]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> parallelTestStateMachine2 [
	^self parallelTestStateMachineRoot3, self parallelTestStateMachineRoot2

]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> parallelTestStateMachineRoot1 [
	^'(machine root1
	(state r11
		(machine nest11
			(state n11))
		(onentry (spawn nest11 n11)))
	(state r12
		(machine nest12
			(state n12)))
)'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> parallelTestStateMachineRoot2 [
	^'
(machine root2
	(state r21
		(machine nest21
			(state n21))
		(onentry (spawn nest21 n21)))
	(state r22
		(machine nest22
			(state n22)))
	(state r23)
)'
]

{ #category : #'force states tests machines' }
LRPInterpretationTests class >> parallelTestStateMachineRoot3 [
	^'(machine root3
	(state r31
		(machine nest31
			(state n31))
		(onentry (spawn nest31 n31))
		(onentry (spawn root2 r21)))
)'
]

{ #category : #'access to generated code tests' }
LRPInterpretationTests >> testAccessEventGeneratedBlock [
	|generatedNode|
	"does this program works for the test?"
	program := '
		(var foo := [0])
		(machine a
			(state a)
			(state b)
			(on true a -> b)
			(event true [ foo := foo + 1 ] )
		)
		(spawn a a)
	'.
	
	
	interpreter newProgram: 	(parser parse: program).
	"enter the state a"
	interpreter stepRun.
	"enter the state b with event"
	interpreter stepRun.
	
	"101: foo:|= foo + 1."
	generatedNode := interpreter generatedNodeForCursorPosition: 102.
	self assert: (generatedNode class = RBAssignmentNode).
	
	
]

{ #category : #'access to generated code tests' }
LRPInterpretationTests >> testAccessSegmentNodeOfSequenceNodeWithCursorPosition [
	|generatedNode|
	program := '
		(var foo := [0])
		(var bar := [0])
		(machine a
			(state s
				(running [foo := foo + 1. bar := bar + 2])
			)
		)
		(spawn a s)
	'.
	
	
	interpreter newProgram: 	(parser parse: program).
	"enter the state s"
	interpreter stepRun.
	"execute running action (compile into a method)"
	interpreter stepRun.
	
	"83: foo:|= foo + 1"
	generatedNode := interpreter generatedNodeForCursorPosition: 83.
	self assert: (generatedNode class = RBAssignmentNode).
	
	"99: bar|= bar + 1"
	generatedNode := interpreter generatedNodeForCursorPosition: 99.
	self assert: (generatedNode class = RBAssignmentNode).
	
]

{ #category : #'access to generated code tests' }
LRPInterpretationTests >> testAccessSegmentNodeWithCursorPosition [
	"character 65"
	|generatedNode|

	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.
	
	
	interpreter newProgram: 	(parser parse: program).
	"enter the state s"
	interpreter stepRun.
	"execute running action (compile into a method)"
	interpreter stepRun.
	
	generatedNode := interpreter generatedNodeForCursorPosition: 65.
	self assert: (generatedNode class = RBAssignmentNode).
	
	
]

{ #category : #'access to generated code tests' }
LRPInterpretationTests >> testAccessVarGeneratedBlock [
	|generatedNode|
	"does this program works for the test?"
	program := '
		(var foo := [1 + 1])
	'.
	
	
	interpreter newProgram: 	(parser parse: program).
	
	
	"19: foo:= [1 |+ 1]."
	generatedNode := interpreter generatedNodeForCursorPosition: 19.
	self assert: (generatedNode class = RBMessageNode).
]

{ #category : #'watchpoint tests' }
LRPInterpretationTests >> testAddDirectlyWatchpointAssignment [
	|blockNode machine wrapper node watchpoint|
	
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	"enter the state s"
	interpreter stepRun.
	"execute running action (compile into a method)"
	interpreter stepRun.
	machine := (scope machines at:'a').
	blockNode := machine body first body first block.
	
	"go into the tree to the assignment node"
	wrapper := (machine scope blocks at: blockNode).
	
	node := ((wrapper inst class)>>(wrapper selector)) ast 
					children first children first children first.
		
	watchpoint := Watchpoint in: node.
	interpreter stepRun.
	self assert: (scope getVar: #foo) = 2.
	self assert: (watchpoint values first value = 2).
	
	watchpoint uninstall.
	
]

{ #category : #'watchpoint tests' }
LRPInterpretationTests >> testAddWatchpointWithCursorPosition [
	|watchpoint|
		
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.
	
	
	interpreter newProgram: 	(parser parse: program).
	"enter the state s"
	interpreter stepRun.
	"execute running action (compile into a method)"
	interpreter stepRun.
	
	"the cursor is in the := operation (assignment node)"
	watchpoint := interpreter addWatchpointWithCursorPosition: 64.
	
	interpreter stepRun.
	self assert: (watchpoint values first value = 2).
	
	watchpoint uninstall
]

{ #category : #'error handling tests' }
LRPInterpretationTests >> testBadDestStateInTx [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
			(eps one -> error txe)
	  		(eps one -> two tx1))
		(spawn blah one)'.
		
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testChainedSpawn [
	| machine |
	
 	program := '
		(machine root
			(state first
				(machine nested
					(state bleh
						(machine nested2
							(state foo)
						)
						(onentry (spawn nested2 foo))
					)
				)
				(onentry (spawn nested bleh))
			)
		)
		(spawn root first)
	'.
	
	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachine.
	self assert: machine name equals: 'root'.
	self assert: machine currentState isNil.
	interpreter stepRun.
	
	machine := interpreter runningMachine.
	self assert: machine name equals: 'root'.
	self assert: machine currentState name equals: 'first'.

	machine := interpreter runningMachine currentState 
						runningMachines first.
	self assert: machine name = 'nested'.
	self assert: machine currentState name = 'bleh'.
	
	machine := interpreter runningMachine currentState 
						runningMachines first currentState
							runningMachines first.
	self assert: machine name equals:'nested2'.
	self assert: machine currentState name = 'foo'.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testChainedVariables [
	
	program := '
		(var foo := [42])
		(var bar := [foo])
	'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	self assert: (scope getVar: 'bar') == 42.
]

{ #category : #'concurrency liveness tests' }
LRPInterpretationTests >> testChangeInOneMachine [
	"for now, we restart all machines when one has an invalid change
	in the future: only the affected machine should change"
	| machines|
	
	program := '
	(machine m1
  		(state s1))
	(machine m2
  		(state s2)
		(state s3)
		(eps s2 -> s3))
	(spawn m1 s1)
	(spawn m2 s2)'.

	interpreter newProgram: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.
	self assert: machines second currentState name equals: 's2'.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.
	self assert: machines second currentState name equals: 's3'.
	
	program := '
	(machine m1
  		(state sA))
	(machine m2
  		(state s2)
		(state s3)
		(eps s2 -> s3))
	(spawn m1 sA)
	(spawn m2 s2)'.
	
	interpreter newProgram: (parser parse: program).
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 'sA'.
	self assert: machines second currentState name equals: 's2'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawn [
	|machine nestedMachines|
	
	program := '
	(machine m
  		(state s
			(machine nested1
				(state s1)
			)
			(machine nested2
				(state s2)
			)	
			(onentry (spawn nested1 s1))
			(onentry (spawn nested2 s2))
		)
	)
	(spawn m s)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 1.
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 's'.
	
	nestedMachines := machine currentState runningMachines.
	self assert: nestedMachines size equals: 2.
	self assert: nestedMachines first name equals: 'nested1'.
	self assert: nestedMachines first currentState name equals: 's1'.
	self assert: nestedMachines second name equals: 'nested2'.
	self assert: nestedMachines second currentState name equals: 's2'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnExternalVariable [
	|machine|
	
	program := '
(machine root (state root
	(machine m1
  		(state s1A
			(onentry [LRPTestSingleton instance: true])
		)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [LRPTestSingleton instance: false])
		)
		(eps s2A -> s2B)
		)
	(onentry (spawn m1 s1A))
	(onentry (spawn m2 s2A))
	
))
(spawn root root)'.

	interpreter interpret: (parser parse: program).
	LRPTestSingleton instance: false.
	
	machine := interpreter runningMachines first.
	
	self deny: LRPTestSingleton instance.
	
	interpreter stepRun.
	self assert: LRPTestSingleton instance.
	
	interpreter stepRun.
	self deny: LRPTestSingleton instance
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnInternalCommunication [
	|machine|
	
	program := '
(var test := [false])
(machine root (state root
	(machine m1
  		(state s1A)
		(state s1B
			(onentry [test := true])
		)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B)
		(on [ test ] s2A -> s2B)
		)
	(onentry (spawn m1 s1A))
	(onentry (spawn m2 s2A))
))
(spawn root root)'.

	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1A'.
	self assert: machine currentState runningMachines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1B'.
	self assert: machine currentState runningMachines second currentState name equals: 's2B'.
	
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnInternalCommunicationReverseOrder [
	|machine|
	
	program := '
(var test := [false])
(machine root (state root
	(machine m1
  		(state s1A)
		(state s1B)
		(on [ test ] s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [test := true])
		)
		(eps s2A -> s2B)
		)
	(onentry (spawn m1 s1A))
	(onentry (spawn m2 s2A))
))
(spawn root root)'.

	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1A'.
	self assert: machine currentState runningMachines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1A'.
	self assert: machine currentState runningMachines second currentState name equals: 's2B'.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1B'.
	self assert: machine currentState runningMachines second currentState name equals: 's2B'.
	
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnInternalVariable [
	
	program := '
(var test := [false])
(machine root (state root
	
	(machine m1
  		(state s1A
			(onentry [test := true])
		)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [test := false])
		)
		(eps s2A -> s2B)
		)
	(onentry (spawn m1 s1A))
	(onentry (spawn m2 s2A))
))
(spawn root root)'.

	interpreter interpret: (parser parse: program).
	
	self deny: (interpreter scope getVar: 'test').
	
	interpreter stepRun.
	self assert: (interpreter scope getVar: 'test').
	
	interpreter stepRun.
	self deny: (interpreter scope getVar: 'test')
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnSameMachine [
	|machine nestedMachines|
	
	program := '
	(machine m
  		(state s
			(machine nested1
				(state s1)
				(state s2)
			)	
			(onentry (spawn nested1 s1))
			(onentry (spawn nested1 s2))
		)
	)
	(spawn m s)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 1.
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 's'.
	
	nestedMachines := machine currentState runningMachines.
	self assert: nestedMachines size equals: 1.
	self assert: nestedMachines first name equals: 'nested1'.
	self assert: nestedMachines first currentState name equals: 's1'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleNestedSpawnSimpleTransition [
	|machine|
	
	program := '
(machine root (state root
	(machine nested1
  		(state s1A)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine nested2
  		(state s2A)
		(state s2B)
		(eps s2A -> s2B)
		)
	(onentry (spawn nested1 s1A))
	(onentry (spawn nested2 s2A))
))
(spawn root root)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 1.
	machine := interpreter runningMachines first.
	
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'root'.
	self assert: machine currentState runningMachines first name equals: 'nested1'.
	self assert: machine currentState runningMachines first currentState name equals: 's1A'.
	self assert: machine currentState runningMachines second name equals: 'nested2'.
	self assert: machine currentState runningMachines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machine currentState runningMachines first currentState name equals: 's1B'.
	self assert: machine currentState runningMachines second currentState name equals: 's2B'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testDoubleNesting [
	| machine |
	
 	program := '
		(machine root
			(state first)
			(state second
				(machine nested
					(state blah)
					(state bleh
						(machine nested2
							(state foo)
							(state bar)
							(eps foo -> bar t3)
						)
						(onentry (spawn nested2 foo))
					)
					(eps blah -> bleh t2)
				)
				(onentry (spawn nested blah))
			)
			(eps first -> second t1)
		)
		(spawn root first)
	'.
	
	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachine.
	self assert: machine name equals: 'root'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: machine currentState name equals: 'first'.
	
	"now enter the nested machine, the current step of the first machine stay at second"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'blah'.

	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'bleh'.
	self assert: machine currentState 
						runningMachines first currentState 
							runningMachines first name 
			equals: 'nested2'.
	self assert: machine currentState 
						runningMachines first currentState 
							runningMachines first currentState name 
			equals: 'foo'.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'bleh'.
	self assert: machine currentState 
						runningMachines first currentState 
							runningMachines first name 
			equals: 'nested2'.
	self assert: machine currentState 
						runningMachines first currentState 
							runningMachines first currentState name 
			equals: 'bar'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawn [
	| machines|
	
	program := '
	(machine m1
  		(state s1))
	(machine m2
  		(state s2))
	(spawn m1 s1)
	(spawn m2 s2)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.
	self assert: machines second currentState name equals: 's2'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnExternalVariable [
	| machines|
	
	program := '
	(machine m1
  		(state s1A
			(onentry [LRPTestSingleton instance: true])
		)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [LRPTestSingleton instance: false])
		)
		(eps s2A -> s2B)
		)
	(spawn m1 s1A)
	(spawn m2 s2A)'.

	interpreter interpret: (parser parse: program).
	LRPTestSingleton instance: false.
	
	machines := interpreter runningMachines.
	
	self assert: machines size equals: 2.
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	self deny: LRPTestSingleton instance.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2A'.
	self assert: LRPTestSingleton instance.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1B'.
	self assert: machines second currentState name equals: 's2B'.
	self deny: LRPTestSingleton instance.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnInternalCommunication [
	|machines|
	
	program := '
	(var test := [false])
	(machine m1
  		(state s1A)
		(state s1B
			(onentry [test := true])
		)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B)
		(on [ test ] s2A -> s2B)
		)
	(spawn m1 s1A)
	(spawn m2 s2A)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	
	self assert: machines size equals: 2.
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1B'.
	self assert: machines second currentState name equals: 's2B'.
	
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnInternalCommunicationReverseOrder [
	|machines|
	
	program := '
	(var test := [false])
	(machine m1
  		(state s1A)
		(state s1B)
		(on [ test ] s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [test := true])
		)
		(eps s2A -> s2B)
		)
	(spawn m1 s1A)
	(spawn m2 s2A)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	
	self assert: machines size equals: 2.
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2B'.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1B'.
	self assert: machines second currentState name equals: 's2B'.
	
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnInternalVariable [
	|machines|
	
	program := '
	(var test := [false])
	(machine m1
  		(state s1A
			(onentry [test := true])
		)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B
			(onentry [test := false])
		)
		(eps s2A -> s2B)
		)
	(spawn m1 s1A)
	(spawn m2 s2A)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	
	self assert: machines size equals: 2.
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	self deny: (interpreter scope getVar: 'test').
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2A'.
	self assert: (interpreter scope getVar: 'test').
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1B'.
	self assert: machines second currentState name equals: 's2B'.
	self deny: (interpreter scope getVar: 'test').
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnSameMachine [
	| machines|
	
	program := '
	(machine m1
  		(state s1)
  		(state s2))
	(spawn m1 s1)
	(spawn m1 s2)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 1.
	
	self assert: machines first currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.
]

{ #category : #'concurrency liveness tests' }
LRPInterpretationTests >> testDoubleSpawnSameMachineWithProgramUpdate [
	| machines|
	
	program := '
	(machine m1
  		(state s1))
	(spawn m1 s1)'.

	interpreter newProgram: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 1.
	self assert: machines first currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.

	program := '
	(machine m1
  		(state s1)
		(state s2))
	(spawn m1 s1)
	(spawn m1 s2)'.

	interpreter newProgram: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 1.
	self assert: machines first currentState name equals: 's1'.

]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testDoubleSpawnSimpleTransition [
	| machines|
	
	program := '
	(machine m1
  		(state s1A)
		(state s1B)
		(eps s1A -> s1B)
		)
	(machine m2
  		(state s2A)
		(state s2B)
		(eps s2A -> s2B)
		)
	(spawn m1 s1A)
	(spawn m2 s2A)'.

	interpreter interpret: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1A'.
	self assert: machines second currentState name equals: 's2A'.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1B'.
	self assert: machines second currentState name equals: 's2B'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testEpsilonTransitions [
	| machine|
	
	program := '
	(machine blah
  		(state one)
  		(state two)
  		(eps one -> two t1))
	(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachine.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'two'.
	self assert: machine triggeredTransition name = 't1'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testEpsilonTransitionsNoName [
	| machine|
	
	program := '
	(machine blah
  		(state one)
  		(state two)
  		(eps one -> two))
	(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = ''.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testExitNesting [
	| machine |
	
 	program := '
		(machine root
			(state first
				(machine nested
					(state blah)
					(state bleh)
					(eps blah -> bleh t1)
				)
				(onentry (spawn nested blah))
			)
			(state out)
			(ontime 200 first -> out t2)
		)
		(spawn root first)
	'.

	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachine.

	interpreter stepRun.
	self assert: machine currentState name equals: 'first'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'blah'.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'first'.
	self assert: machine currentState 
						runningMachines first name
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name
			equals: 'bleh'.

	(Delay forMilliseconds:  400) wait.
	interpreter stepRun.
	self assert: machine currentState name equals: 'out'.
	self deny: machine currentState hasNestedMachines .
]

{ #category : #'find state tests' }
LRPInterpretationTests >> testFindState [
	|programPre programPost machine state correspondingState|
	
	programPre := '
		(machine Test
			(state a)
		)
	'.
	programPost := '
		(machine Test
			(state a)
			(state b)
		)
	'.
	
	interpreter interpret: (parser parse: programPre).
	scope := interpreter scope.
	machine := scope machines at: 'Test'.
	state := machine states detect:[:aState| aState name = 'a'].
	
	interpreter interpret: (parser parse: programPost).
	
	correspondingState := interpreter findCorrespondingState: state.
	self assert: (correspondingState name = 'a').
	self assert: (correspondingState fullName = '/Test/a').
	self assert: (state fullName = '/Test/a').
]

{ #category : #'find state tests' }
LRPInterpretationTests >> testFindStateInNestedMachine [
	|programPre programPost machine state correspondingState|
	
	programPre := '
		(machine Test
			(state a
				(machine Nested
					(state b)
				)
			)
		)
	'.
	programPost := '
		(machine Test
			(state a
				(machine Nested
					(state b)
				)
			)
			(state b)
		)
	'.
	
	interpreter interpret: (parser parse: programPre).
	scope := interpreter scope.
	machine := scope machines at: 'Test'.
	state := machine states first machines first states first.
	
	interpreter interpret: (parser parse: programPost).
	
	correspondingState := interpreter findCorrespondingState: state.
	self assert: (correspondingState name = 'b').
	self assert: (correspondingState fullName = '/Test/a/Nested/b').
	self assert: (state fullName = '/Test/a/Nested/b').
]

{ #category : #'find state tests' }
LRPInterpretationTests >> testFindStateInNestedMachineSameName [
	|programPre programPost machine state correspondingState|
	
	programPre := '
		(machine Test
			(state a
				(machine Test
					(state a)
				)
			)
		)
	'.
	programPost := '
		(machine Test
			(state a
				(machine Test
					(state a)
				)
			)
			(state b)
		)
	'.
	
	interpreter interpret: (parser parse: programPre).
	scope := interpreter scope.
	machine := scope machines at: 'Test'.
	state := machine states first machines first states first.
	
	interpreter interpret: (parser parse: programPost).
	
	correspondingState := interpreter findCorrespondingState: state.
	self assert: (correspondingState name = 'a').
	self assert: (correspondingState fullName = '/Test/a/Test/a').
	self assert: (state fullName = '/Test/a/Test/a').
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpParallelFromRoot [
	|stateToJump oldmachine newmachine|
	
	program := parser parse:
		(self class parallelTestStateMachine,'(spawn root1 r11)').
	
	interpreter newProgram: program.
	interpreter stepRun.
	
	oldmachine := interpreter runningMachines first currentState runningMachines first.
	self assert: oldmachine currentState name equals: 'n11'.
	
	stateToJump := program second states first machines first states first.
	self assert: stateToJump name equals: 'n21'.
	
	interpreter jumpTo: stateToJump.
	self assert: oldmachine currentState isNotNil.
	self assert: oldmachine currentState name equals: 'n11'.
	
	self assert: interpreter runningMachines size equals: 2.
	newmachine := interpreter runningMachines second.
	self assert: newmachine name equals: 'root2'.
	self assert: newmachine currentState isNotNil.
	self assert: newmachine currentState runningMachines size equals: 1.
	self assert: newmachine currentState runningMachines first currentState equals: stateToJump.
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpSameFromNestedRoot [
	|stateToJump machine1 machine2 |
	
	program := parser parse:
		(self class parallelTestStateMachine2,'(spawn root3 r31)').
	
	interpreter newProgram: program.
	interpreter stepRun.
	
	machine1 := interpreter runningMachines first currentState runningMachines first.
	self assert: machine1 currentState name equals: 'n31'.
	
	machine2 := interpreter runningMachines first currentState runningMachines second.
	self assert: machine2 currentState name equals: 'r21'.
	self assert: machine2 currentState runningMachines first currentState name equals: 'n21'.
	
	stateToJump := program second states second machines first states first.
	self assert: stateToJump name equals: 'n22'.
	
	interpreter jumpTo: stateToJump.
	self assert: machine1 currentState name equals: 'n31'.
	self assert: interpreter runningMachines first currentState runningMachines size equals: 2.
	machine2 := interpreter runningMachines first currentState runningMachines second.
	self assert: machine2 currentState name equals: 'r22'.
	self assert: machine2 currentState runningMachines size equals: 1.
	self assert: machine2 currentState runningMachines first currentState equals: stateToJump.

]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpSameFromNestedRoot2 [
	|stateToJump machine1 machine2 |
	
	program := parser parse:
		(self class parallelTestStateMachine2,'(spawn root3 r31)').
	
	interpreter newProgram: program.
	interpreter stepRun.
	
	machine1 := interpreter runningMachines first currentState runningMachines first.
	self assert: machine1 currentState name equals: 'n31'.
	
	machine2 := interpreter runningMachines first currentState runningMachines second.
	self assert: machine2 currentState name equals: 'r21'.
	self assert: machine2 currentState runningMachines first currentState name equals: 'n21'.
	
	stateToJump := program second states third.
	self assert: stateToJump name equals: 'r23'.
	
	interpreter jumpTo: stateToJump.
	self assert: interpreter runningMachines first currentState runningMachines size equals: 2.
	machine2 := interpreter runningMachines first currentState runningMachines second.
	self assert: machine1 currentState name equals: 'n31'.
	self assert: machine2 currentState equals: stateToJump.

]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpSameFromRoot [
	|stateToJump oldmachine |
	
	program := parser parse:
		(self class parallelTestStateMachine,'(spawn root1 r11)').
	
	interpreter newProgram: program.
	interpreter stepRun.
	
	oldmachine := interpreter runningMachines first currentState runningMachines first.
	self assert: oldmachine currentState name equals: 'n11'.
	
	stateToJump := program first states second machines first states first.
	self assert: stateToJump name equals: 'n12'.
	
	interpreter jumpTo: stateToJump.
	self assert: oldmachine currentState isNil.
	self assert: interpreter runningMachines first currentState runningMachines first currentState  equals: stateToJump.
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpSameFromSecondRoot [
	|stateToJump machine1 machine2|
	
	program := parser parse:
		(self class parallelTestStateMachine,'(spawn root1 r11)(spawn root2 r21)').
	
	interpreter newProgram: program.
	interpreter stepRun.

	self assert: interpreter runningMachines size equals: 2.	
	machine1 := interpreter runningMachines first currentState runningMachines first.
	self assert: machine1 currentState name equals: 'n11'.
	machine2 := interpreter runningMachines second currentState runningMachines first.
	self assert: machine2 currentState name equals: 'n21'.
	
	stateToJump := program second states second machines first states first.
	self assert: stateToJump name equals: 'n22'.
	
	interpreter jumpTo: stateToJump.
	self assert: interpreter runningMachines size equals: 2.
	self assert: interpreter runningMachines first currentState isNotNil.
	machine1 := interpreter runningMachines first currentState runningMachines first.
	self assert: machine1 currentState name equals: 'n11'.
	self assert: interpreter runningMachines second currentState isNotNil.
	self assert: interpreter runningMachines second currentState runningMachines first currentState equals: stateToJump.
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpStateChangingProgram [
	|machine stateToJump|
	
	program := self class forceStateMachinePre.
	
	interpreter newProgram: (parser parse: program).
	machine := interpreter runningMachine.
	stateToJump := machine states detect:[:aState| aState name = 'd'].
	
	interpreter stepRun.
	self assert: (machine currentState name = 'init').
	self assert: (interpreter scope getVar: 'count') equals: 1.
	
	program := self class forceStateMachinePost.

	interpreter newProgram: (parser parse: program).
	machine := interpreter runningMachine.
	
	interpreter jumpTo: stateToJump.
	self assert: (machine currentState name = 'd').
	self assert: (interpreter scope getVar: 'count') equals: 1.
	
	interpreter stepRun.
	self assert: (machine currentState name = 'd').
	self assert: (interpreter scope getVar: 'count') equals: 1.
	self assert: (interpreter scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpStateWithSpawn [
	|machine stateToJump|
	
	program := self class forceStateMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := interpreter runningMachine.
	stateToJump := machine states detect:[:aState| aState name = 'd'].
	
	interpreter stepRun.
	self assert: (machine currentState name = 'init').
	self assert: (scope getVar: 'count') equals: 1.
	
	interpreter jumpTo: stateToJump.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') equals: 1.
	
	interpreter stepRun.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') equals: 1.
	self assert: (scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpStateWithoutSpawn [
	|machine stateToJump|
	
	program := self class forceStateMachine.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := scope machines at: 'Test'.
	stateToJump := machine states detect:[:aState| aState name = 'd'].
	
	interpreter jumpTo: stateToJump.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 0.
	
	interpreter stepRun.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 0.
	self assert: (scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpToNestedMachineWithSpawn [
	|machine stateToJump|
	
	program := self class forceStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'nested']) 
								machines first states detect:[:aState| aState name = 'nestedB'] .
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'init'.
	self assert: (scope getVar: 'count') equals: 1.
	
	interpreter jumpTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: machine name equals: 'Test'.
	self assert: machine currentState name equals: 'nested'.
	self assert: machine currentState	runningMachines first currentState  name equals: 'nestedB'.
	self assert: (machine currentState runningMachines first scope getVar: 'count') equals: 1.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: machine name equals: 'Test'.
	self assert: machine currentState name equals: 'nested'.
	self assert: machine currentState	runningMachines first currentState name equals: 'nestedB'.
	self assert: (machine currentState runningMachines first scope getVar: 'count')  equals: 1.
	self assert: (machine currentState runningMachines first scope getVar: 'running') . 
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpToNestedMachineWithoutSpawn [
	|machine stateToJump|
	
	program := self class forceStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'nested']) 
								machines first states detect:[:aState| aState name = 'nestedB'] .
	
	interpreter jumpTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 0.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count')  == 0.
	self assert: (machine currentState runningMachines first scope getVar: 'running') .
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpToOutsideNestedMachineWithSpawn [
	|machine stateToJump|
	
	program := self class forceOutsideStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	machine := interpreter runningMachine.
	stateToJump := machine states detect:[:aState| aState name = 'c'].
	
	interpreter stepRun.
	interpreter stepRun.
	interpreter stepRun.
	interpreter stepRun.	
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 7.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	self assert: (machine scope getVar: 'running') . 
	
	interpreter jumpTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'c').
	self assert: (machine scope getVar: 'count')  == 7.
	self assert: (machine scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testJumpToStateWithNestedMachine [
	|machine stateToJump|
	
	program := self class forceSpawnNestedStateMachine.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'first']).
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	
	interpreter jumpTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: machine name equals: 'top'.
	self assert: machine currentState name equals: 'first'.
	self assert: machine currentState runningMachines first currentState name equals: 'nfirst'.
	self assert: (scope getVar: 'test')  
]

{ #category : #'action tests' }
LRPInterpretationTests >> testMultipleOnEntries [

	program := '
		(machine blah
			(state one)
			(eps one -> two ot)	
 	 		(state two
				(onentry [LRPTestSingleton instance: LRPTestSingleton instance + 1])
				(onentry [LRPTestSingleton instance: LRPTestSingleton instance + 1])
			)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: 0.
	
	interpreter interpret: (parser parse: program).
	
	"onentry action has not yet run"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"in the one state"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"onentry action has run"
	self assert: LRPTestSingleton instance equals: 2.
	interpreter stepRun.
	"onentry action runs only once"
	self assert: LRPTestSingleton instance equals: 2.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testMultipleOnExits [

	program := '
		(machine blah
			(state one
				(onexit [LRPTestSingleton instance: LRPTestSingleton instance + 1])
				(onexit [LRPTestSingleton instance: LRPTestSingleton instance + 1])
			)
			(eps one -> two ot)	
 	 		(state two)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: 0.
	
	interpreter interpret: (parser parse: program).
	
	"onexit action has not yet run"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"in the one state"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"onexit action has run"
	self assert: LRPTestSingleton instance equals: 2.
	interpreter stepRun.
	"no more actions to execute"
	self assert: LRPTestSingleton instance equals: 2.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testMultipleOnRunnings [

	program := '
		(machine blah
			(state one
				(running [LRPTestSingleton instance: LRPTestSingleton instance + 1])
				(running [LRPTestSingleton instance: LRPTestSingleton instance + 1])
			)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: 0.
	
	interpreter interpret: (parser parse: program).
	
	"no action yet"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"in the one state, onentry action"
	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	"running actions has run"
	self assert: LRPTestSingleton instance equals: 2.
	interpreter stepRun.
	"running actions execute again"
	self assert: LRPTestSingleton instance equals: 4.
]

{ #category : #'tests - misc' }
LRPInterpretationTests >> testNamespaces [

	program := '
		(machine s
			(event s [s])
			(var s:=[true])
			(on s s->t)
			(state t)
			(state s)
		)
		(spawn s s)'.
		
	interpreter interpret: (parser parse: program).

	interpreter stepRun.	
	self assert: interpreter runningMachine currentState name equals: 's'.
	interpreter stepRun.	
	self assert: interpreter runningMachine currentState name equals: 't'.

]

{ #category : #'machine tests' }
LRPInterpretationTests >> testNestedCurrentState [
	| machine |
	
 	program := '
		(machine root
			(state first)
			(eps first -> second t1)
			(state second
				(machine nested
					(state blah)
					(state bleh (onentry [LRPTestSingleton instance: true]))
					(eps blah -> bleh t2)
				)
				(onentry (spawn nested blah)))
			(state out)
			(on outevt second -> out t3)
			(event outevt [ LRPTestSingleton instance ])
		)
		(spawn root first)
	'.
	
	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"spawn the machine in the first state"
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: machine currentState name equals: 'first'.

	"go to the second state, in blah"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first currentState name
			equals: 'blah'.	

	"go to bleh"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first currentState name
			equals: 'bleh'.	
	
	"go to the out state"
	interpreter stepRun.
	self assert: machine currentState name = 'out'.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testNestedMachineScope [
	"problem with static scope"
	
	|machine|
	program := '
		(var foo := [1])
		(machine blah
			(state one 
				(onentry [foo := foo + 1])
			)
			(state two 
				(machine nested
					(state nestedOne
						(onentry [foo := foo + 1])
					)
				)
				(onentry (spawn nested nestedOne))
			)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
		(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).

	
	self assert: (interpreter runningMachine scope getVar: 'foo') equals: 1.
	
	interpreter stepRun.
	self assert: (interpreter runningMachine scope getVar: 'foo') equals: 2.
	
	interpreter stepRun.
	machine := interpreter runningMachine currentState runningMachines first.
	self assert: (interpreter runningMachine scope getVar: 'foo') equals: 3.
	self assert: machine currentState name equals: 'nestedOne'.
	self assert: (machine scope getVar: 'foo') = 3.
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: (machine scope getVar: 'foo') equals: 3.
	self assert: machine currentState name equals: 'three'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testNestedTriggeredTransition [
	| machine |
	
 	program := '
		(machine root
			(state first)
			(eps first -> second t1)
			(state second
				(machine nested
					(state blah)
					(state bleh (onentry [LRPTestSingleton instance: true]))
					(eps blah -> bleh t2)
				)
				(onentry (spawn nested blah)))
			(state out)
			(on outevt second -> out t3)
			(event outevt [ LRPTestSingleton instance ])
		)
		(spawn root first)
	'.
	
	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"spawn the machine in the first state"
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: machine currentState name equals: 'first'.
	self assert: machine triggeredTransition isNil.
	
	"go to the second state, in blah"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first triggeredTransition isNil.	

	"go to bleh"
	interpreter stepRun.
	self assert: machine currentState name = 'second'.
	self assert: machine currentState 
						runningMachines first triggeredTransition name
			equals: 't2'.	
	
	"go to the out state"
	interpreter stepRun.
	self assert: machine currentState name = 'out'.
	self assert: machine triggeredTransition name = 't3'.	

]

{ #category : #'machine tests' }
LRPInterpretationTests >> testNestingScope [
	| machine |
	
 	program := '
	(machine m
		(state first
			(machine no (state to))
			(machine nt (state tt))
			(onentry (spawn nt tt))
			)
		(eps first->second)
		(state second (onentry (spawn mm tm)
		))
	)
	(machine mm (state tm))
	(spawn m first)
	'.
	
	interpreter interpret: (parser parse: program).

	machine := interpreter runningMachine.
	self assert: machine name equals: 'm'.
	self assert: machine currentState isNil.
	
	"spawn the machine in the first state"
	interpreter stepRun.
	self assert: machine currentState name equals: 'first'.
	self assert: machine currentState 
						runningMachines first name
			equals: 'nt'.
	self assert: machine currentState 
						runningMachines first currentState name
			equals: 'tt'.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'mm'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'tm'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testNormalTransitions [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
 	 		(state two)
  			(on foo one -> two t1)
			(event foo [true]))
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testNormalTransitionsNoMatch [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
	  		(on foo one -> two t1)
			(event foo [false]))
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testNormalTransitionsNoName [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
 	 		(state two)
  			(on foo one -> two )
			(event foo [true]))
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = ''.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testOnEntry [

	program := '
		(machine blah
			(state one)
			(eps one -> two ot)	
 	 		(state two
				(onentry [LRPTestSingleton instance: (LRPTestSingleton instance not)])
			)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"onentry action has not yet run"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	"in the one state"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	"onentry action has run"
	self assert: LRPTestSingleton instance.
	interpreter stepRun.
	"onentry action runs only once"
	self assert: LRPTestSingleton instance.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testOnEntryStartState [

	program := '
		(machine blah	
 	 		(state one
				(onentry [LRPTestSingleton instance: (LRPTestSingleton instance not)])
			)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: false.

	interpreter interpret: (parser parse: program).
	
	"onentry action has not yet run"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	"onentry action has run"
	self assert: LRPTestSingleton instance.
	interpreter stepRun.
	"onentry action runs only once"
	self assert: LRPTestSingleton instance.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testOnExit [

	program := '
		(machine blah
			(state one
				(onexit [LRPTestSingleton instance: (LRPTestSingleton instance not)]))
			(eps one -> two ot)	
 	 		(state two)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"onexit action has not yet run"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	"onexit action has not yet run"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	"onexit action has run"
	self assert: LRPTestSingleton instance.
	interpreter stepRun.
	"onexit action runs only once"
	self assert: LRPTestSingleton instance.
]

{ #category : #'action tests' }
LRPInterpretationTests >> testOnExitFromNested [

	program := '
		(machine root
			(state first
				(machine nested
					(state blah
						(onentry [LRPTestSingleton instance: true])
						(onexit [LRPTestSingleton instance: false]))
				)
				(onentry (spawn nested blah))
			)
			(state out)
			(on tout first -> out t1)
			(event tout [LRPTestSingleton instance])
		)
		(spawn root first)
	'.

	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"onentry action has not yet run"
	self deny: LRPTestSingleton instance.
	interpreter stepRun.
	
	"onentry action has run"
	self assert: LRPTestSingleton instance.
	self 
		assert:  
			interpreter runningMachine currentState
				runningMachines first currentState name 
		equals: 'blah'.
	interpreter stepRun.

	"onexit action has run"
	self deny: LRPTestSingleton instance.
	self 
		assert:  
			interpreter runningMachine currentState name 
		equals: 'out'.


]

{ #category : #'machine tests' }
LRPInterpretationTests >> testReEnterNestedMachine [
	| machine |
	
 	program := '
		(machine root
			(var a := [1])
			(var c := [3])
			(state first)
			(eps first -> second t1)
			(state second
				(machine nested
					(var b := [3])
					(var d := [4])
					(state blah)
					(state bleh (onentry [b := 6. d := 5. LRPTestSingleton instance: true]))
					(eps blah -> bleh t2)
				)
				(onentry (spawn nested blah)))
			(state out
				(onentry [c := 14. LRPTestSingleton instance: false])
			)
			(on outevt second -> out t3)
			(event outevt [ LRPTestSingleton instance ])
			
			(eps out -> second t2)
		)
		(spawn root first)
	'.
	
	LRPTestSingleton instance: false.
	
	interpreter interpret: (parser parse: program).
	
	"spawn the machine in the first state"
	interpreter stepRun.
	machine := interpreter runningMachine.
	
	"go to the second state, in blah"
	interpreter stepRun.

	"go to bleh"
	interpreter stepRun.
	
	"go to the out state"
	interpreter stepRun.
	
	"Test from here!"
	"go back to the second state, in blah"
	"a must be the same, b and d should restart, c should be 14"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'blah'.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'a') == 1.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'b') == 3.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'c') == 14.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'd') == 4.
	
	
	"go to bleh"
	interpreter stepRun.
	self assert: machine currentState name = 'second'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'bleh'.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'b') == 6.
	self assert: (machine currentState 
						runningMachines first scope getVar: 'd') == 5.

]

{ #category : #'machine tests' }
LRPInterpretationTests >> testReInitOfNested [
	
	program := '
		(machine root
			(state first (onentry [LRPTestSingleton instance: LRPTestSingleton instance + 1]))
			(eps first -> second t1)
			(state second
				(machine nested
					(state foo (onentry [LRPTestSingleton instance: -1]))
					(eps foo -> bar t2)
					(state bar
						(onentry [LRPTestSingleton instance: LRPTestSingleton instance + 1]))
				)
				(onentry (spawn nested foo))
			)
			(on zero second -> first t3)
			(event zero [LRPTestSingleton instance = 0])
		)
		(spawn root first)
	'.

	LRPTestSingleton instance: 1.
	
	interpreter interpret: (parser parse: program).
	
	interpreter stepRun.
	"in state first"
	self assert: LRPTestSingleton instance = 2.
	
	interpreter stepRun.
	"in state second, nested, foo"
	self assert: LRPTestSingleton instance = -1.

	interpreter stepRun.
	"in state second, nested, bar"
	self assert: LRPTestSingleton instance = 0.
	
	interpreter stepRun.
	"in state first"
	self assert: LRPTestSingleton instance = 1.
	
	interpreter stepRun.
	"in state second, nested, foo -- re-init has been performed"
	self assert: LRPTestSingleton instance = -1.
	
	interpreter stepRun.
	"in state second, nested, bar"
	self assert: LRPTestSingleton instance = 0.
	
	interpreter stepRun.
	"in state first"
	self assert: LRPTestSingleton instance = 1.
	
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testRedefineVariables [
	
	program := '
		(var foo := [42])
		(var foo := [43])
	'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	self assert: (scope getVar: 'foo') == 42.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testRedefineVariablesInMachine [
	
	program := '
		(var foo := [42])
		(machine m
			(var bar := [43])
			(var bar := [44])
			(state s)
		)
		(spawn m s)
	'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	self assert: (scope getVar: 'foo') == 42.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 43.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testRedefineVariablesInsideMachine [
	
	program := '
		(var foo := [42])
		(machine blah
			(var foo := [43])
		)
		'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	self assert: (scope getVar: 'foo') equals: 42.
	self assert: ((scope machines at: 'blah') scope getVar: 'foo') equals: 42
]

{ #category : #'action tests' }
LRPInterpretationTests >> testRunning [

	program := '
		(machine blah
			(state one
				(running [LRPTestSingleton instance: LRPTestSingleton instance + 1]))
			(on limit one -> two ot)
			(event limit [LRPTestSingleton instance = 2])
 	 		(state two)
 	 	)
		(spawn blah one)'.
	
	LRPTestSingleton instance: 0.
	
	interpreter interpret: (parser parse: program).
	
	"running action has not yet run"
	self assert: LRPTestSingleton instance = 0.
	interpreter stepRun.
	"running action has not yet run"
	self assert: LRPTestSingleton instance = 0.
	interpreter stepRun.
	"running action ran"
	self assert: LRPTestSingleton instance = 1.
	interpreter stepRun.
	"running action ran"
	self assert: LRPTestSingleton instance = 2.
	interpreter stepRun.
	"running action did not run"
	self assert: LRPTestSingleton instance = 2.
	interpreter stepRun.
	"running action did not run"
	self assert: LRPTestSingleton instance = 2.

]

{ #category : #'concurrency liveness tests' }
LRPInterpretationTests >> testSanityTwoMachinesNewProgram [
	| machines|
	
	program := '
	(machine m1
  		(state s1))
	(machine m2
  		(state s2))
	(spawn m1 s1)
	(spawn m2 s2)'.

	interpreter newProgram: (parser parse: program).
	
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	
	self assert: machines first currentState isNil.
	self assert: machines second currentState isNil.
	
	interpreter stepRun.
	self assert: machines first currentState name equals: 's1'.
	self assert: machines second currentState name equals: 's2'.
	
	program := '
	(machine m1
  		(state s1))
	(machine m2
  		(state s2))
	(spawn m1 s1)
	(spawn m2 s2)'.
	
	interpreter newProgram: (parser parse: program).
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	self assert: machines first currentState name equals: 's1'.
	self assert: machines second currentState name equals: 's2'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testSimpleNesting [
	| machine |
	
 	program := '
		(machine root
			(state first)
			(state second
				(machine nested
					(state blah)
					(state bleh)
					(eps blah -> bleh t2)
				)
				(onentry (spawn nested blah))
			)
			(eps first -> second t1)
		)
		(spawn root first)
	'.
	
	interpreter interpret: (parser parse: program).

	machine := interpreter runningMachine.
	self assert: machine name equals: 'root'.
	self assert: machine currentState isNil.
	
	"spawn the machine in the first state"
	interpreter stepRun.
	self assert: machine currentState name equals:'first'.

	"now enter the nested machine, the current step of the first machine stays at second"
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'blah'.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 'second'.
	self assert: machine currentState 
						runningMachines first name 
			equals: 'nested'.
	self assert: machine currentState 
						runningMachines first currentState name 
			equals: 'bleh'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testSingleMachine [
	
	program := '(machine foo)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	self assert: (scope machines at: 'foo') name = 'foo'.
]

{ #category : #'machine tests' }
LRPInterpretationTests >> testSpawnBeforeMachine [
	| machine |
	
 	program := '
		(spawn foo s)
		(machine foo
			(var x :=[1])
			(state s)
		)
	'.
	
	interpreter interpret: (parser parse: program).
	
	machine := interpreter runningMachine.
	self assert: machine name equals: 'foo'.
	self assert: machine currentState equals: nil.
	interpreter stepRun.
	
	machine := interpreter runningMachine.
	self assert: machine name equals: 'foo'.
	self assert: machine currentState name equals: 's'.
	self assert: (machine scope getVar: 'x') equals: 1.

]

{ #category : #'concurrency liveness tests' }
LRPInterpretationTests >> testSpawnSecondMachine [
	| machines m1 m2|
	
	program := '
	(machine m1
  		(state s1)
		(state s2)
		(eps s1 -> s2))
	(spawn m1 s1)'.

	interpreter newProgram: (parser parse: program).
	
	machines := interpreter runningMachines.
	self assert: machines size equals: 1.
	
	self assert: machines first currentState isNil.
	
	interpreter stepRun.
	interpreter stepRun.
	self assert: machines first currentState name equals: 's2'.
	
	program := '
	(machine m1
  		(state s1)
		(state s2)
		(eps s1 -> s2))
	(machine m2
  		(state s2))
	(spawn m1 s1)
	(spawn m2 s2)'.
	
	interpreter newProgram: (parser parse: program).
	machines := interpreter runningMachines.
	self assert: machines size equals: 2.
	
	m1 := machines detect: [ :m| m name = 'm1' ].
	m2 := machines detect: [ :m| m name = 'm2' ].
	self assert: m1 currentState name equals: 's2'.
	self assert: m2 currentState isNil.
	
	interpreter stepRun.
	self assert: m1 currentState name equals: 's2'.
	self assert: m2 currentState name equals: 's2'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testTimeoutTransitions [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
 	 		(ontime 200 one -> two t1)
			)
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
	
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testTimeoutTransitionsNoName [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
 	 		(ontime 200 one -> two )
			)
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = ''.
	
	
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testTopPlusDoubleNestedSameSpawn [
	|machine nestedMachines|
	
	program := '
	(machine m
  		(state s
			(machine nested1
				(state s1))	
			(onentry (spawn nested1 s1))
			(onentry (spawn n t))
		)
	)
	(machine n
			(state t))
	(spawn m s)
	(spawn n t)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 2.
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 's'.
	self assert: interpreter runningMachines second currentState name equals: 't'.
		
	nestedMachines := machine currentState runningMachines.
	self assert: nestedMachines size equals: 1.
	self assert: nestedMachines first name equals: 'nested1'.
	self assert: nestedMachines first currentState name equals: 's1'.

	self assert: interpreter runningMachines second currentState name equals: 't'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testTopPlusDoubleNestedSpawn [
	|machine nestedMachines|
	
	program := '
	(machine m
  		(state s
			(machine nested1
				(state s1))
			(machine nested2
				(state s2))	
			(onentry (spawn nested1 s1))
			(onentry (spawn nested2 s2))
		)
	)
	(machine n
			(state t))
	(spawn m s)
	(spawn n t)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 2.
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 's'.
	self assert: interpreter runningMachines second currentState name equals: 't'.
		
	nestedMachines := machine currentState runningMachines.
	self assert: nestedMachines size equals: 2.
	self assert: nestedMachines first name equals: 'nested1'.
	self assert: nestedMachines first currentState name equals: 's1'.
	self assert: nestedMachines second name equals: 'nested2'.
	self assert: nestedMachines second currentState name equals: 's2'.
	self assert: interpreter runningMachines second currentState name equals: 't'.
]

{ #category : #'concurrency tests' }
LRPInterpretationTests >> testTopPlusNestedSpawn [
	|machine nestedMachines|
	
	program := '
	(machine m
  		(state s
			(machine nested1
				(state s1)
			)
			(onentry (spawn nested1 s1))
		)
	)
	(machine n
			(state t))
	(spawn m s)
	(spawn n t)'.

	interpreter interpret: (parser parse: program).
	
	self assert: interpreter runningMachines size equals: 2.
	machine := interpreter runningMachines first.
	
	interpreter stepRun.
	self assert: machine currentState name equals: 's'.
	self assert: interpreter runningMachines second currentState name equals: 't'.
		
	nestedMachines := machine currentState runningMachines.
	self assert: nestedMachines size equals: 1.
	self assert: nestedMachines first name equals: 'nested1'.
	self assert: nestedMachines first currentState name equals: 's1'.

	self assert: interpreter runningMachines second currentState name equals: 't'.
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionStateWithSpawn [
	|machine stateToJump|
	
	program := self class forceStateMachineWithSpawn.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := interpreter runningMachine.
	stateToJump := machine states detect:[:aState| aState name = 'd'].
	
	interpreter stepRun.
	self assert: (machine currentState name = 'init').
	self assert: (scope getVar: 'count') == 1.
	
	interpreter transitionTo: stateToJump.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 3.
	
	interpreter stepRun.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 3.
	self assert: (scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionStateWithoutSpawn [
	|machine stateToJump|
	
	program := self class forceStateMachine.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	machine := scope machines at: 'Test'.
	stateToJump := machine states detect:[:aState| aState name = 'd'].
	
	
	interpreter transitionTo: stateToJump.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 1.
	self deny: (scope getVar: 'running') .
	
	interpreter stepRun.
	self assert: (machine currentState name = 'd').
	self assert: (scope getVar: 'count') == 1.
	self assert: (scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionToNestedMachineWithSpawn [
	|machine stateToJump|
	
	program := self class forceStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'nested']) 
								machines first states detect:[:aState| aState name = 'nestedB'] .
	
	interpreter stepRun.
	self assert: (machine currentState name = 'init').
	self assert: (scope getVar: 'count') == 1.
	
	interpreter transitionTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') equals: 3.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 3.
	self assert: (machine currentState runningMachines first scope getVar: 'running') .
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionToNestedMachineWithoutSpawn [
	|machine stateToJump|
	
	program := self class forceStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'nested']) 
								machines first states detect:[:aState| aState name = 'nestedB'] .
	
	interpreter transitionTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 1.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 1.
	self assert: (machine currentState runningMachines first scope getVar: 'running') .
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionToOutsideNestedMachineWithSpawn [
	"problem with static scope"
	
	|machine stateToJump|
	
	program := self class forceOutsideStateNestedMachineWithSpawn.
	
	interpreter interpret: (parser parse: program).
	machine := interpreter runningMachine.
	stateToJump := machine states detect:[:aState| aState name = 'c'].
	
	interpreter stepRun.
	interpreter stepRun.
	interpreter stepRun.
	interpreter stepRun.	
	
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'nested').
	self assert: (machine currentState runningMachines first currentState  name = 'nestedB').
	self assert: (machine currentState runningMachines first scope getVar: 'count') == 7.
	self deny: (machine currentState runningMachines first scope getVar: 'running') .
	
	interpreter stepRun.
	self assert:(machine scope getVar: 'running') .
	
	interpreter transitionTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'Test').
	self assert: (machine currentState name = 'c').
	self assert: (machine scope getVar: 'count')  == 9.
	self assert: (machine scope getVar: 'running') .
	
]

{ #category : #'forcing state tests' }
LRPInterpretationTests >> testTransitionToStateWithNestedMachine [
	|machine stateToJump|
	
	program := self class forceSpawnNestedStateMachine.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := interpreter runningMachine.
	stateToJump := (machine states detect:[:aState| aState name = 'first']).
	
	interpreter stepRun.
	self assert: (machine currentState name = 'second').
	
	interpreter transitionTo: stateToJump.
	machine := interpreter runningMachine.
	self assert: (machine name = 'top').
	self assert: (machine currentState name = 'first').
	self assert: (machine currentState runningMachines first currentState  name = 'nfirst').
	self assert: (scope getVar: 'test') 
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testVarSameMachineTimeoutTransitions [
	| machine |
	
	program := '
		(machine blah
			(var foo := [200])
	  		(state one)
	  		(state two)
	  		(ontime foo one -> two t1)
			)
		(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 300) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
	
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testVarSameMachineTimeoutTransitionsWChange [
	| machine |
	
	program := '
		(machine blah
			(var foo := [200])
	  		(state one
				(onexit [foo := 400])
			)
	  		(state two)
	  		(ontime foo one -> two t1)
			(ontime foo two -> one t2)
			)
		(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.

	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition name = 't2'.
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testVarTimeoutTransitions [
	| machine |
	
	program := '
		(var foo := [200])
		(machine blah
	  		(state one)
	  		(state two)
	  		(ontime foo one -> two t1)
			)
		(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 300) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
	
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testVarTimeoutTransitionsNoName [
	| machine |
	
	program := '
		(var foo := [200])
		(machine blah
	  		(state one)
	  		(state two)
	  		(ontime foo one -> two)
			)
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 300) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = ''.
	
	
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testVarTimeoutTransitionsWChange [
	| machine |
	
	program := '
		(var foo := [200])
		(machine blah
	  		(state one
				(onexit [foo := 400])
			)
	  		(state two)
	  		(ontime foo one -> two t1)
			(ontime foo two -> one t2)
			)
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.

	"when using slot var scope fails here because
	there is no indirection anymore in the interpreter
	of the change to the variable See: LRPTimeOutTransition>>checkWith:"
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	
	(Delay forMilliseconds: 200) wait.
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition name = 't2'.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableInit [	

	program := '
		(var foo := [42])
		(machine blah
			(var bar := [ LRPTestSingleton instance:69. 1])
			(state one (onentry [LRPTestSingleton instance: bar])))
		(var foo2 := [foo + 2])
		(spawn blah one)'.

	LRPTestSingleton instance: nil.		
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	"spawn has run"
	self assert: (scope getVar: 'foo') = 42.
	self assert: (scope getVar: 'foo2') = 44.
	self assert: LRPTestSingleton instance = 69.
	interpreter stepRun.
	"spawn has run -- onentry one has run"
	self assert: LRPTestSingleton instance = 1.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableInitEmptyBlock [

	program := '
	(machine blah
		(var foo:=[])
		(state one (onentry [LRPTestSingleton instance: foo])))
	(spawn blah one)'.

	LRPTestSingleton instance: 0.		
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	"spawn has run"
	interpreter stepRun.
	"spawn has run -- onentry one has run"
	self assert: LRPTestSingleton instance = nil.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableInitNestedMachine [

	program := '
		(var foo := [42])
		(machine out
			(var bar := [ LRPTestSingleton instance:69. 1])
			(state one (onentry [LRPTestSingleton instance: bar]))
			(state two
				(machine in
					(var quux := [LRPTestSingleton instance: 75. 2])
					(state three (onentry [LRPTestSingleton instance: quux. quux := 0 ])))
				(onentry (spawn in three))
			)
			(eps one -> two)
			(eps two -> one)
		)
		(spawn out one)'.

	LRPTestSingleton instance: nil.		
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	"spawn has run"
	self assert: (scope getVar: 'foo') = 42.
	self assert: LRPTestSingleton instance = 69.
	interpreter stepRun.
	"spawn has run -- onentry one has been run"
	self assert: LRPTestSingleton instance = 1.
	interpreter stepRun.
	"transition has been taken -- onentry three has been run"
	self assert: LRPTestSingleton instance = 2.
	interpreter stepRun.
	"transition has been taken -- onentry one has been run"
	self assert: LRPTestSingleton instance = 1.
	interpreter stepRun.
	"transition has been taken -- onentry three has been run
	if this is 0 then initialization has not happened"
	self assert: LRPTestSingleton instance = 2.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableInterBlockAccess [
	
	program := '
		(var foo := [42])
		(machine blah
			(state one (onentry [foo := 0]))
			(state two (onentry [LRPTestSingleton instance: foo]))
			(eps one -> two t1)
			)
		(spawn blah one)'.

	LRPTestSingleton instance: nil.
	
	interpreter interpret: (parser parse: program).

	interpreter stepRun.
	"in the one state"
	interpreter stepRun.
	"in the two state"
	self assert: LRPTestSingleton instance = 0.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableReInitNestedMachine [

	program := '
		(machine out
			(var bar := [ LRPTestSingleton instance:69. 1])
			(state one (onentry [LRPTestSingleton instance: bar]))
			(state two
				(machine in
					(var quux := [LRPTestSingleton instance: 75. 2])
					(state three
						(onentry [
							LRPTestSingleton instance: quux.
							bar := 3.
							quux := 4])))
				(onentry (spawn in three))
			)
			(eps one -> two)
			(eps two -> one)
		)
		(spawn out one)'.

	LRPTestSingleton instance: nil.		
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	"spawn has run"
	self assert: LRPTestSingleton instance = 69.
	interpreter stepRun.
	"spawn has run -- onentry one has been run"
	self assert: LRPTestSingleton instance = 1.
	interpreter stepRun.
	"transition has been taken -- onentry three has been run"
	self assert: LRPTestSingleton instance = 2.
	interpreter stepRun.
	"transition has been taken -- onentry one has been run"
	self assert: LRPTestSingleton instance = 3. "to be sure assignment works"
	interpreter stepRun.
	"transition has been taken -- onentry three has been run"
	self assert: LRPTestSingleton instance = 2. "because var has been reinit"
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableReadInAction [
	
	program := '
		(var foo := [42])
		(machine blah
			(state one (onentry [LRPTestSingleton instance: foo])))
		(spawn blah one)'.

	LRPTestSingleton instance: nil.
	
	interpreter interpret: (parser parse: program).

	"onentry action has not yet run"
	self deny: LRPTestSingleton instance = 42.
	interpreter stepRun.
	"onentry action has run"
	self assert: LRPTestSingleton instance = 42.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableReadInEvent [
	| machine |
	
	program := '
		(machine blah
			(var bar := [true])
	  		(state one)
	  		(state two)
	  		(on foo one -> two t1)
			(event foo [bar]))
		(spawn blah one)'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	self assert: machine triggeredTransition isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableReadWScopeInAction [
	
	program := '
		(var foo := [42])
		(machine blah
			(var bar := [0])
			(state one (onentry [LRPTestSingleton instance: { foo . bar }])))
		(spawn blah one)'.

	LRPTestSingleton instance: {nil . nil}.
	
	interpreter interpret: (parser parse: program).

	"onentry action has not yet run"
	self assert: LRPTestSingleton instance = {nil . nil}.
	interpreter stepRun.
	"onentry action has run"
	self assert: LRPTestSingleton instance = {42 . 0}.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableSanity [
	"sanity check"

	program := '
		(var foo := [42])
		(var bar := [1])
		(var quux := [LRPTestSingleton instance])'.
		
	LRPTestSingleton instance: 'asdf'.
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	self assert: (scope getVar: 'foo') equals: 42.
	self assert: (scope getVar: 'bar') equals: 1.
	self assert: (scope getVar: 'quux') equals: LRPTestSingleton instance
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableUseBeforeAdd [
	| oldProgram |
	oldProgram := '
		(machine blah
			(state one
				(running [bar := 1 + bar]))
		)
		(spawn blah one)
	'.
	
	program := '
		(machine blah
		   (var bar := [1])
			(state one
				(running [bar := 1 + bar]))
		)
		(spawn blah one)
	'.
	interpreter newProgram: 	(parser parse: oldProgram).
	interpreter stepRun.
	"sanity check"
	self assert: interpreter runningMachine currentState name equals: 'one'.
	
	interpreter newProgram: 	(parser parse: program).
	interpreter stepRun.
	"sanity check"
	self assert: interpreter runningMachine currentState name equals: 'one'.
	
	self assert: (interpreter runningMachine scope getVar: 'bar') equals: 2.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableUseBeforeDefine [
	
	program := '
		(machine blah
			(state one
				(onentry [bar := 1 + bar]))
			(var bar := [1])
		)
		(spawn blah one)
	'.
	interpreter interpret: 	(parser parse: program).
	interpreter stepRun.
	self assert: (interpreter runningMachine scope getVar: 'bar') = 2.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableUseOutsideNestedMachineScope [
	
	program := '
		(var foo := [1])
		(machine blah
			(state one)
			(state two 
				(machine nested
					(var bar := [1])
					(state nestedOne)
				)
				(onentry (spawn nested nestedOne))
			)
			(state three)
			(eps one -> two t1)
			(eps two -> three t2)
		)
		(spawn blah one)'.
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	
	self assert: (scope getVar: #bar) equals: nil.
	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'one'.
	self assert: (scope getVar: #bar) equals: nil.
	
	interpreter stepRun.
	self 
		assert: 
			interpreter runningMachine currentState 
				runningMachines first currentState name 
		equals: 'nestedOne'.
	self assert: (scope getVar: #bar) equals: nil.
	
	interpreter stepRun.
	self assert: interpreter runningMachine currentState name equals: 'three'.
	self assert: (scope getVar: #bar) equals: nil.

]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableWriteInAction [
	
	program := '
		(var foo := [1])
		(machine blah
			(state one (onentry [foo := LRPTestSingleton instance])))
		(spawn blah one)'.

	LRPTestSingleton instance: 42.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	"onentry action has not yet run"
	self assert: (scope getVar: 'foo') == 1.
	interpreter stepRun.
	"onentry action has run"
	self assert: (scope getVar: 'foo') == 42.
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariableWriteWScopeInAction [
	
	program := '
		(var foo := [1])
		(machine blah
			(var bar := [0])
			(state one (onentry [
				foo := (LRPTestSingleton instance at: 1).
				bar := (LRPTestSingleton instance at: 2)
				])))
		(spawn blah one)'.

	LRPTestSingleton instance: {42 . 43}.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	interpreter stepRun.
	self assert: (scope getVar: 'foo') =  (LRPTestSingleton instance at: 1).
	self assert: ((scope machines at: 'blah') scope getVar: 'bar') = (LRPTestSingleton instance at: 2).
]

{ #category : #'variable tests' }
LRPInterpretationTests >> testVariablesInScopeOf [
	| vars  parsed |
	program := '
		(var q:=[1])
		(machine m
			(var b:=[2])
			(var c:=[3])
			(state s)
			(state t
				(machine n
					(var a:=[4])
					(state u))
				(onentry (spawn n u))) 
			(eps s->t st))
		(machine z
			(var x:=[5]))
		(spawn m s)
'.

	parsed := parser parse: program.
	interpreter newProgram: parsed.
	interpreter stepRun.

	"check for machine m"
	vars := (interpreter variablesInScopeOf: parsed second) collect: [:item | item key name]. 
	self assert: (vars hasEqualElements: { 'q' . 'b' . 'c' }).
	
	"check for machine z"
	vars := (interpreter variablesInScopeOf: parsed third) collect: [:item | item key name]. 
	self assert: (vars hasEqualElements: { 'q' . 'x' }).
	
	"check for machine n"
	interpreter stepRun.
	vars := (interpreter variablesInScopeOf: (parsed second states second machines first)) collect: [:item | item key name].
	self assert: (vars hasEqualElements: {  'q' . 'b' . 'c' . 'a'}).

]

{ #category : #'transition tests' }
LRPInterpretationTests >> testWCTransitions [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
	  		(on foo *-> two t1)
			(event foo [true]))
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = 't1'.
]

{ #category : #'transition tests' }
LRPInterpretationTests >> testWCTransitionsNoName [
	| machine |
	
	program := '
		(machine blah
	  		(state one)
	  		(state two)
	  		(on foo *-> two )
			(event foo [true]))
		(spawn blah one)'.

	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	machine := scope machines at: 'blah'.
	self assert: machine currentState isNil.
	
	interpreter stepRun.
	self assert: machine currentState name = 'one'.
	
	interpreter stepRun.
	self assert: machine currentState name = 'two'.
	self assert: machine triggeredTransition name = ''.
]
