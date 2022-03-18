Class {
	#name : #LRPBridgeTests,
	#superclass : #LRPAbstractInterpretationTests,
	#instVars : [
		'bridge'
	],
	#category : #'LiveRobotics-Bridge-Tests'
}

{ #category : #'bridge var' }
LRPBridgeTests class >> bridgeInstance [

	^LRPMockBridge new
]

{ #category : #running }
LRPBridgeTests >> setUp [

	super setUp.
	bridge := self class bridgeInstance.
	interpreter bridgeInstance: bridge.
]

{ #category : #running }
LRPBridgeTests >> tearDown [

	super tearDown.
	bridge cleanUp.
]

{ #category : #'variable tests' }
LRPBridgeTests >> testRobotVarNestedMachine [
	|innerMachine innerScope|

	program := '
		(machine root
			(state init
				(machine inner
					(var test := [1])
					(state foo)
				)
			(onentry (spawn inner c))
			)
		)
		(spawn root init)
	'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.
	
	innerMachine := (scope machines at: #root) scope machines at: #inner.
	innerScope := innerMachine scope.
	
	interpreter stepRun.
	
	self assert: (innerScope getVar: #robot) value isNotNil.
	
]

{ #category : #'variable tests' }
LRPBridgeTests >> testRobotVarPresence [
	|robot|
	
	program := '
		(var r := [robot])
		(var foo := [42])
	'.
	
	interpreter interpret: (parser parse: program).
	scope := interpreter scope.

	self assert: (scope getVar: #foo) = 42.
	self assert: (scope getVar: #robot) isNotNil.
	robot := scope getVar: #robot.
	self assert: (scope getVar: #r) = robot.
	
]
