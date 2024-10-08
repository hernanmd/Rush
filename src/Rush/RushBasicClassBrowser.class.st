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
		'classPathBreadcrumb',
		'sideSelectorPresenter'
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

	classes transmitTo: instMethods transform: [ : aClass |
		aClass 
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ aClass methods ] ]

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
RushBasicClassBrowser >> connectInstVariablesPresenter [

	instVariables 
		transmitTo: instMethods
		transform: [ : instVarSlot | 
			instVarSlot
				ifNotNil: [ self selectedRBClass whichMethodsReferToInstanceVariable: instVarSlot name ]
				ifNil: [ #(  ) ] ].

		
]

{ #category : 'initialization' }
RushBasicClassBrowser >> connectPresenters [

	self connectClassesPresenter.
	self connectInstProtocolsPresenter.
	self connectInstMethodsPresenter.
	self connectInstVariablesPresenter
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

	classPathBreadcrumb := self instantiate: RushClassPathPresenter on: String empty
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
	instProtocols
		headerTitle: 'Instance protocols';
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeInstVariablesPresenter [

	instVariables := self newFilteringList.
	instVariables
		headerTitle: 'Instance variables';
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializePresenters [

	self initializeClassPathPresenter.
	self initializeClassesPresenter.
	
	self initializeInstProtocolsPresenter.
	self initializeInstVariablesPresenter.
	self initializeSideSelectorPresenter.
	self initializeInstMethodsPresenter.

	self initializeCodePresenter.
	self initializeClassDefinitionPresenter.

]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeSideSelectorPresenter [

	sideSelectorPresenter := self newCheckBox
		label: 'Class';
		whenActivatedDo: [ 
			instProtocols 
				headerTitle: 'Class protocols';
				items: (self buildOrganizationProtocols: self selectedClass class).
			instVariables
				headerTitle: 'Class variables';
				items: self selectedClass classVariables ];
		whenDeactivatedDo: [ 
			instProtocols 
				headerTitle: 'Instance protocols';
				items: (self buildOrganizationProtocols: self selectedClass).
			instVariables
				headerTitle: 'Instance variables';
				items: self class instanceVariables ];
		yourself.
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

{ #category : 'accessing' }
RushBasicClassBrowser >> lastSelectedClass [
	"For compatibiliy with Commander 2 system commands"
	
	^ self selectedClass
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

{ #category : 'refactoring support' }
RushBasicClassBrowser >> refactoringScopes [
	"Implemented because commands refers to 'refactoringScopes', implemnted in Calypso"

	^ { RBBrowserEnvironmentWrapper onEnvironment: RBBrowserEnvironment new }
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

{ #category : 'initialization' }
RushBasicClassBrowser >> selectedRBClass [
	"Private - Answer the selected class as RB class"

	^ (RBNamespace onEnvironment: (RBClassEnvironment class: self selectedClass))
		classFor: self selectedClass.
]

{ #category : 'tool controlling' }
RushBasicClassBrowser >> showClass: aClass [ 

	| selected choices |
	choices := { 'Select new class' .
		'Open a new browser on the new class' .
		'Do nothing' }.
	selected := self application newSelect 
		items: choices;
		title: 'Select post-creation action';
		openModal.
	selected ifNil: [ ^ self ].
	selected = choices first
		ifTrue: [ ^ self selectClass: aClass ].
	selected = choices second
		ifTrue: [ self class openOnClass: aClass ].

]

{ #category : 'accessing' }
RushBasicClassBrowser >> system [
	"Another System Command - Calypso bag we need to carry"
	
	^ self class environment
]

{ #category : 'layout' }
RushBasicClassBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self classesLayout;
			add: (SpBoxLayout newTopToBottom
				add: instProtocols;
				add: instVariables;
				add: sideSelectorPresenter expand: false;
				yourself);
			add: self instMethodsLayout;
			yourself);
		yourself
]
