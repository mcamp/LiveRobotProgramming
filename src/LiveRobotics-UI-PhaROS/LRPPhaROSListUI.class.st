Class {
	#name : #LRPPhaROSListUI,
	#superclass : #ComposableModel,
	#instVars : [
		'listSubscriptions',
		'listPublishers',
		'buttonNewSub',
		'buttonNewPub',
		'phaROSBridge',
		'menuButtons',
		'filepath',
		'filename'
	],
	#category : #'LiveRobotics-UI-PhaROS'
}

{ #category : #specs }
LRPPhaROSListUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [ :mainColumn|
			mainColumn add: #menuButtons height: (self toolbarHeight).
			mainColumn add:  #listPublishers.
			mainColumn add:  #listSubscriptions.
			mainColumn newRow: [ :buttonRow|	buttonRow add: #buttonNewPub. buttonRow add: #buttonNewSub] height: (self toolbarHeight).
		];
		yourself.
]

{ #category : #opening }
LRPPhaROSListUI class >> openOnBridge: aPhaROSBridge [
	|inst|
	inst := self new.
	inst phaROSBridge: aPhaROSBridge.
	inst openWithSpec.

	^inst
]

{ #category : #specs }
LRPPhaROSListUI class >> title [
	^ 'LRP PhaROS | Publisher / Subscribers'
]

{ #category : #accessing }
LRPPhaROSListUI >> buttonNewPub [
	^ buttonNewPub
]

{ #category : #accessing }
LRPPhaROSListUI >> buttonNewPub: anObject [
	buttonNewPub := anObject
]

{ #category : #accessing }
LRPPhaROSListUI >> buttonNewSub [
	^ buttonNewSub
]

{ #category : #accessing }
LRPPhaROSListUI >> buttonNewSub: anObject [
	buttonNewSub := anObject
]

{ #category : #accessing }
LRPPhaROSListUI >> extent [
	^500@350
]

{ #category : #accessing }
LRPPhaROSListUI >> filename [
	^filename
]

{ #category : #accessing }
LRPPhaROSListUI >> filename: aString [	
	filename := aString
]

{ #category : #accessing }
LRPPhaROSListUI >> filepath [
	filepath isNil ifTrue: [ filepath := LRPInterpreter lrpRootPath ].
	^ filepath
]

{ #category : #accessing }
LRPPhaROSListUI >> filepath: aFilepath [
	filepath := aFilepath
]

{ #category : #initialization }
LRPPhaROSListUI >> initializePresenter [
	
	self setupModelButtons.
	buttonNewSub action: [LRPNewSubscriptionUI new lrpPhaROSUI: self; openWithSpec].
	buttonNewPub action: [LRPNewPublisherUI new lrpPhaROSUI: self; openWithSpec].
		
	listSubscriptions whenListChanged:[:newList :oldList|
		newList size > 0 ifTrue:[
			self setupSubMenu
		]
	].
	
	listSubscriptions whenSelectionChanged: [ 
		self setupSubMenu.	
	].

	listPublishers whenListChanged:[:newList :oldList|
		newList size > 0 ifTrue:[
			self setupPubMenu
		]
	].

	listPublishers whenSelectionChanged: [ 
		self setupPubMenu.	
	].
]

{ #category : #initialization }
LRPPhaROSListUI >> initializeWidgets [
	
	buttonNewPub := self newButton.
	buttonNewSub := self newButton.
	listSubscriptions := self newList.
	listPublishers := self newList.
	
	buttonNewSub label: 'New Subscription'.
	buttonNewPub label: 'New Publisher'.
	listSubscriptions items: self lrpSubscriptions.
	listPublishers items: self lrpPublishers.

		
	
	
]

{ #category : #accessing }
LRPPhaROSListUI >> listPublishers [
	^ listPublishers
]

{ #category : #accessing }
LRPPhaROSListUI >> listPublishers: anObject [
	listPublishers := anObject
]

{ #category : #accessing }
LRPPhaROSListUI >> listSubscriptions [
	^ listSubscriptions
]

{ #category : #accessing }
LRPPhaROSListUI >> listSubscriptions: anObject [
	listSubscriptions := anObject
]

{ #category : #actions }
LRPPhaROSListUI >> loadConfiguration [
	|file|
	
	file := Smalltalk ui theme
		chooseFileIn: World
		title: 'Select file to load'
		extensions: nil
		path: self filepath asFileReference
		preview: true.
	
	file ifNotNil: [ 
		self filepath: file asFileReference parent path.
		self filename: file fullName.
		phaROSBridge loadTopicsFrom: file. 
		self updateList]
]

{ #category : #accessing }
LRPPhaROSListUI >> lrpPublishers [

	^phaROSBridge ifNil:[#()] ifNotNil: [phaROSBridge publishers].
]

{ #category : #accessing }
LRPPhaROSListUI >> lrpSubscriptions [

	^phaROSBridge ifNil:[#()] ifNotNil: [phaROSBridge subscriptionInstances].
]

{ #category : #accessing }
LRPPhaROSListUI >> menuButtons [
	^ menuButtons
]

{ #category : #accessing }
LRPPhaROSListUI >> menuButtons: anObject [
	menuButtons := anObject
]

{ #category : #accessing }
LRPPhaROSListUI >> phaROSBridge [
	^ phaROSBridge
]

{ #category : #accessing }
LRPPhaROSListUI >> phaROSBridge: anObject [
	phaROSBridge := anObject
]

{ #category : #actions }
LRPPhaROSListUI >> removeSelectedPublisher [
	phaROSBridge removePublisher: listPublishers selectedItem.
	self updateList.
]

{ #category : #actions }
LRPPhaROSListUI >> removeSelectedSubscription [
	phaROSBridge removeSubscription: listSubscriptions selectedItem.
	self updateList.
]

{ #category : #actions }
LRPPhaROSListUI >> saveConfiguration [

	self filename 
		ifNil: [ self saveConfigurationAs ]
		ifNotNil: [ phaROSBridge saveTopicsAs: self filename asFileReference ].
]

{ #category : #actions }
LRPPhaROSListUI >> saveConfigurationAs [
	|fileref|
	
	fileref := Smalltalk ui theme
		fileSaveIn: World
		title: 'Enter filename to save'
		extensions: nil
		path: self filepath asFileReference.

	fileref ifNotNil: [
		self filepath: fileref parent path.
		self filename: fileref path.
		phaROSBridge saveTopicsAs: fileref.
	].
]

{ #category : #initialization }
LRPPhaROSListUI >> setupModelButtons [

	menuButtons := MenuModel new.
	menuButtons applyTo: self.
	menuButtons addGroup: [ :group|
		group addItem: [:item| 
			item 
				name: nil; description: 'Save Configuration';
				icon: (self iconNamed: #smallSaveIcon);
				action: [self saveConfiguration]
		].
		group addItem: [:item| 
			item 
				name: nil; description: 'Save Configuration As';
				icon: (self iconNamed: #smallSaveAsIcon);
				action: [self saveConfigurationAs]
		].
		group addItem: [:item| 
			item 
				name: nil; description: 'Load Configuration';
				icon: (self iconNamed: #openIcon);
				action: [self loadConfiguration]
		]
	].
	menuButtons addGroup: [ :group|]
]

{ #category : #initialization }
LRPPhaROSListUI >> setupPubMenu [

	listPublishers selectedItem 
		ifNil: [  
			listPublishers menu: [:menu :shifted| nil ]	
		]
		ifNotNil:[
			listPublishers menu: [ :menu :shifted| 
				menu 
					add: 'Delete'
					target: self
					selector: #removeSelectedPublisher.
				menu
			]
		]
	

	
]

{ #category : #initialization }
LRPPhaROSListUI >> setupSubMenu [
	
	listSubscriptions  selectedItem 
		ifNil: [  
			listSubscriptions menu: [:menu :shifted| nil ]	
		]
		ifNotNil:[
			listSubscriptions menu: [ :menu :shifted| 
				menu 
					add: 'Delete'
					target: self
					selector: #removeSelectedSubscription.
				menu
			]
		]
	

]

{ #category : #'public api' }
LRPPhaROSListUI >> updateList [

	listSubscriptions items: self lrpSubscriptions.
	listPublishers items: self lrpPublishers
]
