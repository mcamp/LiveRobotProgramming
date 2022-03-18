Extension { #name : #LRPWildcardTransition }

{ #category : #'*LiveRobotics-Interpreter' }
LRPWildcardTransition >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretWildcardTransition: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPWildcardTransition >> isFromState: aState [

	^true.
]
