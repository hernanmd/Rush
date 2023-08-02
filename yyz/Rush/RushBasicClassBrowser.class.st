Class {
	#name : #RushBasicClassBrowser,
	#superclass : #RushMinimalBrowser,
	#instVars : [
		'classes',
		'instProtocols',
		'instMethods',
		'instVariables',
		'classProtocols',
		'classMethods',
		'classVariables',
		'selectedClsVars',
		'classComment',
		'selectedInstMethods',
		'classDefinition',
		'sendersCheckPresenter',
		'classPathBreadcrumb',
		'references',
		'referenceMethod'
	],
	#category : #Rush
}

{ #category : #layout }
RushBasicClassBrowser >> classesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Classes' expand: false;
		  add: classes;
		  yourself
]

{ #category : #'private-class side' }
RushBasicClassBrowser >> connectClassMethodsPresenter [

	classMethods
		transmitTo: srcCodePresenter
		transform: [ :aMethod | aMethod ifNotNil: [ aMethod sourceCode ] ifNil: [ '' ] ]
]

{ #category : #initialization }
RushBasicClassBrowser >> connectClassesPresenter [

	classes transmitTo: classPathBreadcrumb.

	classes
		transmitTo: classProtocols
		transform: [ :aClass | self buildOrganizationProtocols: aClass class ]
		postTransmission: [ :destination :origin |
		self selectAllProtocolIn: destination ].

	classes transmitTo: classVariables transform: [ :aClass |
		aClass ifNotNil: [ aClass classVariables ] ifNil: [ Array empty ] ].

	classes
		transmitTo: instProtocols
		transform: [ : aClass | self buildOrganizationProtocols: aClass ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	classes transmitTo: instVariables transform: [ :aClass |
		aClass ifNotNil: [ aClass instanceVariables ] ifNil: [ Array empty ] ].

	classes transmitTo: classComment transform: [ :aClass |
		aClass ifNotNil: [ aClass comment ] ifNil: [ String empty ] ].

	classes transmitTo: classDefinition transform: [ :aClass |
		aClass ifNotNil: [ aClass definitionString ] ifNil: [ '' ] ].

	classes
		transmitTo: references
		transform: [ :aClass |
			aClass
				ifNotNil: [ self systemNavigation allReferencesTo: aClass binding ]
				ifNil: [ Array empty ] ]
		postTransmission: [ :list | references items: list items ]
]

{ #category : #'private-instance side' }
RushBasicClassBrowser >> connectInstMethodsPresenter [

	instMethods
		transmitTo: srcCodePresenter
		transform: [ :aMethod |
			aMethod
				ifNotNil: [
					srcCodePresenter beForMethod: aMethod.
					aMethod sourceCode ]
				ifNil: [ '' ] ]
]

{ #category : #'private-instance side' }
RushBasicClassBrowser >> connectInstProtocolsPresenter [

	instProtocols
		transmitTo: instMethods
		transform: [ :aPair | 
			aPair
				ifNotNil: [ 
					aPair value methodSelectors
						collect: [ :each | aPair key >> each ]
						as: OrderedCollection ]
				ifNil: [ #(  ) ] ].
			
	instProtocols
		transmitTo: srcCodePresenter
		transform: [ :aPair | aPair ifNotNil: [ 	aPair key sourceCodeTemplate ] ifNil: [ '' ] ]
		
]

{ #category : #initialization }
RushBasicClassBrowser >> defaultClasses [

	^ Smalltalk image allClasses asSortedCollection: [ : a : b | a name < b name ]
]

{ #category : #initialization }
RushBasicClassBrowser >> initializeClassDefinitionPresenter [

	classDefinition := self newCode
]

{ #category : #initialization }
RushBasicClassBrowser >> initializeClassPathPresenter [

	classPathBreadcrumb := (self instantiate: RushClassPathPresenter on: String empty)
]

{ #category : #initialization }
RushBasicClassBrowser >> initializeClassesPresenter [

	classes := self newFilteringList.
	classes listPresenter
		items: self defaultClasses;
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #initialization }
RushBasicClassBrowser >> initializeCommentPresenter [

	classComment := self newText.
	classComment 
		placeholder: 'Class comment';
		text: '';
		beNotEditable;
		addStyle: 'iceTipReadonly';
		addStyle: 'iceTipText4Lines';
		beWrapWord
]

{ #category : #initialization }
RushBasicClassBrowser >> initializeInstMethodsPresenter [

	sendersCheckPresenter := self newCheckBox
		label: 'Senders';
		state: RushSettings computeSenders;
		whenChangedDo: [ : c | RushSettings computeSenders: c ].

	instMethods := self newTable.
	self addInstanceMethodsColumnsTo: instMethods.
	instMethods
		alternateRowsColor;
		items: OrderedCollection new;
		sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : #'private-instance side' }
RushBasicClassBrowser >> initializeInstProtocolsPresenter [

	instProtocols := self newFilteringList.
	instProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #'private-instance side' }
RushBasicClassBrowser >> initializeInstVariablesPresenter [

	instVariables := self newFilteringList.
	instVariables listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #initialization }
RushBasicClassBrowser >> initializePresenters [

	self initializeClassPathPresenter.
	self initializeClassesPresenter.
	
	self initializeInstProtocolsPresenter.
	self initializeInstVariablesPresenter.
	self initializeInstMethodsPresenter.

	self initializeClassProtocolsPresenter.
	self initializeClassVariablesPresenter.
	self initializeClassMethodsPresenter.

	self initializeCodePresenter.
	self initializeClassDefinitionPresenter.
	self initializeCommentPresenter.
	self initializeReferencesPresenter.
]

{ #category : #layout }
RushBasicClassBrowser >> instMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight 
				add: 'Instance Methods' expand: false;
				yourself) expand: false;
		  add: instMethods;
		  yourself
]

{ #category : #opening }
RushBasicClassBrowser >> openOnClass: aClass [ 

	classes selectItem: aClass.
]

{ #category : #opening }
RushBasicClassBrowser >> openOnMethod: aMethod [ 

	classes selectItem: aMethod selector
]

{ #category : #private }
RushBasicClassBrowser >> selectAllProtocolIn: aSpListPresenter [ 
	"Answer an item representing the all protocols in aSpListPresenter"
	
	aSpListPresenter selectItem: (aSpListPresenter items collect: #value)
]

{ #category : #initialization }
RushBasicClassBrowser >> selectClass: anObject [

	anObject asRushSelectionIn: self

]

{ #category : #accessing }
RushBasicClassBrowser >> selectedInstMethods [

	^ selectedInstMethods
		ifNil: [ selectedInstMethods := OrderedCollection new ]
]
