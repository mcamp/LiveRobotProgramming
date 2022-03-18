Extension { #name : #SequenceableCollection }

{ #category : #'*LiveRobotics-Parser' }
SequenceableCollection >> deSugarIn: aBody with: vars [
	"flatten a collection of body elements "
	self do:[:each | each deSugarIn: aBody with: vars] 
]

{ #category : #'*LiveRobotics-Parser' }
SequenceableCollection >> findBestLRPNodeFor: anInteger [
	|bestParentNode|
	
	bestParentNode := self detect: [ :lrpNode| lrpNode stringPositionContains: anInteger ] ifNone:[^nil].
	^bestParentNode findBestLRPNodeFor: anInteger.
]
