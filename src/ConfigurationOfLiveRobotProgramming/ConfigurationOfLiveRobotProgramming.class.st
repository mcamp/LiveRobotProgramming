Class {
	#name : #ConfigurationOfLiveRobotProgramming,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfLiveRobotProgramming
}

{ #category : #'development support' }
ConfigurationOfLiveRobotProgramming class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfLiveRobotProgramming class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfLiveRobotProgramming class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfLiveRobotProgramming class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfLiveRobotProgramming class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfLiveRobotProgramming class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfLiveRobotProgramming class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfLiveRobotProgramming class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfLiveRobotProgramming class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfLiveRobotProgramming class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfLiveRobotProgramming >> baseline01: spec [
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/jfabry/LiveRobotProgramming/main/'.
		spec 
			project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitSmalltalk;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/Moose/Moose/main/';
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ];
			project: 'PetitCompiler' with: [ 
    			spec
					className: 'ConfigurationOfPetitCompiler'; 
    				file: 'ConfigurationOfPetitCompiler'; 
    				version: #development; 
    				loads: #(#'Core'); 
    				repository: 'http://smalltalkhub.com/mc/JanKurs/PetitParser/main' ];
			project: 'Roassal2' with: [
				spec
					className: #ConfigurationOfRoassal2;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal/main/';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ].
		spec 
			package: 'LiveRobotics-Parser';
			package: 'LiveRobotics-Interpreter' with: [
				spec requires: #('LiveRobotics-Parser' ). ];
			package: 'LiveRobotics-UI' with: [
				spec requires: #('LiveRobotics-Interpreter' ). ];
			package: 'LiveRobotics-Tests' with: [
				spec requires: #('LiveRobotics-Interpreter' 'LiveRobotics-Parser' ). ]. ].

]

{ #category : #accessing }
ConfigurationOfLiveRobotProgramming >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfLiveRobotProgramming >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfLiveRobotProgramming >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]
