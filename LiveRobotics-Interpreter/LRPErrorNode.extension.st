Extension { #name : #LRPErrorNode }

{ #category : #'*LiveRobotics-Interpreter' }
LRPErrorNode >> interpretWith: anInterpreter scope: aScope [
  "do nothing, is an error"
	self error: 'Should not interpret on error parsing'
]
