"
I am the parser for LRP. Note that I am ment to be a singleton that is compiled, see my class side for the right way to get to my instance (and to reset it).
"
Class {
	#name : #LRPParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'program',
		'import',
		'string',
		'export',
		'variable',
		'block',
		'bra',
		'ket',
		'identifier',
		'machine',
		'body',
		'event',
		'transition',
		'epsilon',
		'wildcard',
		'state',
		'exit',
		'onentry',
		'running',
		'onexit',
		'comment',
		'lineTerminator',
		'statebody',
		'spawn',
		'integer',
		'errorNode',
		'timeoutIdentifier',
		'timeoutInteger',
		'endOfComment'
	],
	#classInstVars : [
		'comp'
	],
	#category : #'LiveRobotics-Parser'
}

{ #category : #compiler }
LRPParser class >> clearCompiledParser [
	<script>
	comp := nil.
]

{ #category : #compiler }
LRPParser class >> compiledParser [
	comp ifNil: [ | options |
		options := PPCCompilationOptions new.
		options parserName: #LRPCompiledParser.
		options allowProperties: true.
		comp := self new compileWithOptions: options].
	^comp
]

{ #category : #'grammar-common' }
LRPParser >> block [
	^ PPSmalltalkParser new productionAt: #block

]

{ #category : #grammar }
LRPParser >> body [
	^(variable / event / state / transition / timeoutIdentifier / timeoutInteger / epsilon / wildcard / comment / exit / errorNode ) star
		==> [:tokens | self processBody: tokens ]
]

{ #category : #'grammar-common' }
LRPParser >> bra [
	^ $( asParser token trim
]

{ #category : #'grammar-comments' }
LRPParser >> comment [
	^ ( $; asParser token , (endOfComment negate star) flatten,  endOfComment token) trim 
	==> [ :tokens |  |text|
			text := tokens  at: 2.
				(LRPComment text: (text copyFrom: 1 to: text size))
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				yourself.
		]

]

{ #category : #'grammar-comments' }
LRPParser >> endOfComment [
	^ #eof asParser / lineTerminator
]

{ #category : #'grammar-transitions' }
LRPParser >> epsilon [
	^ (bra, 'eps' asParser trim, identifier, '->' asParser trim, identifier,  identifier optional, ket) 
		==> [ :tokens |  | trans name |
				name := (tokens at: 6).
				name ifNil: [name := '' ] ifNotNil: [ name := name inputValue ].
				trans := 
					(LRPEpsilonTransition
						from: (tokens at: 3) inputValue
						to: (tokens at: 5) inputValue
						name: name).
				trans setRangesFor: tokens. 
				trans
		]
]

{ #category : #accessing }
LRPParser >> error [
	^error
]

{ #category : #grammar }
LRPParser >> errorNode [
	^(bra,  (bra/ket) negate star , ket ) 
		==> [ :tokens |
				self propertyAt: #LRPPF put: true.
				LRPErrorNode new
					start: tokens first start stop: tokens last stop source: tokens first collection; 
					failPosition: tokens first stop;
					yourself.
			]
]

{ #category : #grammar }
LRPParser >> event [
	^ (bra, 'event' asParser trim, identifier, block,  ket)  
		==> [:tokens | | ident |
				ident := (tokens at: 3).
				(LRPEvent named: ident inputValue trigger: (tokens  at: 4))
					start: tokens first start stop: tokens last stop source: ident collection;
					nameRange: (ident start to: ident stop);
					yourself.
			]
]

{ #category : #grammar }
LRPParser >> exit [
	^(bra, 'exit' asParser trim, identifier , identifier, '->' asParser trim, identifier, ket)
		==> [:tokens| self expandExit: tokens]
]

{ #category : #'sugar-processing' }
LRPParser >> expandExit: tokens [
	"(exit evt source -> dest) 
	    -->
		(on evt source -> $EndN)
		(state $EndN (onentry [$VarN := true]) (onexit [$VarN := false]))
		PU: (var $VarN := [false])
		PU: (event $EventN [$VarN])
		PU: (on $EventN *-> dest)"
		
	| retval count stparser orig tr st puc|
	retval := OrderedCollection new: 6.
	count := self nextSugarCount.
	stparser := self stParser.
	
	orig := LRPSugarNode new.
	orig start: tokens first start stop: tokens last stop source: tokens first collection;
		nameRange: ((tokens at: 3) start to: (tokens at: 3) stop).
		
	tr := 	(LRPTransition on: (tokens at: 3) inputValue
			from: (tokens at: 4) inputValue
			to:  '$End_',count
			name: '').
	tr synthetic: true. 

	st := LRPState name: '$End_',count
			body: (OrderedCollection
				with: (LRPOnEntry block: (stparser parseExpression: '[LRPS_',count,':= true]'))
				with: (LRPOnExit block: (stparser parseExpression: '[LRPS_',count,':= false]'))).
	st synthetic: true.
	retval add: orig; add: tr ; add: st.

	retval add: (LRPNodePullUpContainer on:
		(LRPVariable name: 'LRPS_',count value: (stparser parseExpression:'[false]'))).
	retval add: (LRPNodePullUpContainer on: 
		(LRPEvent named: '$Evt_',count trigger: (stparser parseExpression:'[LRPS_',count,']'))).

	tr := LRPTransition on: '$Evt_',count
				from: ''
				to: (tokens at: 6) inputValue
				name: (tokens at: 4) inputValue, ' exit tx'.
	tr start: (tokens at: 1) start.
	puc := LRPNodePullUpContainer on: tr.
	puc processor: [:trans :aState |
		trans from: aState name.
		trans synthetic: false.
		trans]. 
	
	retval add: puc.
	^retval
]

{ #category : #grammar }
LRPParser >> export [
	^(bra, 'export' asParser trim , identifier , ket)
	==> [:tokens |  | ident |
			ident := (tokens at: 3).
			(LRPExport withName: ident inputValue)
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				nameRange: (ident start to: ident stop);
				yourself.]
]

{ #category : #'grammar-common' }
LRPParser >> identifier [ 
	^(#letter asParser , (#word asParser /  $_ asParser) star) flatten token trim
]

{ #category : #grammar }
LRPParser >> import [
	^(bra, 'import' asParser trim , string , ket)
	==> [:tokens | 
			(LRPImport filename: (tokens at: 3) inputValue)
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				nameRange: ((tokens at: 3) start to: (tokens at: 3) stop);
				yourself.]
]

{ #category : #grammar }
LRPParser >> integer [ 
	^(#digit asParser) plus flatten trim token

]

{ #category : #'grammar-common' }
LRPParser >> ket [
	^ $) asParser token trim
]

{ #category : #'grammar-comments' }
LRPParser >> lineTerminator [

	^ (Character lf asParser) / (Character cr asParser , (Character lf asParser ) optional )
]

{ #category : #grammar }
LRPParser >> machine [
	^(bra , 'machine' asParser trim , identifier , body , ket) 
		==> [:tokens | | ident bod stop |
				ident := (tokens at: 3).
				bod := (tokens at: 4).
				bod isEmpty
					ifTrue: [ stop := tokens last stop - 1 ]
				 	ifFalse: [ stop := (bod at: 1) start - 1 ].
				(LRPMachine name: ident inputValue body: bod)
					start: (tokens first start) stop: (tokens last stop) source: ident collection;
					nameRange: (ident start to: stop);
					yourself.
			]
]

{ #category : #accessing }
LRPParser >> nextSugarCount [
	| sugar |
	sugar := self propertyAt: #SugarCounter ifAbsentPut: 0.
	self propertyAt: #SugarCounter put: sugar+1.
	^sugar asString
]

{ #category : #grammar }
LRPParser >> onentry [
	^ (bra, 'onentry' asParser trim, (block/spawn) ,  ket ) 
		==> [:tokens | 
				(LRPOnEntry block: (tokens at: 3))
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				keywordEnd: (tokens at: 3) start -1;
				yourself.
			]
]

{ #category : #grammar }
LRPParser >> onexit [
	^ (bra, 'onexit' asParser trim, (block/spawn),  ket)  
		==> [:tokens | 
				(LRPOnExit block: (tokens at: 3))
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				keywordEnd: (tokens at: 3) start -1;
				yourself.
			]
]

{ #category : #'sugar-processing' }
LRPParser >> processBody: aBodyCollection [
	"Syntactic sugar postprocessing of body statements. Includes duplicate var checking"
	| vars newBody |
	vars := OrderedCollection new.
	newBody := OrderedCollection new: aBodyCollection size.
	aBodyCollection do:[:token | token deSugarIn: newBody with: vars].
	^newBody.
]

{ #category : #grammar }
LRPParser >> program [
	^ (import / export / variable / machine / comment / spawn / errorNode) star
		==> [:tokens | self processBody: tokens]
]

{ #category : #grammar }
LRPParser >> running [
	^ (bra, 'running' asParser trim, (block/spawn),  ket)  
		==> [:tokens | 
				(LRPRunning block: (tokens at: 3))
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				keywordEnd: (tokens at: 3) start -1;
				yourself.
			]
]

{ #category : #grammar }
LRPParser >> spawn [
	^(bra , 'spawn' asParser trim , identifier , identifier , ket) 
		==> [ :tokens |  
				(LRPSpawn
					machine: (tokens at: 3) inputValue
					state: (tokens at: 4) inputValue)
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				nameRange: ((tokens at: 3) start to: (tokens at: 4) stop)
				yourself.
			]
		
]

{ #category : #accessing }
LRPParser >> stParser [
	^self propertyAt: #STParser ifAbsentPut: PPSmalltalkParser new.

]

{ #category : #accessing }
LRPParser >> start [
	^program end
]

{ #category : #grammar }
LRPParser >> state [
	^(bra , 'state' asParser trim , identifier , statebody , ket) 
		==> [ :tokens | | ident |
				ident := (tokens at: 3).
				(LRPState name: ident inputValue
					body: (tokens at: 4))
				start: (tokens first start) stop: (tokens last stop) source: tokens first collection;
				nameRange: (ident start to: ident stop);
				yourself.
			]
		
]

{ #category : #grammar }
LRPParser >> statebody [
	^(onentry / running / onexit / machine / comment / errorNode) star
		
]

{ #category : #'grammar-common' }
LRPParser >> string [
	^ PPSmalltalkParser new productionAt: #stringToken

]

{ #category : #'grammar-transitions' }
LRPParser >> timeoutIdentifier [
    ^ (bra, 'ontime' asParser trim, identifier , identifier, '->' asParser trim, identifier,  identifier optional, ket)
        ==> [:tokens | self transitionActionHandlerFor: LRPTimeoutTransition tokens: tokens ].
]

{ #category : #'grammar-transitions' }
LRPParser >> timeoutInteger [
	^ (bra, 'ontime' asParser trim,  integer, identifier, '->' asParser trim, identifier,  identifier optional, ket)
		==> [ :tokens | | trans name |
		name := (tokens at: 7).
		name ifNil: [name := '' ] ifNotNil: [ name := name inputValue ].
		trans :=
			(LRPTimeoutTransition
				on: (Integer readFrom: (tokens at: 3) inputValue)
				from: (tokens at: 4) inputValue
				to: (tokens at: 6) inputValue
				name: name).
		trans setRangesFor: tokens.
		trans.
	]
]

{ #category : #'grammar-transitions' }
LRPParser >> transition [
    ^ (bra, 'on' asParser, #space asParser plus,  ( identifier | block ) , identifier, '->' asParser trim, identifier,  identifier optional , ket) 
        ==> [ :tokens | |newtokens|
				"To remove #space asParser plus token and be uniform with other tx"
				newtokens := {
					tokens at: 1 . tokens at: 2 . tokens at: 4 . tokens at: 5 .
					tokens at: 6 . tokens at: 7 . tokens at: 8 . tokens at: 9
				  }.
				self transitionActionHandlerFor: LRPTransition tokens: newtokens ]
]

{ #category : #transitions }
LRPParser >> transitionActionHandlerFor: class tokens: tokens [
	| trans name trigger from |
	name := (tokens  at: 7).
	name isNil ifTrue:[ name := '' ] ifFalse:[ name := name inputValue ].
	trigger := (tokens at: 3).
	from := (tokens at: 4).
	from isString ifFalse: [from := from inputValue ].
	
	trigger class = RBBlockNode
		ifTrue: [|evt count|
			count := self nextSugarCount.
			evt := LRPEvent named: '$Evt_',count trigger: trigger.
			trans := (class
						on: '$Evt_',count
						from: from 
						to: (tokens at: 6) inputValue
						name: name).
			trans setRangesFor: tokens.
			^ Array with: trans with: evt]
		ifFalse: [
			trans := (class
						on: trigger inputValue
						from: from 
						to: (tokens at: 6) inputValue
						name: name).
			trans setRangesFor: tokens.
			^ trans.]
]

{ #category : #grammar }
LRPParser >> variable [
	^ (bra , 'var' asParser trim , identifier , ':=' asParser trim , block , ket) 
		==> [ :tokens | |ident|
			ident := (tokens at: 3).
			(LRPVariable name: ident inputValue value: (tokens at: 5))
				start: (tokens first start) stop: (tokens last stop) source: ident collection;
				nameRange: (ident start to: ident stop);
				yourself.
		]
]

{ #category : #'grammar-transitions' }
LRPParser >> wildcard [
	^ (bra, 'on' asParser trim, ( identifier | block ) ,  '*->' asParser trim, identifier,  identifier optional, ket) 
		==> [ :tokens |
			|newtokens|
			newtokens := {
				tokens at: 1 . tokens at: 2 . tokens at: 3 . '*' .
				tokens at: 4 . tokens at: 5 . tokens at: 6 . tokens at: 7
			  }.
			self transitionActionHandlerFor: LRPWildcardTransition tokens: newtokens. 
			]
		
]
