"
A LRPProgramEditor is the code editing pane of the LRP UI

The Instance Variables contain the widgets, except for
- lastmodel: the last succesfully parsed model
- parser: the LRP Parser
- interpreter: the LRP Interpreter.
- codeChangeBlock: called after each code change that successfully parses, and is given the parse result as an argument 

"
Class {
	#name : #LRPProgramEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'text',
		'botlabel',
		'freq',
		'freqlabel',
		'pause',
		'step',
		'reset',
		'inspBot',
		'parser',
		'styler',
		'lastmodel',
		'interpreter',
		'queue',
		'codeChangeBlock',
		'filepath',
		'filename'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #specs }
LRPProgramEditor class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [:col|
				col add: #menu height: (self toolbarHeight);
					add: #text ;
					newRow: [ :row |
						row
							add: #botlabel; 
							add: #freq; add: #freqlabel; 
							add: #pause; add: #step; add: #reset;
							add: #inspBot]
						height: (self toolbarHeight)]
]

{ #category : #'as yet unclassified' }
LRPProgramEditor class >> menuOn: aBuilder [
	"The context menu of the text editor.
	see RubPlainTextMode class as well"
	<contextMenu>
	<RubPlainTextMenu>

	| inst |
	"just to get to the instance of me. How ugly is that, huh?"
	inst := aBuilder model window model model codePane.
	
	(aBuilder item: #'Save')
		keyText: 's';
		selector: #saveFile;	
		target: inst; 
		icon: Smalltalk ui icons smallSaveIcon;
		order: 0.
	(aBuilder item: #'Load')
		keyText: 'l';
		selector: #loadFile;	
		target: inst; 
		icon: Smalltalk ui icons openIcon;
		order: 0.
	aBuilder items last withSeparatorAfter.
	
	(aBuilder item: #'Add Watchpoint')
		keyText: 'w';
		selector: #addWatchpoint;
		target: inst;
		icon: Smalltalk ui icons haloView;
		order:0.
	aBuilder items last withSeparatorAfter.
]

{ #category : #actions }
LRPProgramEditor >> addWatchpoint [
	|watchpoint|
	watchpoint := interpreter addWatchpointWithCursorPosition: self text widget selectionInterval first.
	
	self resetWatchpointStyle.
]

{ #category : #styling }
LRPProgramEditor >> addWatchpointStyle [
	self interpreter program do:[ :aNode | 
		aNode acceptVisitor: (LRPWatchpointIconStyler new view: self text widget) ]
]

{ #category : #accessing }
LRPProgramEditor >> botlabel [
	^ botlabel
]

{ #category : #accessing }
LRPProgramEditor >> botlabel: anObject [
	botlabel := anObject
]

{ #category : #'initialize-release' }
LRPProgramEditor >> cleanUp [
	queue cleanUp.
	interpreter stop.
]

{ #category : #api }
LRPProgramEditor >> codeChangeBlock [
	codeChangeBlock isNil ifTrue: [ codeChangeBlock :=[:model | ] ].
	^ codeChangeBlock
]

{ #category : #api }
LRPProgramEditor >> codeChangeBlock: anObject [
	codeChangeBlock := anObject
]

{ #category : #'initialize-release' }
LRPProgramEditor >> connectPresenters [
	self flag:#TODO.
	"self setupTopButtons.
	self setupBottomButtons."
	
	text whenSubmitDo: [:newProgram| self processTextUpdate: newProgram ].
]

{ #category : #layout }
LRPProgramEditor >> defaultLayout [
	self flag: #TODO.
	^ self newBoxLayoutTopToBottom 
		"add: menu height: (self toolbarHeight);"
		add: text;
		add: (self newBoxLayoutLeftToRight 
				add: botlabel;
				add: freq;
				add: freqlabel;
				add: pause;
				add: step;
				add: reset;
				add: inspBot 
				yourself) expand: false;
		yourself

]

{ #category : #accessing }
LRPProgramEditor >> filename [
	^ filename
]

{ #category : #accessing }
LRPProgramEditor >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
LRPProgramEditor >> filepath [
	filepath isNil ifTrue: [ filepath := LRPInterpreter lrpRootPath ].
	^ filepath
]

{ #category : #accessing }
LRPProgramEditor >> filepath: anObject [
	filepath := anObject
]

{ #category : #accessing }
LRPProgramEditor >> freq [
	^ freq
]

{ #category : #accessing }
LRPProgramEditor >> freq: anObject [
	freq := anObject
]

{ #category : #accessing }
LRPProgramEditor >> freqlabel [
	^ freqlabel
]

{ #category : #accessing }
LRPProgramEditor >> freqlabel: anObject [
	freqlabel := anObject
]

{ #category : #'initialize-release' }
LRPProgramEditor >> initialize [
	Cursor wait showWhile: [ 
		super initialize.
		parser := LRPParser compiledParser.]
]

{ #category : #'initialize-release' }
LRPProgramEditor >> initializePresenters [
	
	text := self lrpTextArea.
	
	botlabel := self newLabel.
	freq := self newSlider.
	freqlabel := self newLabel.
	pause := self newCheckBox.
	step := self newButton.
   reset := self newButton.
	inspBot := self newButton.
	
	botlabel label: '          Interpeter:'.
	freq min: 1.
	freq max: 50.
	freq quantum: 1.
	freq value: 10.
	freqlabel label: '10 Hz'.
	pause label: 'Pause'.
	step label: 'Step'.
	reset label: 'Reset'.
	inspBot label: 'Inspect robot'.
]

{ #category : #accessing }
LRPProgramEditor >> inspBot [
	^ inspBot
]

{ #category : #accessing }
LRPProgramEditor >> inspBot: anObject [
	inspBot := anObject
]

{ #category : #api }
LRPProgramEditor >> interpreter [
	interpreter isNil ifTrue: [ interpreter := LRPDummyInterpreter new].
	^ interpreter
]

{ #category : #api }
LRPProgramEditor >> interpreter: anObject [
	interpreter := anObject.
	queue := LRPProgramUpdateQueue forInterpreter: anObject parser: self parser andUI: self.
]

{ #category : #accessing }
LRPProgramEditor >> lastmodel [
	^ lastmodel
]

{ #category : #accessing }
LRPProgramEditor >> lastmodel: anObject [
	lastmodel := anObject
]

{ #category : #actions }
LRPProgramEditor >> loadFile [

	| file |
	
	file := Smalltalk ui theme
		chooseFileIn: World
		title: 'Select file to load'
		extensions: nil
		path: self filepath asFileReference
		preview: true.
	
	file ifNotNil: [ |stream|
		stream := file readStream.
		text widget updateTextWith: stream contents asText.
		text widget acceptContents.
		self filepath: file asFileReference parent path.
		self filename: file fullName.
		stream close.
		self processTextUpdate]
]

{ #category : #'initialize-release' }
LRPProgramEditor >> lrpTextArea [
	| morph |
	self flag:#TODO.
	^ self newText
	"morph := RubScrolledTextMorph new
				vResizing: #spaceFill; 
      			hResizing: #spaceFill;
				beWrapped;
				autoAccept: true;
				updateTextWith: self newStartText; 
				withLineNumbers;
				withTextSegmentIcons.

	(morph textArea)
		on: $s command do: [self saveFile. morph flash ];
		on: $s control do: [self saveFile. morph flash ];
		on: $l command do: [self loadFile ];
		on: $l control do: [self loadFile ].
	
	^ morph asSpecAdapter 
"
]

{ #category : #accessing }
LRPProgramEditor >> menu [
	^ menu
]

{ #category : #accessing }
LRPProgramEditor >> menu: anObject [
	menu := anObject
]

{ #category : #actions }
LRPProgramEditor >> newFile [
	self filename: nil.
	text widget updateTextWith: self newStartText.
	self processTextUpdate.
]

{ #category : #actions }
LRPProgramEditor >> newStartText [
	| stext|
	stext := Text fromString: ';;; New program created by ' ,
						Author fullName , ' on ',
						Date today asString, Character cr asString.
	stext addAttribute: (TextColor new color: Color veryDarkGray; yourself).
	^stext
]

{ #category : #actions }
LRPProgramEditor >> parseAndStyle: aText [
	|parsedProgram |
	self flag:#TODO.
	parsedProgram := self parser parse: aText.
	^parsedProgram isPetitFailure 
		ifTrue:[nil]
		ifFalse:[parsedProgram]
	
	"self parser propertyAt: #LRPPF put: false.
	parsedProgram := self parser parse: aText.

	parsedProgram isPetitFailure ifTrue:[
		self parser propertyAt: #LRPPF put: true.
		parsedProgram := {LRPErrorNode new
									start: 1;	
									stop: aText size;
									failPosition: parsedProgram position;
									yourself.	}].

	self styler view: text widget; style: aText nodes: parsedProgram.

	^(self parser propertyAt: #LRPPF)
						ifTrue:[nil]
						ifFalse:[parsedProgram]."
	

]

{ #category : #accessing }
LRPProgramEditor >> parser [
	^ parser
]

{ #category : #accessing }
LRPProgramEditor >> pause [
	^ pause
]

{ #category : #accessing }
LRPProgramEditor >> pause: anObject [
	pause := anObject
]

{ #category : #actions }
LRPProgramEditor >> processTextUpdate: aProgram [
	|res |
	self flag:#TODO. "remove space, tab or newline optimization"

	"Did the currently displayed text parse?"
	res := self parseAndStyle: aProgram.
	res ifNotNil: [ |code|
		"If a space, tab or newline was entered, no need to recompile. metaprogramming FTW!"
		"code := World activeHand instVarNamed: #lastKeyScanCode."
		code := 1.
		({ 48 . 49 . 36 } includes: code) ifFalse: [
				self lastmodel: res.
				queue newProgram: res. "will call updateWith: when processed"]]
]

{ #category : #styling }
LRPProgramEditor >> removeWatchpointStyle [ 

	self text widget segments copy 
		select: [:seg| seg class = LRPWatchpointTextSegmentMorph] thenDo: #delete.
]

{ #category : #accessing }
LRPProgramEditor >> reset [
	^ reset
]

{ #category : #accessing }
LRPProgramEditor >> reset: anObject [
	reset := anObject
]

{ #category : #styling }
LRPProgramEditor >> resetWatchpointStyle [
	self removeWatchpointStyle.
	self addWatchpointStyle
]

{ #category : #actions }
LRPProgramEditor >> saveFile [
	| stream file  |
	
	self filename isNil ifTrue: [ ^self saveFileAs ].
	
	file := self filename asFileReference.
	
	file exists ifTrue: [ | backref backfile |

		"make the backup copy"
		backref := file path copy.
		backref basename: backref basename,'~'.
		backfile := backref asFileReference.
		
		backfile exists ifTrue: [
			"delete it otherwise old contents beyond end of text widget text remain"
			backfile delete].
		
		backfile writeStreamDo: [ :wstr |
			wstr nextPutAll: (file readStreamDo: [:rstr| rstr contents])].
		
		"delete it otherwise old contents beyond end of text widget text remain"
		file delete.
		 ].
		
	stream := file writeStream.
	stream nextPutAll: text widget text asString.
	stream close.
	text widget flash.
	
]

{ #category : #actions }
LRPProgramEditor >> saveFileAs [
	| fileref |
	
	fileref := Smalltalk ui theme
		fileSaveIn: World
		title: 'Enter filename to save'
		extensions: nil
		path: self filepath asFileReference.
	
	fileref ifNotNil: [
		self filepath: fileref parent path.
		self filename: fileref path.
		self saveFile.].
	
]

{ #category : #'initialize-release' }
LRPProgramEditor >> setupBottomButtons [

	freq whenValueChangedDo: [
		freqlabel label: freq value asString, ' Hz'.
		self interpreter rate: freq value].
	pause whenActivatedDo: [self interpreter pauseInterpreter: true].
	pause whenDeactivatedDo: [self interpreter pauseInterpreter: false].
	step action: [pause state: true. self interpreter stepRun].
	reset action: [|res|
			res := self parseAndStyle: text widget text.
			res isNil ifFalse: [
				self interpreter restartFromUI: (LRPProgram fromAST: res).
				self lastmodel: res.
				self codeChangeBlock value: res]].
	
	inspBot action: [ self interpreter bridgeVars inspect ]
]

{ #category : #'initialize-release' }
LRPProgramEditor >> setupMenuFor: anActionBlock [
	self flag:#TODO.
	"menu := MenuModel new.
	menu applyTo: self.
	menu addGroup: [ :group |
			group addItem: [ :item |
				item
					name: nil; description: 'New File';
					icon: Smalltalk ui icons smallNewIcon;
					action: [ self newFile ] ].
			group addItem: [ :item |
				item
					name: nil; description: 'Open File';
					icon: Smalltalk ui icons openIcon;
					action: [ self loadFile ] ].
			group addItem: [ :item |
				item 
					name: nil; description: 'Save File';
					icon: Smalltalk ui icons smallSaveIcon;
					action: [ self saveFile ] ].
			group addItem: [ :item |
				item 
					name: nil; description: 'Save File As';
					icon: Smalltalk ui icons smallSaveAsIcon;
					action: [ self saveFileAs ] ].].
			
			
	menu addGroup: [ :group |
			group addItem: [ :item |
				item
					name: nil; description: 'Add Variable';
					icon: Smalltalk ui icons databaseAdd;
					action: [ anActionBlock value: '(var ?v := [?])']].
			group addItem: [ :item |
				item 
					name: nil; description: 'Add Machine';
					icon: Smalltalk ui icons objects;
					action: [ anActionBlock value: '(machine ?m)' ]].
			group addItem: [ :item |
				item 
					name: nil; description: 'Add State';
					icon: Smalltalk ui icons testYellow ;
					action: [ anActionBlock value: '(state ?s)' ]].
			group addItem: [ :item |
				item 
					name: nil; description: 'Add Transition';
					icon: Smalltalk ui icons forwardIcon;
					action: [ anActionBlock value: '(on ?e ?f -> ?t ?n)' ]].		
			group addItem: [ :item |
				item 
					name: nil; description: 'Add Event';
					icon: Smalltalk ui icons exceptionIcon;
					action: [ anActionBlock value: '(event ?e [?])' ]].						
				].
	menu addGroup: [ :group | ]."
]

{ #category : #'initialize-release' }
LRPProgramEditor >> setupTopButtons [
	| action |	
	action := [:string | |sel oldtext newtext|
		sel := text widget selectionInterval.
		oldtext := text widget text.
		newtext := Text fromString: (oldtext copyFrom: 1 to: sel first -1) asString
						, string , (oldtext copyFrom: sel last + 1 to: oldtext size) asString.
		text widget updateTextWith: newtext.
		self processTextUpdate.
		text widget setSelection: ((sel first + string size) to: (sel first + string size) -1 ).
		text widget takeKeyboardFocus.].

		self setupMenuFor: action
]

{ #category : #accessing }
LRPProgramEditor >> step [
	^ step
]

{ #category : #accessing }
LRPProgramEditor >> step: anObject [
	step := anObject
]

{ #category : #accessing }
LRPProgramEditor >> styler [
	^styler ifNil:[styler := LRPRubricStyler new]
]

{ #category : #accessing }
LRPProgramEditor >> text [
	^ text
]

{ #category : #accessing }
LRPProgramEditor >> text: anObject [
	text := anObject
]

{ #category : #api }
LRPProgramEditor >> updateWith: aProgram [
	"the interpreter processed a new program, the UI must be updated"
	self codeChangeBlock value: aProgram.
]
