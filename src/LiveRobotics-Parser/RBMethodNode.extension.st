Extension { #name : #RBMethodNode }

{ #category : #'*LiveRobotics-Parser' }
RBMethodNode >> rewriteLRPVarNamedRead: aVarName [
	| rewriter |

	rewriter := RBParseTreeRewriter new.
	rewriter 
		replace:  aVarName
		with: '(LRPScopeVariables at: #', aVarName, ') value'.

	(rewriter executeTree: self) 
		ifTrue: [^rewriter tree]
		ifFalse: [^self].
]

{ #category : #'*LiveRobotics-Parser' }
RBMethodNode >> rewriteLRPVarNamedWrite: aVarName [ 
	| rewriter|

	rewriter := RBParseTreeRewriter new.
	rewriter 
		replace:  aVarName, ' := ``@object'
		with: '(LRPScopeVariables at: #', aVarName,  ') value: ``@object'.	
		
	(rewriter executeTree: self) 
		ifTrue: [^rewriter tree]
		ifFalse: [^self].
]
