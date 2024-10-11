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
		'classDefinition',
		'classPathBreadcrumb',
		'sideSelectorPresenter'
	],
	#category : 'Rush-Core',
	#package : 'Rush',
	#tag : 'Core'
}

{ #category : 'commands - classes' }
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

{ #category : 'commands - classes' }
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
		register: (self buildRushClassContextualGroupWith: presenterInstance);
		register: (self buildMethodContextualGroupWith: presenterInstance)
]

{ #category : 'commands - methods' }
RushBasicClassBrowser class >> buildMethodBrowsingGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'MethodBrowsingRushMenu') asSpecGroup
		register: ((CmCommandGroup forSpecNamed: 'View')
			beDisplayedAsGroup;
			register: (StMessageBrowseFullCommand forSpecContext: presenterInstance);
			register: (StMessageInspectMethodCommand forSpecContext: presenterInstance);
			register: (StMessageSendersCommand forSpecContext: presenterInstance);
			register: (StMessageImplementorsCommand forSpecContext: presenterInstance);
			register: (StMessageUsersCommand forSpecContext: presenterInstance);
			register: (StMessageVersionsCommand forSpecContext: presenterInstance);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'Critical')
			beDisplayedAsGroup;
			register: (StMessageRemoveMethodCommand forSpecContext: presenterInstance);
			register: (StVersionRevertCommand forSpecContext: presenterInstance);
			yourself);
		beRoot;
		yourself
]

{ #category : 'commands - methods' }
RushBasicClassBrowser class >> buildMethodContextualGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'RushMethodsSelContextualMenu') asSpecGroup
		register: (self buildMethodBrowsingGroupWith: presenterInstance);
		register: (self buildMethodRefactoringGroupWith: presenterInstance);
		register: (self buildMethodExtraGroupWith: presenterInstance);
		yourself
]

{ #category : 'commands - methods' }
RushBasicClassBrowser class >> buildMethodExtraGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'Extra') asSpecGroup
			register: (SycInspectMethodCommand forSpecContext: presenterInstance);
			register: (SycClassifyMthCommand forSpecContext: presenterInstance);
			register: (SycCopyMethodNameToClipboardCommand forSpecContext: presenterInstance);
			register: (SycCopyTestMethodNameToClipboardCommand forSpecContext: presenterInstance);
			register: (SycFileOutMethodCommand forSpecContext: presenterInstance);			
		yourself

]

{ #category : 'commands - methods' }
RushBasicClassBrowser class >> buildMethodRefactoringGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'Refactorings') asSpecGroup
		register: ((CmCommandGroup forSpecNamed: 'View')
			beDisplayedAsGroup;
			register: (StMessageBrowseFullCommand forSpecContext: self);
			register: (StMessageInspectMethodCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'Navigation')
			beDisplayedAsGroup;
			register: (StMessageSendersCommand forSpecContext: self);
			register: (StMessageImplementorsCommand forSpecContext: self);
			register: (StMessageUsersCommand forSpecContext: self);
			register: (StMessageVersionsCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StMessageRemoveMethodCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : 'commands' }
RushBasicClassBrowser class >> buildRushClassContextualGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'RushClassSelContextualMenu') asSpecGroup
		register: (self buildClassCreationGroupWith: presenterInstance);
		register: (self buildClassSelectionGroupWith: presenterInstance);
		"register: (self buildRepositoryOperationsGroupWith: presenterInstance);
		register: (self buildFormulaOperationsGroupWith: presenterInstance);"
		yourself
]

{ #category : 'initialization' }
RushBasicClassBrowser >> addInstanceMethodsColumnsTo: instMthdsTablePresenter [

	instMthdsTablePresenter
		addColumn: ((SpCheckBoxTableColumn title: '' evaluated: [ : im | self selectedMethods includes: im ])
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

{ #category : 'private - actions' }
RushBasicClassBrowser >> doBrowseMethod [

	self class updateSelectedMethod: self selectedMethod
]

{ #category : 'command execution' }
RushBasicClassBrowser >> doBrowseSenders [

	StMessageBrowser browse: self selectedMethods
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
		contextMenu: [ (self rootCommandsGroup / 'RushClassSelContextualMenu') beRoot asMenuPresenter ]
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
RushBasicClassBrowser >> initializeMethodsPresenter [

	instMethods := self newTable.
	self addInstanceMethodsColumnsTo: instMethods.
	instMethods
		alternateRowsColor;
		items: OrderedCollection new;
		sortingBlock: [ :a :b | a selector < b selector ];
		contextMenu: [ (self rootCommandsGroup / 'RushMethodsSelContextualMenu') beRoot asMenuPresenter ]
]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializePresenters [

	self initializeClassPathPresenter.
	self initializeClassesPresenter.
	
	self initializeProtocolsPresenter.
	self initializeInstVariablesPresenter.
	self initializeSideSelectorPresenter.
	self initializeMethodsPresenter.

	self initializeCodePresenter.
	self initializeClassDefinitionPresenter.

]

{ #category : 'initialization' }
RushBasicClassBrowser >> initializeProtocolsPresenter [

	instProtocols := self newFilteringList.
	instProtocols
		headerTitle: 'Instance protocols';
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
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

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectMethod: aCompiledMethod [

	aCompiledMethod asRushSelectionIn: self

]

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectedClass [
	"Asnwer the receiver currently selected <Class>"
	
	^ classes selectedItem.
]

{ #category : 'accessing' }
RushBasicClassBrowser >> selectedMethod [
	"Answer the first selected <CompiledMethod> in the receiver"

	^ self selectedMethods anyOne
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> selectedMethods [
	"Answer a <Collection> of selected <CompiledMethod>"

	^ instMethods selectedItems

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
		ifTrue: [ self class updateSelectedClass: aClass ].

]

{ #category : 'accessing' }
RushBasicClassBrowser >> system [
	"Another System Command - Calypso bag we need to carry"
	
	^ self class environment
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> updateSelectedClass: aClass [ 

	classes selectItem: aClass.
]

{ #category : 'api - selection' }
RushBasicClassBrowser >> updateSelectedMethod: aCompiledMethod [ 
	"Private - Select the receiver's items referred by aCompiledMethod"
	
	self updateSelectedClass: aCompiledMethod methodClass.
	instMethods selectItem: aCompiledMethod.
	instProtocols items 
		detect: [ : assoc | assoc value = aCompiledMethod protocol ]
		ifFound: [ : assoc | instProtocols selectItem: assoc ]
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
