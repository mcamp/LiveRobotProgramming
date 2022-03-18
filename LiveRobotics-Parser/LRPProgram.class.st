"
I represent a  LRP program,  also considering imported programs.

    Instance Variables:
	ast : the AST of the main program,
	imports :  an ordered collection of LRPPrograms, in order of inclusion through import directives

"
Class {
	#name : #LRPProgram,
	#superclass : #Object,
	#instVars : [
		'ast',
		'imports'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #'instance creation' }
LRPProgram class >> fromAST: anAST [
	| retval |
	"Make a new program and load the imports."
	retval := self new.
	retval ast: anAST.
	retval loadImports.
	^retval.
	
]

{ #category : #'instance creation' }
LRPProgram class >> fromSource: aString [
	| retval |
	"Make a new program and load the imports."
	retval := self new.
	retval ast: (LRPParser compiledParser parse: aString).
	retval loadImports.
	^retval.
	
]

{ #category : #'instance creation' }
LRPProgram class >> withAST: anAST [ 
	"for unit tests"
	^ self withAST: anAST andImports: #()
]

{ #category : #'instance creation' }
LRPProgram class >> withAST: anAST andImports: aCollectionOfPrograms [
	| retval |
	"for unit tests"
	retval := self new.
	retval
		ast: anAST;
		imports: aCollectionOfPrograms.
	^retval.
	
]

{ #category : #accessing }
LRPProgram >> ast [
	^ ast
]

{ #category : #accessing }
LRPProgram >> ast: anObject [
	ast := anObject
]

{ #category : #modules }
LRPProgram >> exportedMachines [
	| names |
	"return the machines that I declare to export"

	ast isPetitFailure ifTrue: [ ^#() ].

	names := ast select: [ :node | node class = LRPExport]
						thenCollect: [ :node | node name ].
	^ ast select: [:node | node class = LRPMachine	 and: [names includes: node name]]
]

{ #category : #'inspector extensions' }
LRPProgram >> gtInspectorSourceIn: composite [
	<gtInspectorPresentationOrder: 10> 
	| pres |
	pres := self ast isPetitFailure
		ifTrue: [ self ast gtInspectorRawIn: composite ]
		ifFalse: [ self ast gtInspectorItemsIn: composite ].
	pres title: 'Source Statements'.
	^pres

]

{ #category : #accessing }
LRPProgram >> imports [
	^ imports
]

{ #category : #accessing }
LRPProgram >> imports: anObject [
	imports := anObject
]

{ #category : #modules }
LRPProgram >> loadImports [
	| importSources |

	importSources := OrderedCollection new.
	
	ast isPetitFailure ifTrue:[
		imports := #().
		^self].
	
	(ast select: [ :node | node class = LRPImport ])
		do: [ :node | | file |
				file := node fullpath.
				file exists ifTrue: [ file readStreamDo: [ :rstr | importSources add: rstr contents ] ] ].

	imports := importSources collect: [:src | LRPProgram fromSource: src ].
]

{ #category : #modules }
LRPProgram >> resolvedImports [
	| retval |
	"Returns a collection of the machines that are added due to this program's imports.
	My imports go first, then the imported programs' imports are added."
	
	retval := OrderedCollection new.

	"the exports of the imported program"
	imports do: [ :import| retval addAll: import exportedMachines.].
	
	"all that was imported by the imported programs"
	imports do: [ :import |	retval addAll: import resolvedImports.].
		
	^ retval
]
