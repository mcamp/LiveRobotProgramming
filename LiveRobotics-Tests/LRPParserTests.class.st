Class {
	#name : #LRPParserTests,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'program',
		'tree'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #running }
LRPParserTests >> setUp [
	parser := LRPParser compiledParser.
]

{ #category : #'grammar-sugar' }
LRPParserTests >> testBlockSugarTransition [
	| t1 t2 e1 e2 |
	program := '(machine ma (on [ true ] one -> two) (on [ false ] two -> three tt))'.
	tree := parser parse: program.
	
	self assert: tree size equals: 1.
	tree := tree first body.
	self assert: tree size equals: 4.
	
	t1 := tree at: 1.
	e1 := tree at: 2.
	t2 := tree at: 3.
	e2 := tree at: 4.
	
	self assert: t1 name equals: ''.
	self assert: t1 from equals: 'one'.
	self assert: t1 to equals: 'two'.
	
	self assert: (t1 eventname at: 1) equals: $$.
	self assert: (e1 name at: 1) equals: $$.
	self assert: e1 name equals: t1 eventname.
	self assert: e1 trigger formattedCode equals: '[ true ]'.
	
	self assert: t2 name equals: 'tt'.
	self assert: t2 from equals: 'two'.
	self assert: t2 to equals: 'three'.
	
	self assert: (t2 eventname at: 1) equals: $$.
	self assert: (e2 name at: 1) equals: $$.
	self assert: e2 name equals: t2 eventname.
	self deny: e2 name = e1 name.
	self assert: e2 trigger formattedCode equals: '[ false ]'
]

{ #category : #'grammar-sugar' }
LRPParserTests >> testBlockSugarWildcard [
	| t1 t2 e1 e2 |
	program := '(machine ma (on [ true ] *-> two) (on [ false ] *-> three tt))'.
	tree := parser parse: program.
	
	self assert: tree size equals: 1.
	tree := tree first body.
	self assert: tree size equals: 4.
	
	t1 := tree at: 1.
	e1 := tree at: 2.
	t2 := tree at: 3.
	e2 := tree at: 4.
	
	self assert: t1 name equals: ''.
	self assert: t1 from equals: '*'.
	self assert: t1 to equals: 'two'.
	
	self assert: (t1 eventname at: 1) equals: $$.
	self assert: (e1 name at: 1) equals: $$.
	self assert: e1 name equals: t1 eventname.
	self assert: e1 trigger formattedCode equals: '[ true ]'.
	
	self assert: t2 name equals: 'tt'.
	self assert: t2 from equals: '*'.
	self assert: t2 to equals: 'three'.
	
	self assert: (t2 eventname at: 1) equals: $$.
	self assert: (e2 name at: 1) equals: $$.
	self assert: e2 name equals: t2 eventname.
	self deny: e2 name = e1 name.
	self assert: e2 trigger formattedCode equals: '[ false ]'
]

{ #category : #'grammar-comments' }
LRPParserTests >> testComment [
	
	program := '
; This is like totally a comment
(machine dude
	; gag me with a spoon!
	(state tubular)
)'.
	tree := parser parse: program.		
	self assert: tree size = 2.
	
	self assert: tree first text = ' This is like totally a comment'.
	self assert: tree first start = 2.
	self assert: tree first stop = 34.
	
	tree := tree second body.
	self assert: tree size = 2.
			
	self assert: tree first text = ' gag me with a spoon!'.
	self assert: tree first start = 50.
	self assert: tree first stop = 72.

]

{ #category : #'grammar-concurrency' }
LRPParserTests >> testDoubleSpawn [
	|spawn1 spawn2|
	program := '
	(machine m1 
		(state s1))
	(machine m2
		(state s2))
	(spawn m1 s1)
	(spawn m2 s2)'.
	tree := parser parse: program.
	self assert: tree size equals: 4.
	spawn1 := tree third.
	spawn2 := tree fourth.
	
	self assert: spawn1 machine equals: 'm1'.
	self assert: spawn1 state equals: 's1'.
	
	self assert: spawn2 machine equals: 'm2'.
	self assert: spawn2 state equals: 's2'.

]

{ #category : #'grammar-transitions' }
LRPParserTests >> testEpsilon [
	| t1 t2 |

	program := '(machine ma (eps one -> two) (eps two -> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.

	self assert: t1 name = ''.
	self assert: t1 from = 'one'.
	self assert: t1 to = 'two'.
	
	self assert: t2 name = 'tt'.
	self assert: t2 from = 'two'.
	self assert: t2 to = 'three'.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  28.
	self assert: t1 nameRange = (1 to: 1). 
	self assert: t1 arrowRange = (21 to: 24).
	
	self assert: t2 start = 30.
	self assert: t2 stop = 50.
	self assert: t2 nameRange =  (48 to: 49). 
	self assert: t2 arrowRange = (38 to: 41).
]

{ #category : #grammar }
LRPParserTests >> testEvent [
	
	program := '(machine ma (event ev [false]))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body first.

	
	self assert: tree name =  'ev'.
	self assert: tree trigger class = RBBlockNode.
	self assert: tree trigger formattedCode = '[ false ]'.

	self assert: tree start = 13.
	self assert: tree stop =  30.
	self assert: tree nameRange = (20 to: 21). 
]

{ #category : #'grammar-sugar' }
LRPParserTests >> testExitSemantics [
	| interpreter |
	
	LRPTestSingleton instance: 0.
	program := '(machine m
		(state s
			(machine n
				(var out := [true])
				(event xev [out])
				(exit xev a->t)
				(state a (onentry [LRPTestSingleton instance: 1])))
			(onentry (spawn n a)))
		(state t (onentry [LRPTestSingleton instance: 2])))
	(spawn m s)'.

	interpreter := LRPInterpreter new.
	interpreter interpret: (parser parse: program).

	"spawn s and a. generated var is false"
	interpreter stepRun.	
	self assert: LRPTestSingleton instance = 1.
	self deny: (interpreter runningMachine scope allVariables first) value.

	"go to the generated exit state. generated var is true"
	interpreter stepRun.
	self assert: (interpreter runningMachine scope allVariables first) value.
	
	"take the top-level wildcard transition. generated var is false"
	interpreter stepRun.
	self assert: LRPTestSingleton instance = 2.
	self deny: (interpreter runningMachine scope allVariables first) value.

]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionAction [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the := operation (assignment node)"
	node := tree findBestLRPNodeFor: 64.
	
	self assert: (node class = LRPRunning).
	self assert: (node block class = RBBlockNode).
]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionEvent [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
			(event true [true])
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the event node"
	node := tree findBestLRPNodeFor: 88.
	
	self assert: (node class = LRPEvent).
]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionMachine [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the machine name"
	node := tree findBestLRPNodeFor: 32.
	
	self assert: (node class = LRPMachine).
]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionSpawn [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the spawn node"
	node := tree findBestLRPNodeFor: 90.
	
	self assert: (node class = LRPSpawn).
]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionState [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the state name"
	node := tree findBestLRPNodeFor: 44.
	
	self assert: (node class = LRPMachine).
]

{ #category : #nodes }
LRPParserTests >> testFindBestNodeForCursorPositionVariable [
	|node|
	program := '
		(var foo := [0])
		(machine a
			(state s
				(running [foo := foo + 1])
			)
		)
		(spawn a s)
	'.

	tree := parser parse: program.
	"the cursor is in the first var declaration"
	node := tree findBestLRPNodeFor: 8.
	
	self assert: (node class = LRPVariable ).
	self assert: (node value class = RBBlockNode).
]

{ #category : #grammar }
LRPParserTests >> testMachine [
	
	program := '(machine ma)'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first.
		
	self assert: tree name = 'ma'.
	self assert: tree body = OrderedCollection new.

	self assert: tree start = 1.
	self assert: tree stop = 12.
	self assert: tree nameRange =  (10 to: 11). 
]

{ #category : #grammar }
LRPParserTests >> testOnEntry [
	|soe toe|
	program := '(machine ma (state s (onentry [0])) (state t (onentry (spawn non existant))))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	soe := tree first body first body first.
	toe := tree first body second body first.
	
	self assert: soe block class = RBBlockNode.
	self assert: soe block formattedCode = '[ 0 ]'.

	self assert: toe block class = LRPSpawn.
	self assert: toe block machine = 'non'.
	self assert: toe block state = 'existant'.
	
	self assert: soe start = 22.
	self assert: soe stop = 34.

	self assert: toe start = 46.
	self assert: toe stop = 75.

]

{ #category : #'grammar-concurrency' }
LRPParserTests >> testOnEntrySpawns [
	|spawn1 spawn2|
	program := '
	(machine ma  
		(state t 
			(onentry (spawn non existant))
			(onentry (spawn another machine))
		)
	)'.
	tree := parser parse: program.
	self assert: tree size equals: 1.
	spawn1 := tree first body first body first.
	spawn2 := tree first body first body second.
	
	self assert: spawn1 block class equals: LRPSpawn.
	self assert: spawn1 block machine equals: 'non'.
	self assert: spawn1 block state equals: 'existant'.
	
	self assert: spawn2 block class equals: LRPSpawn.
	self assert: spawn2 block machine equals: 'another'.
	self assert: spawn2 block state equals: 'machine'.



]

{ #category : #grammar }
LRPParserTests >> testOnExit [
	|soe|
	program := '(machine ma (state s (onexit [1])))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	soe := tree first body first body first.
	
	self assert: soe block class = RBBlockNode.
	self assert: soe block formattedCode = '[ 1 ]'.
	
	self assert: soe start = 22.
	self assert: soe stop = 33.

]

{ #category : #'grammar-sugar' }
LRPParserTests >> testPullUpContainer [
	| machine state newbody cont up |
	program := '(machine m (state s (machine n (state t))))'.
	tree := parser parse: program.
	
	up := (LRPComment text: 'PU').
	cont := LRPNodePullUpContainer on: up.
	state := ((tree at: 1) body at: 1).
	machine := (state body at: 1).
	machine body: (machine body asOrderedCollection).
	machine body add: cont.
	
	newbody := parser processBody: (tree at: 1) body.
		
	self assert: (newbody includes: up).
	self deny: (machine body includes: cont).
	  
]

{ #category : #grammar }
LRPParserTests >> testRunning [
	|sru|
	program := '(machine ma (state s (running [2])))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	sru := tree first body first body first.
	
	self assert: sru block class = RBBlockNode.
	self assert: sru block formattedCode = '[ 2 ]'.
	
	self assert: sru start = 22.
	self assert: sru stop = 34.

]

{ #category : #grammar }
LRPParserTests >> testSpawn [
	
	program := '(machine ma (state one))(spawn ma one)'.
	tree := parser parse: program.
	self assert: tree size = 2.
	tree := tree second.
	
	self assert: tree machine = 'ma'.
	self assert: tree state = 'one'.

	self assert: tree start = 25.
	self assert: tree stop = 38.
	self assert: tree nameRange = (32 to: 37). 

]

{ #category : #grammar }
LRPParserTests >> testState [
	
	program := '(machine ma (state one) (state two))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	
	self assert: tree size = 2.
	self assert: tree first name = 'one'.
	self assert: tree first body = #().
	
	self assert: tree second name = 'two'.
	self assert: tree second body = #().

	self assert: tree first start = 13.
	self assert: tree first stop =  23.
	self assert: tree first nameRange = (20 to: 22). 
	
	self assert: tree second start = 25.
	self assert: tree second stop = 35.
	self assert: tree second nameRange =  (32 to: 34). 
]

{ #category : #'grammar-transitions' }
LRPParserTests >> testTimeoutIdentifier [
	| t1 t2 |

	program := '(machine ma (ontime id1 one -> two) (ontime id2 two -> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.

	self assert: t1 name = ''.
	self assert: t1 from = 'one'.
	self assert: t1 to = 'two'.
	self assert: t1 eventname = 'id1'.
	
	self assert: t2 name = 'tt'.
	self assert: t2 from = 'two'.
	self assert: t2 to = 'three'.
	self assert: t2 eventname = 'id2'.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  35.
	self assert: t1 nameRange = (1 to: 1). 
	self assert: t1 arrowRange = (28 to: 31).
	
	self assert: t2 start = 37.
	self assert: t2 stop = 64.
	self assert: t2 nameRange =  (62 to: 63). 
	self assert: t2 arrowRange = (52 to: 55).
]

{ #category : #'grammar-transitions' }
LRPParserTests >> testTimeoutInteger [
	| t1 t2 |

	program := '(machine ma (ontime 1 one -> two) (ontime 2 two -> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.
	
	self assert: t1 name = ''.
	self assert: t1 from = 'one'.
	self assert: t1 to = 'two'.
	self assert: t1 eventname = 1.
	
	self assert: t2 name = 'tt'.
	self assert: t2 from = 'two'.
	self assert: t2 to = 'three'.
	self assert: t2 eventname = 2.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  33.
	self assert: t1 nameRange = (1 to: 1). 
	self assert: t1 arrowRange = (26 to: 29).
	
	self assert: t2 start = 35.
	self assert: t2 stop = 60.
	self assert: t2 nameRange =  (58 to: 59). 
	self assert: t2 arrowRange = (48 to: 51).
]

{ #category : #'grammar-transitions' }
LRPParserTests >> testTimeoutMissingTime [
	| t1 t2 |

	program := '(machine ma (ontime one -> two) (ontime two -> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.
	
	self assert: t1 class equals: LRPErrorNode.
	self assert: t2 class equals: LRPErrorNode.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  31.
	self assert: t2 start = 33.
	self assert: t2 stop = 56.

]

{ #category : #'grammar-transitions' }
LRPParserTests >> testTransition [
	| t1 t2 |

	program := '(machine ma (on e1 one -> two) (on e2 two -> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.
	
	self assert: t1 name = ''.
	self assert: t1 from = 'one'.
	self assert: t1 to = 'two'.
	self assert: t1 eventname = 'e1'.
	
	self assert: t2 name = 'tt'.
	self assert: t2 from = 'two'.
	self assert: t2 to = 'three'.
	self assert: t2 eventname = 'e2'.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  30.
	self assert: t1 nameRange = (1 to: 1). 
	self assert: t1 arrowRange = (23 to: 26).
	
	self assert: t2 start = 32.
	self assert: t2 stop = 54.
	self assert: t2 nameRange =  (52 to: 53). 
	self assert: t2 arrowRange = (42 to: 45).
]

{ #category : #grammar }
LRPParserTests >> testVariable [

	program := '	(var foo := [42])'.
	
	tree := parser parse: program.
	
	self assert: tree size = 1.
	tree := tree first.
	
	self assert: tree class = LRPVariable.
	self assert: tree name = 'foo'.
	self assert: tree value class = RBBlockNode.
	self assert: tree value formattedCode = '[ 42 ]'.
	
	self assert: tree start = 2.
	self assert: tree stop = 18.
	self assert: tree nameRange = (7 to: 9).
	
]

{ #category : #'grammar-transitions' }
LRPParserTests >> testWildcard [
	| t1 t2 |

	program := '(machine ma (on e1 *-> two) (on e2 *-> three tt))'.
	tree := parser parse: program.
	self assert: tree size = 1.
	tree := tree first body.
	self assert: tree size = 2.
	
	t1 := tree first.
	t2 := tree second.
	
	self assert: t1 name = ''.
	self assert: t1 from = '*'.
	self assert: t1 to = 'two'.
	self assert: t1 eventname = 'e1'.
	
	self assert: t2 name = 'tt'.
	self assert: t2 from = '*'.
	self assert: t2 to = 'three'.
	self assert: t2 eventname = 'e2'.
	
	self assert: t1 start = 13.
	self assert: t1 stop =  27.
	self assert: t1 nameRange = (1 to: 1). 
	self assert: t1 arrowRange = (19 to: 23).
	
	self assert: t2 start = 29.
	self assert: t2 stop = 48.
	self assert: t2 nameRange =  (46 to: 47). 
	self assert: t2 arrowRange = (35 to: 39).
]
