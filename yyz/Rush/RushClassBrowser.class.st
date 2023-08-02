Class {
	#name : #RushClassBrowser,
	#superclass : #RushBasicClassBrowser,
	#category : #Rush
}

{ #category : #initialization }
RushClassBrowser >> addInstanceMethodsColumnsTo: instMthdsTablePresenter [

	instMthdsTablePresenter
		addColumn: ((SpCheckBoxTableColumn title: '' evaluated: [ : im | self selectedInstMethods includes: im ])
			onActivation: [ : cv | ];
			onDeactivation: [ : cv |  ];
			beNotExpandable;
			width: 20;
			yourself);
		addColumn: ((SpStringTableColumn title: 'Name' evaluated: [ : im | im selector asString ])
			width: 180;
			yourself);
		addColumn: ((SpStringTableColumn title: 'Senders' evaluated: [ : im | self displaySendersIn: im ])
			width: 30;
			beNotExpandable;
			yourself)
]

{ #category : #initialization }
RushClassBrowser >> buildOrganizationProtocols: aClass [

	^ aClass
		  ifNotNil: [
			  aClass protocols
				  collect: [ :each | aClass -> each ]
				  as: OrderedCollection ]
		  ifNil: [ Array empty ]
]

{ #category : #layout }
RushClassBrowser >> classMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Methods' expand: false;
		  add: classMethods;
		  yourself
]

{ #category : #layout }
RushClassBrowser >> classProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Protocols' expand: false;
		  add: classProtocols;
		  yourself
]

{ #category : #layout }
RushClassBrowser >> classVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Variables' expand: false;
		  add: classVariables;
		  yourself
]

{ #category : #'private-class side' }
RushClassBrowser >> connectClassProtocolsPresenter [

	classProtocols
		transmitTo: classMethods
		transform: [ :aPair | 
			aPair
				ifNotNil: [ 
					aPair value methodSelectors
						collect: [ :each | aPair key >> each ]
						as: OrderedCollection ]
				ifNil: [ #(  ) ] ].
			
	classProtocols
		transmitTo: srcCodePresenter
		transform: [ :aPair | aPair ifNotNil: [ aPair key sourceCodeTemplate ] ifNil: [ '' ] ]
]

{ #category : #initialization }
RushClassBrowser >> connectPresenters [

	self connectClassesPresenter.
	self connectInstProtocolsPresenter.
	self connectInstMethodsPresenter.
	self connectClassProtocolsPresenter.
	self connectClassMethodsPresenter.
	self connectReferencesPresenter
]

{ #category : #initialization }
RushClassBrowser >> connectReferencesPresenter [

	references
		transmitTo: referenceMethod
		transform: [ : aMethod |
			aMethod
				ifNotNil: [
					referenceMethod beForMethod: aMethod.
					aMethod sourceCode ]
				ifNil: [ '' ] ]
]

{ #category : #'private-instance side' }
RushClassBrowser >> displaySendersIn: im [

	^ self displaySendersSetting
		ifTrue: [ im senders size asString ]
		ifFalse: [ 'NC' ]
]

{ #category : #accessing }
RushClassBrowser >> displaySendersSetting [

	^ RushSettings computeSenders
]

{ #category : #'private-class side' }
RushClassBrowser >> initializeClassMethodsPresenter [

	classMethods := self newList.
	classMethods
		display: [ :method | method selector ];
		sortingBlock: [ :a :b | a selector  < b selector ]
]

{ #category : #'private-class side' }
RushClassBrowser >> initializeClassProtocolsPresenter [

	classProtocols := self newFilteringList.
	classProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : #'private-class side' }
RushClassBrowser >> initializeClassVariablesPresenter [

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
RushClassBrowser >> initializeReferencesPresenter [

	references := self newFilteringList.
	references listPresenter
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ].
		
	referenceMethod := self newCode.
]

{ #category : #layout }
RushClassBrowser >> instMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight 
				add: 'Instance Methods' expand: false;
				add: sendersCheckPresenter expand: false;
				yourself) expand: false;
		  add: instMethods;
		  yourself
]

{ #category : #layout }
RushClassBrowser >> instProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Protocols' expand: false;
		  add: instProtocols;
		  yourself
]

{ #category : #layout }
RushClassBrowser >> instVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Instance Variables' expand: false;
		  add: instVariables;
		  yourself
]

{ #category : #layout }
RushClassBrowser >> lowerPaneLayout [

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
			add: srcCodePresenter;
			yourself);
		yourself
]

{ #category : #accessing }
RushClassBrowser >> selectedClsVars [

	^ selectedClsVars
		ifNil: [ selectedClsVars := OrderedCollection new ]
]

{ #category : #layout }
RushClassBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self classesLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self classVarsLayout;
				add: self classProtocolsLayout;				
				add: self classMethodsLayout;
				yourself);

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self instProtocolsLayout;
				add: self instVarsLayout;
				yourself);
			add: self instMethodsLayout;
			yourself);
		yourself
]
