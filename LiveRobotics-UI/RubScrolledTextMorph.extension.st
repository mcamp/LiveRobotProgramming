Extension { #name : #RubScrolledTextMorph }

{ #category : #'*LiveRobotics-UI' }
RubScrolledTextMorph >> stylerStyled: styledCopyOfText [ 
	self text runs: styledCopyOfText runs.

]

{ #category : #'*LiveRobotics-UI' }
RubScrolledTextMorph >> whenTextChanged: aBlock [

	self announcer subscribe: RubTextAccepted send: #value to:  aBlock
]
