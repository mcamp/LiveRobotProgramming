Extension { #name : #LRPAction }

{ #category : #'*LiveRobotics-Interpreter' }
LRPAction >> equalNode: anAction [
	^self textBlock asString = anAction textBlock asString
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPAction >> interpretedBlock [
	^ interpretedBlock
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPAction >> interpretedBlock: anObject [
	interpretedBlock := anObject
]
