Class {
	#name : #LRPPhaROSBridge,
	#superclass : #LRPAbstractBridge,
	#instVars : [
		'pharosInstance',
		'subscriptionInstances',
		'publishingInstances'
	],
	#classVars : [
		'DefaultPackageName'
	],
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #accessing }
LRPPhaROSBridge class >> defaultPackageName [

	^DefaultPackageName ifNil: [ DefaultPackageName := 'PhaROSPackage' ]
]

{ #category : #accessing }
LRPPhaROSBridge class >> defaultPackageName: aPackageName [

	DefaultPackageName:= aPackageName
]

{ #category : #publishing }
LRPPhaROSBridge >> addPublisher: aString topicID: aTopicID type: aType [
	|publisher lrpPublisher|
	
	publisher := pharosInstance controller node 
								topicPublisher: aTopicID
								typedAs: aType.
																	
	lrpPublisher := LRPPhaROSPublisher  new.
	lrpPublisher 
		phaROSPublisher: publisher;
		topicID: aTopicID;
		type: aType;
		varName: aString.
		
	publishingInstances at: aString put: lrpPublisher.		
			
	self setupPublisherMethod: aString.
	^ lrpPublisher
]

{ #category : #subscriptions }
LRPPhaROSBridge >> addSubscription: aString	topicID: aTopicID type: aType [
	|flux|
	
	self addIVar: aString.
	
	flux := (pharosInstance controller node buildConnectionFor: aTopicID ) 
								typedAs: aType; 
								for: [ : data |  self getData: data on: aString ];
								connect .
	
	^ self addTopic: aTopicID type: aType phaROSFlux: flux to: aString.
]

{ #category : #subscriptions }
LRPPhaROSBridge >> addTopic: aTopicID type: aType phaROSFlux: aPhaROSFlux to: aVarName [
	|lrpSubscription|
	
	lrpSubscription := LRPPhaROSSubscription new.
	lrpSubscription 
		phaROSFlux: aPhaROSFlux;
		topicID: aTopicID;
		type: aType;
		varName: aVarName.
		
	subscriptionInstances at: aVarName put: lrpSubscription.
	^ lrpSubscription.
]

{ #category : #cleanup }
LRPPhaROSBridge >> cleanUp [
	
	self removeAllSubscription.
	self removeAllPublisher.
	super cleanUp.
]

{ #category : #accessing }
LRPPhaROSBridge >> defaultPackageName [

	^self class defaultPackageName
]

{ #category : #accessing }
LRPPhaROSBridge >> defaultPackageName: aPackageName [

	self class defaultPackageName: aPackageName.
]

{ #category : #subscriptions }
LRPPhaROSBridge >> getData: aPhaROSData on: aVarName [

	generatedVars perform: (aVarName,':') asSymbol with: aPhaROSData.
]

{ #category : #initialization }
LRPPhaROSBridge >> initialize [

	super initialize.
	subscriptionInstances := Dictionary new.
	publishingInstances := Dictionary new.
]

{ #category : #saving }
LRPPhaROSBridge >> loadTopicsFrom: aFilePath [
	|bridgeSaver|
	
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver loadTopics: aFilePath.
	bridgeSaver subscriptions do: [ :sub|
		(self hasIVar: sub varName) ifFalse:[
			self addSubscription: sub varName	topicID: sub topicID type: sub type
		]
	].
	bridgeSaver publishers do: [ :pub|
		(self hasIVar: pub varName) ifFalse: [  
			self addPublisher: pub varName	topicID: pub topicID type: pub type
		]
	].

	^aFilePath.
	
	
]

{ #category : #ui }
LRPPhaROSBridge >> openUIFor: anInterpreter [
	|win|
	self setupPhaROSPackage.	
	win := LRPPhaROSListUI new phaROSBridge: self ; openWithSpec.
	win widget widget deleteCloseBox.
	^win.
]

{ #category : #accessing }
LRPPhaROSBridge >> pharosInstance [
	^ pharosInstance
]

{ #category : #accessing }
LRPPhaROSBridge >> pharosInstance: anObject [
	pharosInstance := anObject
]

{ #category : #accessing }
LRPPhaROSBridge >> publishers [

	^ publishingInstances
]

{ #category : #publishing }
LRPPhaROSBridge >> removeAllPublisher [

	publishingInstances valuesDo: [:aLRPPhaROSPublisher| self removePublisher: aLRPPhaROSPublisher ]
]

{ #category : #subscriptions }
LRPPhaROSBridge >> removeAllSubscription [

	subscriptionInstances valuesDo: [:aLRPPhaROSSubscription| self removeSubscription: aLRPPhaROSSubscription ]
]

{ #category : #subscriptions }
LRPPhaROSBridge >> removeFlux: aLRPPhaROSSubscription [

	self pharosInstance controller node 
		removeInterestIn: aLRPPhaROSSubscription  topicID 
		typedAs: aLRPPhaROSSubscription type
		for: aLRPPhaROSSubscription phaROSFlux
]

{ #category : #subscriptions }
LRPPhaROSBridge >> removePublisher: aLRPPhaROSPublisher [

	"should do anything with pharos?"
	self flag:#TODO.
	
	publishingInstances removeKey: aLRPPhaROSPublisher varName ifAbsent: [ ].
	self removeMethod: (aLRPPhaROSPublisher varName, ':') asSymbol.
	
	
]

{ #category : #subscriptions }
LRPPhaROSBridge >> removeSubscription: aLRPPhaROSSubscription [

	self removeFlux: aLRPPhaROSSubscription.
	
	subscriptionInstances removeKey: aLRPPhaROSSubscription varName ifAbsent: [ ].
	self removeIVar: aLRPPhaROSSubscription varName.
	
	
]

{ #category : #saving }
LRPPhaROSBridge >> saveTopicsAs: aFileRef [
	|bridgeSaver|
	
	bridgeSaver := LRPPhaROSSaver new.
	bridgeSaver subscriptions: subscriptionInstances values.
	bridgeSaver publishers: publishingInstances values.
	bridgeSaver saveTopics: aFileRef.
	
]

{ #category : #setup }
LRPPhaROSBridge >> setupPhaROSPackage [
	|pharosPackage|
	
	pharosPackage := ((LRPPhaROSPackageRequest new ) signal).
	pharosPackage ifNil:[
		self error: 'No Package given'
	] ifNotNil:[
		self defaultPackageName: pharosPackage.
		pharosInstance := pharosPackage asClass new.
	].
]

{ #category : #publishing }
LRPPhaROSBridge >> setupPublisherMethod: aPublisherName [
	|methodSignature methodSourceCode|
	
	methodSignature := aPublisherName, ': aBlock'.
	methodSourceCode := '
		(__lrpBridge publishers at: #',aPublisherName,') phaROSPublisher send: aBlock.
	'.
	
	self addMethod: methodSignature source: methodSourceCode.
]

{ #category : #accessing }
LRPPhaROSBridge >> subscriptionInstances [

	^ subscriptionInstances
]

{ #category : #accessing }
LRPPhaROSBridge >> subscriptionInstances: anObject [
	subscriptionInstances := anObject
]

{ #category : #accessing }
LRPPhaROSBridge >> subscriptions [

	^ subscriptionInstances
]
