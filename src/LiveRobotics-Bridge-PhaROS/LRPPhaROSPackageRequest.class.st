Class {
	#name : #LRPPhaROSPackageRequest,
	#superclass : #Notification,
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #accessing }
LRPPhaROSPackageRequest class >> messagePrompt [
	^
'Please type the PhaROS package class name. 
It will be used to initialize the bridge of PhaROS in LRP.
'
]

{ #category : #exceptiondescription }
LRPPhaROSPackageRequest >> defaultAction [
	^ UIManager default
			request: self messagePrompt
			initialAnswer: LRPPhaROSBridge defaultPackageName
			title: 'PhaROS Package Identification' 
]

{ #category : #accessing }
LRPPhaROSPackageRequest >> messagePrompt [
	^ self class messagePrompt
]
