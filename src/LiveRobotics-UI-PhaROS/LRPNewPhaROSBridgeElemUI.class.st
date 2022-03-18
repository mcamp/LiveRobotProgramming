Class {
	#name : #LRPNewPhaROSBridgeElemUI,
	#superclass : #ComposableModel,
	#instVars : [
		'lrpPhaROSUI',
		'textName',
		'textTopic',
		'textType',
		'buttonCreate',
		'secondsLimitForNetwork',
		'topics',
		'types'
	],
	#category : #'LiveRobotics-UI-PhaROS'
}

{ #category : #specs }
LRPNewPhaROSBridgeElemUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn newRow: [:textRow | textRow add: #textName ] height: self toolbarHeight.
			mainColumn newRow: [:textRow | textRow add: #textTopic ] height: self toolbarHeight.
			mainColumn newRow: [:textRow | textRow add: #textType ] height: self toolbarHeight.
			mainColumn newRow: [ :buttonRow| buttonRow add: #buttonCreate.	] height: self toolbarHeight.
		];
		yourself.
]

{ #category : #specs }
LRPNewPhaROSBridgeElemUI class >> title [
	^ self subclassResponsibility 
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> buttonCreate [
	^ buttonCreate
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> buttonCreate: anObject [
	buttonCreate := anObject
]

{ #category : #creating }
LRPNewPhaROSBridgeElemUI >> createBridgeElem [
	self subclassResponsibility 
]

{ #category : #'error prompt' }
LRPNewPhaROSBridgeElemUI >> emptyFieldPrompt [
	^	'You need to provide the var name, the topic id and the type of the topic'
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> extent [
	^300@(self class toolbarHeight * 5.5)
]

{ #category : #initialization }
LRPNewPhaROSBridgeElemUI >> initialize [
	super initialize.
	secondsLimitForNetwork := Duration seconds: 3.
	AioEventHandler initializeAioPluginPresent "for remove warning window when using OSProcess "
]

{ #category : #initialization }
LRPNewPhaROSBridgeElemUI >> initializePresenter [

	buttonCreate action: [ |subName subTopic subType|
		subName := textName getText.
		subTopic := textTopic getText.
		subType := textType getText.
		
		(subName isEmpty or:[subTopic isEmpty or:[subType isEmpty]]) ifTrue:[
			UIManager default abort: self emptyFieldPrompt.
		] ifFalse:[
			self createBridgeElem.
			self lrpPhaROSUI updateList.
			self window close.
		]
	].

	textTopic whenTextChanged: [ :newText|
		|type|
		"if topics is an empty array, we suppose there was a timeout and there are network problems"
		type := topics 
					ifEmpty: ['']
					ifNotEmpty: [
						[PhaROSSystemInfo instance typeOfTopic: newText] valueWithin: secondsLimitForNetwork onTimeout: ['']].
		type ifEmpty: [textType text: ''] ifNotEmpty: [  textType text: (type copyFrom: 1 to: (type size -1))].
	 ]
]

{ #category : #initialization }
LRPNewPhaROSBridgeElemUI >> initializeWidgets [

	textName := self newTextInput.
	textTopic := self newTextInput.
	textType := self newTextInput.
	buttonCreate := self newButton.
	
	textName autoAccept: true.
	textName removeEntryCompletion.
	textName ghostText: 'LRP Variable Name'.
	textTopic autoAccept: true.
	textTopic removeEntryCompletion.
	textTopic ghostText: 'ROS Topic ID'.
	textType autoAccept: true.
	textType removeEntryCompletion.
	textType ghostText: 'ROS Type'.
	buttonCreate label: 'Create'.
	
	self topicCompletion.
	self typeCompletion.
	
	self focusOrder
		add: textName;
		add: textTopic;
		add: textType;
		add: buttonCreate.
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> lrpPhaROSUI [
	^ lrpPhaROSUI
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> lrpPhaROSUI: anObject [
	lrpPhaROSUI := anObject
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textName [
	^ textName
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textName: anObject [
	textName := anObject
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textTopic [
	^ textTopic
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textTopic: anObject [
	textTopic := anObject
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textType [
	^ textType
]

{ #category : #accessing }
LRPNewPhaROSBridgeElemUI >> textType: anObject [
	textType := anObject
]

{ #category : #completion }
LRPNewPhaROSBridgeElemUI >> topicCompletion [
	
	|entry|
	entry := EntryCompletion new 
		dataSourceBlock: [:currText| 
			topics ifNil: [ topics := [PhaROSSystemInfo instance topicList.] 
									valueWithin: secondsLimitForNetwork onTimeout: [Array new]]];
		filterBlock:  [:currApplicant :currText| currApplicant asUppercase includesSubstring: currText asString asUppercase].
	self textTopic entryCompletion: entry.
		
]

{ #category : #completion }
LRPNewPhaROSBridgeElemUI >> typeCompletion [
	|entry|
	entry := EntryCompletion new 
		dataSourceBlock: [:currText| 
			types ifNil: [ types := [PhaROSSystemInfo instance messageList.] 
									valueWithin: secondsLimitForNetwork onTimeout: [Array new]]];
		filterBlock:  [:currApplicant :currText| currApplicant asUppercase includesSubstring: currText asString asUppercase].
	self textType entryCompletion: entry.
]
