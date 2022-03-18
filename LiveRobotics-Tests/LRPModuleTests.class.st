Class {
	#name : #LRPModuleTests,
	#superclass : #LRPAbstractInterpretationTests,
	#instVars : [
		'program2'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #'import export' }
LRPModuleTests >> testExport [
	| lrpp |
	
	program :='
		(export foo)
		(machine foo)
		(machine bar)
		(machine quux)
		(export bar)
		(export baz)'.
	
	lrpp := LRPProgram fromSource: program.

	self assert: (lrpp exportedMachines collect: [ :m | m name ])
		equals: (OrderedCollection with: 'foo' with: 'bar')

]

{ #category : #'import export' }
LRPModuleTests >> testImportDoesntParse [
	| lrpp |

	program := '
		(machine blah
			(state one))
		(spawn blah one)'.

	program2 :='asdf'.

	lrpp := LRPProgram withAST: (parser parse: program) andImports: 
				{LRPProgram withAST: (parser parse: program2)}.

	self assert: (lrpp resolvedImports isEmpty).
		
]

{ #category : #'import export' }
LRPModuleTests >> testImportReading [
	| file lrpp |

	program := '(import ''auto_gen_test1.lrp'')(import ''auto_gen_test2.lrp'')'.
	program2 := '(export x) (machine x (state s))'	.

	file := LRPInterpreter lrpRootPath asFileReference resolve: 'auto_gen_test1.lrp'.
	
	lrpp := [
		file writeStreamDo: [ :str | str nextPutAll: program2 ].
		LRPProgram fromSource: program.
	] ensure: [file ensureDelete].

	self assert: lrpp imports size equals: 1.
	self assert: lrpp imports first ast first class equals: LRPExport.
]

{ #category : #'import export' }
LRPModuleTests >> testImportResolution [
	| lrpp program3 program4|

	program := '
		(machine blah
			(state one))
		(spawn blah one)'.

	program2 :='
		(export foo2)
		(export foo)
		(machine foo)
		(machine foo2)'.
	
	program3 := '
		(export bar)
	   (export bar2)
		(machine bar2)
		(machine bar)
		'.

	program4 := '
		(export quux)
	   (export quux2)
		(machine quux)
		(machine quux2)
		'.


	lrpp := LRPProgram withAST: (parser parse: program) andImports: 
				{LRPProgram withAST: (parser parse: program2) andImports: 
						{LRPProgram withAST: (parser parse: program3)}
				. LRPProgram withAST: (parser parse: program4)}.

	self assert: (lrpp resolvedImports collect: [ :m | m name ])
		equals: (OrderedCollection
					with: 'foo' with: 'foo2'
					with: 'quux' with: 'quux2'
					with: 'bar2' with: 'bar').
		
]

{ #category : #'import export' }
LRPModuleTests >> testImportStructure [
	"imports should build a tree structure.
	if testImportReading does not work, neither will this one."
	| programs lrpp node |
	
	program := '(import ''a.lrp'') (machine m)'.
	programs := { 
		'a.lrp' -> '(import ''b.lrp'')(machine ma) (import ''c.lrp'') 	' .
		'b.lrp' -> '(machine mb)' .
		'c.lrp' -> '(import ''d.lrp'') (machine mc)' .
		'd.lrp' -> '(machine md)'
	} asDictionary.

	lrpp := [
		programs keysAndValuesDo:  [:key :val | | file |
			file := LRPInterpreter lrpRootPath asFileReference resolve: key.
			file writeStreamDo: [ :str | str nextPutAll: val ]].
		LRPProgram fromSource: program.
	] ensure:
	[  
		programs keysDo: [:key | | file |
			file := LRPInterpreter lrpRootPath asFileReference resolve: key.
			file ensureDelete ].		
	].	

	self assert: lrpp ast second name equals: 'm'.
	self assert: lrpp imports size equals: 1.
	
	node := lrpp imports first.
	
	self assert: node ast second name equals: 'ma'.
	self assert: node imports size equals: 2.
	
	self assert: node imports first ast first name equals: 'mb'.
	self assert: node imports first imports isEmpty.
	
	node := node imports second. 
	self assert: node ast second name equals: 'mc'.
	self assert: node imports size equals: 1.
	
	node := node imports first.
	self assert: node ast first name equals: 'md'.
	self assert: node imports isEmpty.

]

{ #category : #interpretation }
LRPModuleTests >> testLocalDecOverrides [
	"a machine from this program overrides a machine of the same name that was imported "

	LRPTestSingleton instance: 0.
	
	program := '
		(machine blah
			(state one
				(onentry (spawn bar bs))))
		(spawn blah one)
		(machine bar
			(state bs
				(onentry [LRPTestSingleton instance: 1])))
		'.

	program2 :='
		(export bar)
		(machine bar
			(state bs
				(onentry [LRPTestSingleton instance: 2])))'.

	interpreter interpretProgram:
		(LRPProgram withAST: (parser parse: program) andImports: 
			{LRPProgram withAST: (parser parse: program2)}).

	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: 1.


]

{ #category : #interpretation }
LRPModuleTests >> testMachineIsolation [
	"a machine from a module that does a spawn of a machine that is a global of that module
	 it should spawn from the environment that imported it "

	LRPTestSingleton instance: 0.
	
	program := '
		(machine blah
			(state one
				(onentry (spawn foo fs))))
		(spawn blah one)
		(machine bar
			(state bs
				(onentry [LRPTestSingleton instance: 1])))
		'.

	program2 :='
		(export foo)
		(export bar)
		(machine foo
			(state fs
				(onentry (spawn bar bs))))
		(machine bar
			(state bs
				(onentry [LRPTestSingleton instance: 2])))'.

	interpreter 	interpretProgram: 
		(LRPProgram withAST: (parser parse: program) andImports:
			{LRPProgram withAST: (parser parse: program2)}).

	"nesting: blah -> one -> foo -> fs -> bar The latter from program1"
	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: 1.

]

{ #category : #interpretation }
LRPModuleTests >> testNoImport [
	| main |
	
	program := '
		(machine blah
			(state one
				(machine foo
					(state fs))
				(onentry (spawn foo fs))))
		(spawn blah one)'.

	interpreter
		interpretProgram: (LRPProgram fromSource: program).

	interpreter stepRun.
	main := interpreter runningMachine.

	self assert: (main currentState name) equals: 'one'.
	self assert: (main currentState runningMachines first name) equals: 'foo'.
	self assert: (main currentState runningMachines first currentState name) equals: 'fs'.

]

{ #category : #interpretation }
LRPModuleTests >> testOrchestrationFromOutside [
	
	LRPTestSingleton instance: false.
	
	program := '
		(machine blah
			(state one
				(onentry (spawn foo fs)))
			(state two
				(onentry [LRPTestSingleton instance: nil]))
			(on [LRPTestSingleton instance] one -> two)
			)
		(spawn blah one)'.

	program2 :='
		(export foo)
		(machine foo
			(state fs
				(running [LRPTestSingleton instance: true]))
			)'.

	interpreter interpretProgram: 
		(LRPProgram withAST: (parser parse: program) andImports: 
			{LRPProgram withAST: (parser parse: program2)}).

	self assert: LRPTestSingleton instance equals: false.
	"spawn up to the fs state"
	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: false.
	"execute running of fs state"
	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: true.
	"go to the two state"
	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: nil.
	
]

{ #category : #interpretation }
LRPModuleTests >> testRecursiveInclusion [
	| program3 |
	"test that interpretation of recursive inclusion works"
	
	LRPTestSingleton instance: 0.
	program := '
		(machine blah
			(state one
				(onentry (spawn foo fs))))
		(spawn blah one)'.

	program2 :='
		(export foo)
		(machine foo
			(state fs
				(onentry (spawn bar bs))))'.
	
	program3 := '
		(export bar)
		(machine bar
			(state bs (onentry [LRPTestSingleton instance: 2])))'.

	interpreter	interpretProgram:
			(LRPProgram withAST: (parser parse: program) andImports: 
				{LRPProgram withAST: (parser parse: program2) andImports: 
					{LRPProgram withAST: (parser parse: program3)}}).

	self assert: LRPTestSingleton instance equals: 0.
	interpreter stepRun.
	self assert: LRPTestSingleton instance equals: 2.

]

{ #category : #interpretation }
LRPModuleTests >> testSpawn [
	| main |
	
	program := '
		(machine blah
			(state one
				(onentry (spawn foo fs))))
		(spawn blah one)'.

	program2 :='
		(export foo)
		(machine foo
			(state fs)
			)'.

	interpreter interpretProgram:
		(LRPProgram withAST: (parser parse: program) andImports: 
			{LRPProgram withAST: (parser parse: program2)}).

	interpreter stepRun.
	main := interpreter runningMachine.

	self assert: (main currentState name) equals: 'one'.
	self assert: (main currentState runningMachines first name) equals: 'foo'.
	self assert: (main currentState runningMachines first currentState name) equals: 'fs'.

]

{ #category : #interpretation }
LRPModuleTests >> testVariableIsolation [
	| main |
	
	program := '
		(var t:=[1])
		(machine blah
			(var b:=[2])
			(state one
				(onentry (spawn foo fs))))
		(spawn blah one)'.

	program2 :='
		(export foo)
		(var t2:=[21])
		(machine foo
			(var b2:=[22])
			(state fs)
			)'.

	interpreter	interpretProgram: 
		(LRPProgram withAST: (parser parse: program) andImports:
			{LRPProgram withAST: (parser parse: program2)}).

	interpreter stepRun.
	main := interpreter runningMachine.
	self assert: (main scope getVar: 't') equals: 1.
	self assert: (main scope getVar: 'b') equals: 2.
	self assert: (main scope getVar: 't2') equals: nil.
	self assert: (main scope getVar: 'b2') equals: nil.

	self assert: (main currentState runningMachines first scope getVar: 't2') equals: nil.
	self assert: (main currentState runningMachines first scope getVar: 'b2') equals: 22.
	self assert: (main currentState runningMachines first scope getVar: 't') equals: 1.
	self assert: (main currentState runningMachines first scope getVar: 'b') equals: nil.

]
