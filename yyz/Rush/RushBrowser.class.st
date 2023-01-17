Class {
	#name : #RushBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'packages',
		'classes',
		'instProtocols',
		'instMethods',
		'code',
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

{ #category : #'instance creation' }
RushBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #layout }
RushBrowser >> classMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Methods' expand: false;
		  add: classMethods;
		  yourself
]

{ #category : #layout }
RushBrowser >> classProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Protocols' expand: false;
		  add: classProtocols;
		  yourself
]

{ #category : #layout }
RushBrowser >> classTemplateFor: aPackage [

	aPackage ifNil: [ ^ '' ].

	^ 'Object subclass: #NameOfSubclass
	slots: {}
	classVariables: {}
	package: ''' , aPackage name , ''' '
]

{ #category : #layout }
RushBrowser >> classVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Variables' expand: false;
		  add: classVariables;
		  yourself
]

{ #category : #layout }
RushBrowser >> classesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Classes' expand: false;
		  add: classes;
		  yourself
]

{ #category : #'private-class side' }
RushBrowser >> connectClassMethodsPresenter [

	classMethods
		transmitTo: code
		transform: [ :aMethod | aMethod ifNotNil: [ aMethod sourceCode ] ifNil: [ '' ] ]
]

{ #category : #'private-class side' }
RushBrowser >> connectClassProtocolsPresenter [

	classProtocols
		transmitTo: classMethods
		transform: [ :aPair | 
			aPair
				ifNotNil: [ 
					aPair value methodSelectors
						collect: [ :each | aPair key class >> each ]
						as: OrderedCollection ]
				ifNil: [ #(  ) ] ].
			
	classProtocols
		transmitTo: code
		transform: [ :aPair | aPair ifNotNil: [ aPair key class sourceCodeTemplate ] ifNil: [ '' ] ]
]

{ #category : #initialization }
RushBrowser >> connectClassesPresenter [

	classes
		transmitTo: classPathBreadcrumb.

	classes
		transmitTo: classProtocols
		transform: [ :aClass |
			aClass
				ifNotNil: [
					aClass class organization allProtocols
						collect: [ :each | aClass -> each ]
						as: OrderedCollection ]
				ifNil: [ Array empty ] ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	classes
		transmitTo: classVariables
		transform: [ : aClass |
			aClass
				ifNotNil: [ aClass classVariables ]
				ifNil: [ Array empty ] ].

	classes
		transmitTo: instProtocols
		transform: [ :aClass |
			aClass
				ifNotNil: [
					aClass organization allProtocols
						collect: [ :each | aClass -> each ]
						as: OrderedCollection ]
				ifNil: [ #(  ) ] ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	classes
		transmitTo: instVariables
		transform: [ : aClass |
			aClass
				ifNotNil: [ aClass instanceVariables ]
				ifNil: [ Array empty ] ].

	classes
		transmitTo: classComment
		transform: [ : aClass | aClass ifNotNil: [ aClass comment ] ifNil: [ String empty ] ].

	classes
		transmitTo: classDefinition
		transform: [ :aClass | aClass ifNotNil: [ aClass definitionString ] ifNil: [ '' ] ].

	classes
		transmitTo: references
		transform: [ : aClass | 
			aClass 
				ifNotNil: [ self systemNavigation allReferencesTo: aClass binding ] 
				ifNil: [ Array empty ] ]
		postTransmission: [ : list | references items: list items ]
]

{ #category : #'private-instance side' }
RushBrowser >> connectInstMethodsPresenter [

	instMethods
		transmitTo: code
		transform: [ :aMethod |
			aMethod
				ifNotNil: [
					code beForMethod: aMethod.
					aMethod sourceCode ]
				ifNil: [ '' ] ]
]

{ #category : #'private-instance side' }
RushBrowser >> connectInstProtocolsPresenter [

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
		transmitTo: code
		transform: [ :aPair | aPair ifNotNil: [ 	aPair key sourceCodeTemplate ] ifNil: [ '' ] ]
		
]

{ #category : #initialization }
RushBrowser >> connectPackagesPresenter [

	packages
		transmitTo: classes
		transform: [ :aPackage |
			aPackage
				ifNotNil: [ aPackage definedClasses asArray ]
				ifNil: [ #(  ) ] ].

	packages
		transmitTo: classDefinition
		transform: [ :aPackage | self classTemplateFor: aPackage ]
]

{ #category : #initialization }
RushBrowser >> connectPresenters [

	self connectPackagesPresenter.
	self connectClassesPresenter.
	self connectInstProtocolsPresenter.
	self connectInstMethodsPresenter.
	self connectClassProtocolsPresenter.
	self connectClassMethodsPresenter.
	self connectReferencesPresenter
]

{ #category : #initialization }
RushBrowser >> connectReferencesPresenter [

	references
		transmitTo: referenceMethod
		transform: [ : aMethod |
			aMethod
				ifNotNil: [
					referenceMethod beForMethod: aMethod.
					aMethod sourceCode ]
				ifNil: [ '' ] ]
]

{ #category : #layout }
RushBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: self upperPaneLayout;
		  add: self lowerPaneLayout;
		  yourself
]

{ #category : #'private-instance side' }
RushBrowser >> displaySendersIn: im [

	^ self displaySendersSetting
		ifTrue: [ im senders size asString ]
		ifFalse: [ 'NC' ]
]

{ #category : #accessing }
RushBrowser >> displaySendersSetting [

	^ RushSettings computeSenders
]

{ #category : #initialization }
RushBrowser >> initializeClassDefinitionPresenter [

	classDefinition := self newCode
]

{ #category : #'private-class side' }
RushBrowser >> initializeClassMethodsPresenter [

	classMethods := self newList.
	classMethods
		display: [ :method | method selector ];
		sortingBlock: [ :a :b | a selector  < b selector ]
]

{ #category : #initialization }
RushBrowser >> initializeClassPathPresenter [

	classPathBreadcrumb := (self instantiate: RushClassPathPresenter on: String empty)
]

{ #category : #'private-class side' }
RushBrowser >> initializeClassProtocolsPresenter [

	classProtocols := self newFilteringList.
	classProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #'private-class side' }
RushBrowser >> initializeClassVariablesPresenter [

	classVariables := self newTable.
	classVariables
		addColumn: ((SpCheckBoxTableColumn title: '' evaluated: [ : cv | self selectedClsVars includes: cv ])
			onActivation: [ : cv | ];
			onDeactivation: [ : cv |  ];
			beNotExpandable;
			width: 20;
			yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ : cv | cv name ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ : assoc | assoc value asString ]);
		alternateRowsColor;
		items: OrderedCollection new;
		sortingBlock: [ :a :b | a key < b key ]
]

{ #category : #initialization }
RushBrowser >> initializeClassesPresenter [

	classes := self newFilteringList.
	classes listPresenter
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #initialization }
RushBrowser >> initializeCodePresenter [

	code := self newCode
]

{ #category : #initialization }
RushBrowser >> initializeCommentPresenter [

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
RushBrowser >> initializeInstMethodsPresenter [

	sendersCheckPresenter := self newCheckBox
		label: 'Senders';
		state: RushSettings computeSenders;
		whenChangedDo: [ : c | RushSettings computeSenders: c ].

	instMethods := self newTable.
	instMethods
		addColumn: ((SpCheckBoxTableColumn title: '' evaluated: [ : im | self selectedInstMethods includes: im ])
			onActivation: [ : cv | ];
			onDeactivation: [ : cv |  ];
			beNotExpandable;
			width: 20;
			yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ : im | im selector asString ]);
		addColumn: (SpStringTableColumn title: 'Senders' evaluated: [ : im | self displaySendersIn: im ]);
		alternateRowsColor;
		items: OrderedCollection new;
		sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : #'private-instance side' }
RushBrowser >> initializeInstProtocolsPresenter [

	instProtocols := self newFilteringList.
	instProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #'private-instance side' }
RushBrowser >> initializeInstVariablesPresenter [

	instVariables := self newFilteringList.
	instVariables listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #initialization }
RushBrowser >> initializePackagesPresenter [

	packages := self newFilteringList.
	packages listPresenter
		display: [ :package | package name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: RPackageOrganizer default packages
]

{ #category : #initialization }
RushBrowser >> initializePresenters [

	self initializeClassPathPresenter.

	self initializePackagesPresenter.
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

{ #category : #initialization }
RushBrowser >> initializeReferencesPresenter [

	references := self newFilteringList.
	references listPresenter
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ].
		
	referenceMethod := self newCode.
]

{ #category : #initialization }
RushBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Coso browser';
		initialExtent: 1000 @ 700
]

{ #category : #layout }
RushBrowser >> instMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight 
				add: 'Instance Methods' expand: false;
				add: sendersCheckPresenter expand: false;
				yourself) expand: false;
		  add: instMethods;
		  yourself
]

{ #category : #layout }
RushBrowser >> instProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Protocols' expand: false;
		  add: instProtocols;
		  yourself
]

{ #category : #layout }
RushBrowser >> instVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Variables' expand: false;
		  add: instVariables;
		  yourself
]

{ #category : #layout }
RushBrowser >> lowerPaneLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: 0.3;
		add: (	SpBoxLayout newTopToBottom
			spacing: self spacingBetweenPanes;
			add: classComment;
			add: classDefinition;
			yourself);
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: (SpPanedLayout newTopToBottom 
				add: references;
				add: referenceMethod;
				yourself);
			add: code;
			yourself);
		yourself
]

{ #category : #layout }
RushBrowser >> packagesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Packages' expand: false;
		  add: packages;
		  yourself
]

{ #category : #private }
RushBrowser >> selectAllProtocolIn: aSpListPresenter [ 
	"Answer an item representing the all protocols in aSpListPresenter"
	
	aSpListPresenter selectItem: (aSpListPresenter items 
		detect: [ : modelItem | modelItem value isVirtualProtocol ]
		ifNone: [ nil ])
]

{ #category : #accessing }
RushBrowser >> selectedClsVars [

	^ selectedClsVars 
		ifNil: [ selectedClsVars := OrderedCollection new ]
]

{ #category : #accessing }
RushBrowser >> selectedInstMethods [

	^ selectedInstMethods
		ifNil: [ selectedInstMethods := OrderedCollection new ]
]

{ #category : #accessing }
RushBrowser >> spacingBetweenPanes [
	
	^ 5
]

{ #category : #layout }
RushBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self packagesLayout;
			add: self classesLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self classProtocolsLayout;
				add: self classVarsLayout;
				yourself);
			add: self classMethodsLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self instProtocolsLayout;
				add: self instVarsLayout;
				yourself);
			add: self instMethodsLayout;
			yourself);
		yourself
]
