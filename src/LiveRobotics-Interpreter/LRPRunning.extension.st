Extension { #name : #LRPRunning }

{ #category : #'*LiveRobotics-Interpreter' }
LRPRunning >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretAction: self withScope: aScope type: #running.
]
