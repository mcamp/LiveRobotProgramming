Extension { #name : #LRPOnEntry }

{ #category : #'*LiveRobotics-Interpreter' }
LRPOnEntry >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretAction: self withScope: aScope type: #onentry.
]
