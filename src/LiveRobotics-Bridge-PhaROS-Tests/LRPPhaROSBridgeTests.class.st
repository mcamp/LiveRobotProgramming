Class {
	#name : #LRPPhaROSBridgeTests,
	#superclass : #TestCase,
	#instVars : [
		'bridge',
		'parser',
		'interpreter'
	],
	#category : #'LiveRobotics-Bridge-PhaROS-Tests'
}

{ #category : #accessing }
LRPPhaROSBridgeTests class >> resources [
	^{LRPPhaROSBridgeTestsResources}
]

{ #category : #running }
LRPPhaROSBridgeTests >> setUp [

	"self resources first current."
	bridge := LRPPhaROSBridge new.
	bridge pharosInstance: LrpTestPackage new.
	interpreter := LRPInterpreter new.
	interpreter bridgeInstance: bridge.
	parser := LRPParser new.
]

{ #category : #running }
LRPPhaROSBridgeTests >> tearDown [

	bridge cleanUp.
]

{ #category : #publishing }
LRPPhaROSBridgeTests >> testAddPublisher [
	
	bridge addPublisher: 'lrpTestPublish' topicID: '/test/lrp' type: 'std_msgs/String'.
	bridge addSubscription: 'lrpTestSubscribe' topicID: '/test/lrp' type: 'std_msgs/String'.

	1 second wait.
	self assert: (bridge vars lrpTestSubscribe = nil).
	bridge vars lrpTestPublish: [:string |string data: 'this is a test' ].
	self assert: (bridge vars lrpTestSubscribe data = 'this is a test').
]

{ #category : #subscribing }
LRPPhaROSBridgeTests >> testAddSubscription [

	
	bridge addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	
	self assert: (bridge vars class instanceVariables includes: #lrpTest)
]

{ #category : #saving }
LRPPhaROSBridgeTests >> testFileForPublishers [
	|fileName|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedPublishers'.
	bridge addPublisher: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridge addPublisher: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	
	bridge saveTopicsAs: fileName asFileReference.
	
	[self assert: fileName asFileReference exists] 
		ensure: [ 
			fileName asFileReference delete.
		]

]

{ #category : #saving }
LRPPhaROSBridgeTests >> testFileForSubscriptions [
	|fileName|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedSubscriptions'.
	bridge addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridge addSubscription: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	
	bridge saveTopicsAs: fileName asFileReference.
	
	[self assert: fileName asFileReference exists] 
		ensure: [ 
			fileName asFileReference delete.
		]

]

{ #category : #publishing }
LRPPhaROSBridgeTests >> testInterpreterAddPublisher [
	|program |
	
	bridge addSubscription: 'lrpTestSub' topicID: '/test/lrp' type: 'std_msgs/String'.
	bridge addPublisher: 'lrpTestPub' topicID: '/test/lrp' type: 'std_msgs/String'.
	program := '
		(var bar := [''no subscription''])
		(machine blah
			(state one
				(onentry [robot lrpTestPub: [:string| string data: ''this is a test'']])
			)
			(state two
				(onentry [bar := robot lrpTestSub data.])
			)
			(eps one -> two t1)
		)
		(spawn blah one)
	'.
	
	
	interpreter interpret: (parser parse: program).
	
	1 second wait.
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'no subscription'.
	
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'this is a test'.
]

{ #category : #subscribing }
LRPPhaROSBridgeTests >> testInterpreterAddSubscription [
	|program publisher|
	
	bridge addSubscription: 'lrpTest' topicID: '/lrptest' type: 'std_msgs/String'.

	program := '
		(var bar := [''no subscription''])
		(machine blah
			(state one
				(onentry  [bar := robot lrpTest data.])
			)
			
		)
		(spawn blah one)
	'.
	
	
	interpreter interpret: (parser parse: program).

	
	publisher := bridge pharosInstance controller node
						topicPublisher: '/lrptest'
						typedAs: 'std_msgs/String'.
	"pharos bug?"
	2 seconds wait.
	publisher send:[:string | string data: 'this is a test'].
	
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'no subscription'.
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'this is a test'.
]

{ #category : #subscribing }
LRPPhaROSBridgeTests >> testInterpreterAddThenRemoveSubscription [
	|program publisher|
	
	bridge addSubscription: 'lrpTest' topicID: '/lrptest' type: 'std_msgs/String'.

	program := '
		(var bar := [''no subscription''])
		(machine blah
			(state one
				(onentry  [bar := robot lrpTest data.])
				(running [bar := robot class instanceVariables anySatisfy:[:ivar| ivar = #lrpTest]])
			)
			
		)
		(spawn blah one)
	'.
	
	
	interpreter interpret: (parser parse: program).

	
	publisher := bridge pharosInstance controller node
						topicPublisher: '/lrptest'
						typedAs: 'std_msgs/String'.
	"pharos bug?"
	2 seconds wait.
	publisher send:[:string | string data: 'this is a test'].
	
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'no subscription'.
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = 'this is a test'.
	
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = true.
	bridge removeSubscription: (bridge subscriptionInstances at: #lrpTest).
	interpreter stepRun.
	self assert: (interpreter mainMachine scope getVar: 'bar') value = false.
]

{ #category : #saving }
LRPPhaROSBridgeTests >> testLoadPublishers [
	|fileName bridgeSaver|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedPublishers'.
	
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver addPublisher: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridgeSaver addPublisher: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	bridgeSaver saveTopics: fileName asFileReference.
	
	[
	
	self deny: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest:]).
	self deny: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest2:]).
	
	bridge loadTopicsFrom: fileName asFileReference.
	
	self assert: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest:]).
	self assert: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest2:]).
	] ensure: [ 
		fileName asFileReference delete.
	]

]

{ #category : #saving }
LRPPhaROSBridgeTests >> testLoadSubscriptions [
	|fileName bridgeSaver|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedSubscriptions'.
	
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridgeSaver addSubscription: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	bridgeSaver saveTopics: fileName asFileReference.
	
	[
	
	self deny: (bridge vars class instanceVariables includes: #lrpTest).
	self deny: (bridge vars class instanceVariables includes: #lrpTest2).
	
	bridge loadTopicsFrom: fileName asFileReference.
	
	self assert: (bridge vars class instanceVariables includes: #lrpTest).
	self assert: (bridge vars class instanceVariables includes: #lrpTest2).
	] ensure: [ 
		fileName asFileReference delete.
	]

]

{ #category : #phaROS }
LRPPhaROSBridgeTests >> testObtainDataFromSubscription [
	|publisher|
	
	bridge addSubscription: 'lrpTest' topicID: '/lrptest' type: 'std_msgs/String'.
	
	"sanity check"
	self assert: (bridge vars lrpTest = nil).
	
	publisher := bridge pharosInstance controller node
						topicPublisher: '/lrptest'
						typedAs: 'std_msgs/String'.
	"pharos bug?"
	2 seconds wait.
	publisher send:[:string | string data: 'this is a test'].
	
	self assert: (bridge vars lrpTest data = 'this is a test').
]

{ #category : #publishing }
LRPPhaROSBridgeTests >> testRemovePublisher [
	
	bridge addPublisher: 'lrpTestPublish' topicID: '/test/lrp' type: 'std_msgs/String'.
	bridge addSubscription: 'lrpTestSubscribe' topicID: '/test/lrp' type: 'std_msgs/String'.

	1 second wait.
	bridge vars lrpTestPublish: [:string |string data: 'this is a test' ].
	
	self assert: (bridge vars lrpTestSubscribe data = 'this is a test').
	
	bridge removePublisher: (bridge publishers at: 'lrpTestPublish').
	self deny: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTestPublish]).
]

{ #category : #subscribing }
LRPPhaROSBridgeTests >> testRemoveSubscription [
	|subscription|
	

	bridge addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	
	subscription := bridge subscriptionInstances at: #lrpTest.
	
	bridge removeSubscription: subscription.
	self deny: (bridge vars class instanceVariables includes: #lrpTest).
	
]

{ #category : #saving }
LRPPhaROSBridgeTests >> testSaveAndLoadSubPub [
	|fileName pub sub|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedTopics'.
	sub := bridge addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	pub := bridge addPublisher: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	
	bridge saveTopicsAs: fileName asFileReference.
	
	bridge removePublisher: pub.
	bridge removeSubscription: sub.
	
	[
	self deny: (bridge vars class instanceVariables includes: #lrpTest).
	self deny: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest2:]).
	
	bridge loadTopicsFrom: fileName asFileReference.
	
	self assert: (bridge vars class instanceVariables includes: #lrpTest).
	self assert: (bridge vars class methods anySatisfy:[:aCompiledMethod| aCompiledMethod selector = #lrpTest2:]).
	
	] ensure: [ 
		fileName asFileReference delete.
	]

]

{ #category : #saving }
LRPPhaROSBridgeTests >> testSavePublishers [
	|fileName bridgeSaver|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedPublishers'.
	bridge addPublisher: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridge addPublisher: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	
	bridge saveTopicsAs: fileName asFileReference.
	
	[
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver loadTopics: fileName asFileReference.
	
	self assert: bridgeSaver publishers size = 2.
	self assert: bridgeSaver publishers first varName = 'lrpTest'.
	self assert: bridgeSaver publishers first topicID = '/lrpTest'.
	self assert: bridgeSaver publishers first type = 'std_msgs/String'.
	
	self assert: bridgeSaver publishers second varName = 'lrpTest2'.
	self assert: bridgeSaver publishers second topicID = '/lrpTest2'.
	self assert: bridgeSaver publishers second type = 'std_msgs/String'.
	] ensure: [ 
		fileName asFileReference delete.
	]

]

{ #category : #saving }
LRPPhaROSBridgeTests >> testSaveSubscriptions [
	|fileName bridgeSaver|
	
	fileName := FileSystem disk workingDirectory fullNameWithIndicator, 'testSavedSubscriptions'.
	bridge addSubscription: 'lrpTest' topicID: '/lrpTest' type: 'std_msgs/String'.
	bridge addSubscription: 'lrpTest2' topicID: '/lrpTest2' type: 'std_msgs/String'.
	
	bridge saveTopicsAs: fileName asFileReference.
	
	[
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver loadTopics: fileName asFileReference.
	
	self assert: bridgeSaver subscriptions size = 2.
	self assert: bridgeSaver subscriptions first varName = 'lrpTest'.
	self assert: bridgeSaver subscriptions first topicID = '/lrpTest'.
	self assert: bridgeSaver subscriptions first type = 'std_msgs/String'.
	
	self assert: bridgeSaver subscriptions second varName = 'lrpTest2'.
	self assert: bridgeSaver subscriptions second topicID = '/lrpTest2'.
	self assert: bridgeSaver subscriptions second type = 'std_msgs/String'.
	] ensure: [ 
		fileName asFileReference delete.
	]

]
