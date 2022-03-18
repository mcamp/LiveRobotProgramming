Extension { #name : #LRPVariable }

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> doInitialize [
	init := 1.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> doNotInitialize [
	init := 0.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> interpretWith: anInterpreter scope: aScope [

	self deprecated: 'Variable interpretation should not be done via double dispatch'.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> shouldInitialize [
	^ init = 1.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> shouldNotInitialize [
	^ init = 0.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> wasInitialized [
	^init = 2
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPVariable >> willInitialize [
	^init := 2
]
