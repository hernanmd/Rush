"
This is a basic class hierarchy browser (CHB) which tries to stay close to the original CHB from Smalltalk-80.

### Example

```smalltalk
RushBasicClassBrowser new open.
```
"
Class {
	#name : 'RushBasicClassBrowser',
	#superclass : 'RushMinimalBrowser',
	#instVars : [
		'classes',
		'instProtocols',
		'instMethods',
		'instVariables',
		'selectedInstMethods',
		'classDefinition',
		'classPathBreadcrumb'
	],
	#category : 'Rush-Core',
	#package : 'Rush',
	#tag : 'Core'
}

{ #category : 'commands' }
RushBasicClassBrowser class >> buildClassCreationGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'ClassCreationRushMenu') asSpecGroup
		register: ((SycCmAddSubclassCommand
			forSpecWithIconNamed: #glamorousAdd
			shortcutKey: 'A' asShortcut) 
				context: presenterInstance);	
		register: ((SycCmInsertSubclassCommand
			forSpecWithIconNamed: #glamorousInto
			shortcutKey: 'I' asShortcut) 
				context: presenterInstance);
		register: ((SycCmInsertSuperclassCommand
			forSpecWithIconNamed: #glamorousUp
			shortcutKey: 'S' asShortcut) 
				context: presenterInstance);				
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
RushBasicClassBrowser class >> buildClassSelectionGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'ClassSelectionRushMenu') asSpecGroup
		register: ((SycDeprecateClassCmCommand
			forSpecWithIconNamed: #glamorousEdit
			shortcutKey: 'D' asShortcut) 
				context: presenterInstance);	
		register: ((SycCMakeAbstractCommand
			forSpecWithIconNamed: #glamorousRedCircle
			shortcutKey: 'T' asShortcut) 
				context: presenterInstance);		
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
RushBasicClassBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup
		register: (self buildRushContextualGroupWith: presenterInstance)
]

{ #category : 'commands' }
RushBasicClassBrowser class >> buildRushContextualGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'RushSelContextualMenu') asSpecGroup
		register: (self buildClassCreationGroupWith: presenterInstance);
		register: (self buildClassSelectionGroupWith: presenterInstance);
		"register: (self buildRepositoryOperationsGroupWith: presenterInstance);
		register: (self buildFormulaOperationsGroupWith: presenterInstance);"
		yourself
]

{ #category : 'initialization' }
RushBasicClassBrowser >> addInstanceMethodsColumnsTo: instMthdsTablePresenter [

	instMthdsTablePresenter
		addColumn: ((SpCheckBoxTableColumn title: '' evaluated: [ : im | self selectedInstMethods includes: im ])
			onActivation: [ : cv | ];
			onDeactivation: [ : cv |  ];
			beNotExpandable;
			width: 20;
			yourself);
		addColumn: ((SpStringTableColumn title: 'Name' evaluated: [ : im | im selector asString ])
			width: 180;
			yourself)
]

{ #category : 'initialization' }
RushBasicClassBrowser >> browserTitle [ 

	^ 'Basic Class Hierarchy Browser'
]

{ #category : 'initialization' }
RushBasicClassBrowser >> buildOrganizationProtocols: aClass [

	^ aClass
		  ifNotNil: [
			  aClass protocols
				  collect: [ :each | aClass -> each ]
				  as: OrderedCollection ]
		  ifNil: [ Array empty ]
]

{ #category : 'layout' }
RushBasicClassBrowser >> classesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Classes' expand: false;
		  add: classes;
		  yourself
]

{ #category : 'initialization' }
RushBasicClassBrowser >> connectClassesPresenter [

	classes transmitTo: classPathBreadcrumb.

	classes
		transmitTo: instProtocols
		transform: [ : aClass | self buildOrganizationProtocols: aClass ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	classes transmitTo: instVariables transform: [ :aClass |
		aClass ifNotNil: [ aClass instanceVariables ] ifNil: [ Array empty ] ].

	classes transmitTo: classDefinition transform: [ :aClass |
		aClass ifNotNil: [ aClass definitionString ] ifNil: [ '' ] ].

]

{ #category : 'initialization' }
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

{ #category : 'initialization' }
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

{ #category : 'initialization' }
RushBasicClassBrowser >> connectPresenters [

	self connectClassesPresenter.
	self connectInstProtocolsPresenter.
	self connectInstMethodsPresenter.
]

{ #category : 'initialization' }
RushBasicClassBrowser >> defaultClasses [

	^ Smalltalk image allClasses asSortedCollection: [ : a : b | a name < b name ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeClassDefinitionPresenter [

	classDefinition := self newCode
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeClassPathPresenter [

	classPathBreadcrumb := (self instantiate: RushClassPathPresenter on: String empty)
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeClassesPresenter [

	classes := self newFilteringList.
	classes listPresenter
		items: self defaultClasses;
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		sortingBlock: [ :a :b | a name < b name ];
		contextMenu: [ (self rootCommandsGroup / 'RushSelContextualMenu') beRoot asMenuPresenter ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeInstMethodsPresenter [

	instMethods := self newTable.
	self addInstanceMethodsColumnsTo: instMethods.
	instMethods
		alternateRowsColor;
		items: OrderedCollection new;
		sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeInstProtocolsPresenter [

	instProtocols := self newFilteringList.
	instProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeInstVariablesPresenter [

	instVariables := self newFilteringList.
	instVariables listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializePresenters [

	self initializeClassPathPresenter.
	self initializeClassesPresenter.
	
	self initializeInstProtocolsPresenter.
	self initializeInstVariablesPresenter.
	self initializeInstMethodsPresenter.

	self initializeCodePresenter.
	self initializeClassDefinitionPresenter.

]

{ #category : 'initialization' }
RushBasicClassBrowser >> instMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight 
				add: 'Instance Methods' expand: false;
				yourself) expand: false;
		  add: instMethods;
		  yourself
]

{ #category : 'initialization' }
RushBasicClassBrowser >> instProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Protocols' expand: false;
		  add: instProtocols;
		  yourself
]

{ #category : 'initialization' }
RushBasicClassBrowser >> instVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Variables' expand: false;
		  add: instVariables;
		  yourself
]

{ #category : 'layout' }
RushBasicClassBrowser >> lowerPaneLayout [

	^ SpBoxLayout newLeftToRight
		add: srcCodePresenter;
		yourself
]

{ #category : 'opening' }
RushBasicClassBrowser >> openOnClass: aClass [ 

	classes selectItem: aClass.
]

{ #category : 'opening' }
RushBasicClassBrowser >> openOnMethod: aMethod [ 

	classes selectItem: aMethod selector
]

{ #category : 'command execution' }
RushBasicClassBrowser >> processFailure: aMessageNotUnderstood of: aSycCmAddSubclassCommand [ 

	aMessageNotUnderstood notifyUserOfCommand: aSycCmAddSubclassCommand
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectAllProtocolIn: aSpListPresenter [ 
	"Answer an item representing the all protocols in aSpListPresenter"
	
	aSpListPresenter selectItem: (aSpListPresenter items collect: #value)
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectClass: anObject [

	anObject asRushSelectionIn: self

]

{ #category : 'backstops' }
RushBasicClassBrowser >> selectedClass [
	"Asnwer the receiver currently selected <Class>"
	
	^ classes selectedItem.
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectedInstMethods [

	^ selectedInstMethods
		ifNil: [ selectedInstMethods := OrderedCollection new ]
]

{ #category : 'layout' }
RushBasicClassBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self classesLayout;
			add: (SpPanedLayout newTopToBottom
				add: self instProtocolsLayout;
				add: self instVarsLayout;
				yourself);
			add: self instMethodsLayout;
			yourself);
		yourself
]
