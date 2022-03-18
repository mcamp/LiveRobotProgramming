Class {
	#name : #LRPEV3IPRequest,
	#superclass : #Notification,
	#instVars : [
		'defaultIP'
	],
	#category : #'LiveRobotics-Bridge-JetStorm'
}

{ #category : #accessing }
LRPEV3IPRequest class >> messagePrompt [
	^
'Please type the IP from the EV3 Brick. 
It will be used to initialize the bridge of JetStorm in LRP.
'
]

{ #category : #exceptiondescription }
LRPEV3IPRequest >> defaultAction [
	^ UIManager default
			request: self messagePrompt
			initialAnswer: self defaultIP
			title: 'EV3 Brick IP' 
]

{ #category : #accessing }
LRPEV3IPRequest >> defaultIP [
	^ defaultIP
]

{ #category : #accessing }
LRPEV3IPRequest >> defaultIP: anObject [
	defaultIP := anObject
]

{ #category : #accessing }
LRPEV3IPRequest >> messagePrompt [
	^ self class messagePrompt
]
