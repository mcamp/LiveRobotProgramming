Extension { #name : #LRPMachine }

{ #category : #'*LiveRobotics-UI' }
LRPMachine >> forName: aFullName [
	|recurse|
	"quite suboptimal but we assume the trees will be small"
	aFullName = self fullName ifTrue: [ ^self ].
	recurse := (self states flatCollect: [:state | state machines])
		collect: [ :machine| machine forName: aFullName].
	^recurse detect: [ :machine| machine notNil ] ifNone: [ nil ].

]

{ #category : #'*LiveRobotics-UI' }
LRPMachine >> stateOfParentMachine: aFullMachineName [
	"this assumes that this machine is a child of the machine whose name is given as an argument"
	| superState |
	
	superState := self container.
	
	superState container fullName = aFullMachineName
		ifTrue: [^superState]
		ifFalse: [^superState container stateOfParentMachine: aFullMachineName]
]
