"
A LRPErrorHandlerUI is a small UI to show LRP errors in a list, with the ability to clean the list.
"
Class {
	#name : #LRPErrorHandlerUI,
	#superclass : #SpPresenter,
	#instVars : [
		'errorList',
		'cleanButton',
		'debugToggle',
		'styler'
	],
	#category : #'LiveRobotics-UI'
}

{ #category : #specs }
LRPErrorHandlerUI class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [:col|
			col add: #errorList; 
			newRow: [ :row | row add: #cleanButton; add: #debugToggle] height: (self toolbarHeight)].
]

{ #category : #specs }
LRPErrorHandlerUI class >> title [
	^'LRP Errors'
]

{ #category : #accessing }
LRPErrorHandlerUI >> cleanButton [
	^ cleanButton
]

{ #category : #accessing }
LRPErrorHandlerUI >> cleanButton: anObject [
	cleanButton := anObject
]

{ #category : #accessing }
LRPErrorHandlerUI >> debugToggle [
	^ debugToggle
]

{ #category : #accessing }
LRPErrorHandlerUI >> debugToggle: anObject [
	debugToggle := anObject
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> duplicateVar: aVarName [ 

	self show: 'Var: ', aVarName, ' redefinition ignored'.
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> error: anException inBlock: aBlock [

	self styler
		addIcon: Smalltalk ui icons exception
		at: aBlock left + 1
		withLabel: anException asString.
	self styler addUnderlineFrom: aBlock left + 1 to: aBlock right + 1 color: Color orange.

	debugToggle state
		ifTrue: [
			Processor activeProcess
				debug: (anException signalerContext
					findContextSuchThat:[:ctx | ctx contextClass name beginsWith: 'LRPGC'])
				title: anException description.
			]
		ifFalse: [self show: 'Block Eval Fail: ',anException asString.].
]

{ #category : #accessing }
LRPErrorHandlerUI >> errorList [
	^ errorList
]

{ #category : #accessing }
LRPErrorHandlerUI >> errorList: anObject [
	errorList := anObject
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> eventHasNotBool: anEvent value: anObject [
	| errorText |
	errorText := 'Event ', anEvent name, ' returned ', anObject asString.

	debugToggle state
		ifTrue: [Error signal: errorText]
		ifFalse: [self show: errorText].

]

{ #category : #'error handling' }
LRPErrorHandlerUI >> eventNotFound: anEventName machine: aLRPMachine [

	self show: 'In machine ', aLRPMachine name, ', event ', anEventName, ' is not found'.
]

{ #category : #accessing }
LRPErrorHandlerUI >> extent [
	^300@200
]

{ #category : #initialization }
LRPErrorHandlerUI >> initializePresenter [

	cleanButton action:[errorList items: OrderedCollection new]
]

{ #category : #initialization }
LRPErrorHandlerUI >> initializeWidgets [
	errorList := self newList.
	cleanButton := self newButton.
	debugToggle := self newCheckBox.
	
	errorList items: OrderedCollection new.
	cleanButton label: 'Empty List'.
	debugToggle label: 'Debug Blocks'
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> machineNotFound: aMachineName [

	self show: 'Machine ', aMachineName, ' is not found'.
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> machineNotSpawnable: aMachine [

	self show: 'Machine ', aMachine name, ' cannot be spawned as it is already running'.
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> show: aString [
	(self errorList listItems contains: [ :item | item = aString ])
		ifFalse: [ self errorList listItems add: aString. self errorList updateList].
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> stateNotFound: aStateName machine: aLRPMachine [

	self show: 'In machine: ', aLRPMachine name, ', state ', aStateName asString, ' is not found'.
]

{ #category : #accessing }
LRPErrorHandlerUI >> styler [
	^ styler
]

{ #category : #accessing }
LRPErrorHandlerUI >> styler: anObject [
	styler := anObject
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> timeoutIsNotNumber: aLRPTransition timeout: aValue [

	self show: 'In transition: ', aLRPTransition name, ', timeout value ', aValue asString, ' is not a number'.
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> varNotFound: aVarName [ 

	self show: 'Var: ', aVarName, ' is not found'.
]

{ #category : #'error handling' }
LRPErrorHandlerUI >> varNotFound: aVarName transition: aLRPTransition [

	self show: 'In transition: ', aLRPTransition name, ', var ', aVarName, ' is not found'.
]
