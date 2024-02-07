Class {
	#name : 'RushClassBrowser',
	#superclass : 'RushBasicClassBrowser',
	#instVars : [
		'classProtocols',
		'classMethods',
		'classVariables',
		'selectedClsVars',
		'classComment'
	],
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'initialization' }
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
			yourself)
]

{ #category : 'layout' }
RushClassBrowser >> classMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Methods' expand: false;
		  add: classMethods;
		  yourself
]

{ #category : 'layout' }
RushClassBrowser >> classProtocolsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Protocols' expand: false;
		  add: classProtocols;
		  yourself
]

{ #category : 'layout' }
RushClassBrowser >> classVarsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Class Variables' expand: false;
		  add: classVariables;
		  yourself
]

{ #category : 'private-class side' }
RushClassBrowser >> connectClassMethodsPresenter [

	classMethods
		transmitTo: srcCodePresenter
		transform: [ :aMethod | aMethod ifNotNil: [ aMethod sourceCode ] ifNil: [ '' ] ]
]

{ #category : 'private-class side' }
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

{ #category : 'initialization' }
RushClassBrowser >> connectClassesPresenter [ 

	super connectClassesPresenter.
	classes
		transmitTo: classProtocols
		transform: [ :aClass | self buildOrganizationProtocols: aClass class ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	classes transmitTo: classVariables transform: [ :aClass |
		aClass ifNotNil: [ aClass classVariables ] ifNil: [ Array empty ] ].
	
	classes transmitTo: classComment transform: [ :aClass |
		aClass ifNotNil: [ aClass comment ] ifNil: [ String empty ] ].

]

{ #category : 'initialization' }
RushClassBrowser >> connectPresenters [

	super connectPresenters.

	self connectClassMethodsPresenter.
	self connectClassProtocolsPresenter.

]

{ #category : 'private-class side' }
RushClassBrowser >> initializeClassMethodsPresenter [

	classMethods := self newList.
	classMethods
		display: [ :method | method selector ];
		sortingBlock: [ :a :b | a selector  < b selector ]
]

{ #category : 'private-class side' }
RushClassBrowser >> initializeClassProtocolsPresenter [

	classProtocols := self newFilteringList.
	classProtocols listPresenter
		display: [ :aPair | aPair value name ];
		sortingBlock: [ :a :b | a value name < b value name ]
]

{ #category : 'private-class side' }
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

{ #category : 'initialization' }
RushClassBrowser >> initializeCommentPresenter [

	classComment := self newText.
	classComment 
		placeholder: 'Class comment';
		text: '';
		beNotEditable;
		addStyle: 'iceTipReadonly';
		addStyle: 'iceTipText4Lines';
		beWrapWord
]

{ #category : 'initialization' }
RushClassBrowser >> initializePresenters [ 

	super initializePresenters.
	self initializeClassProtocolsPresenter.
	self initializeClassVariablesPresenter.
	self initializeClassMethodsPresenter.
	self initializeCommentPresenter.
]

{ #category : 'layout' }
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
			add: srcCodePresenter;
			yourself);
		yourself
]

{ #category : 'accessing' }
RushClassBrowser >> selectedClsVars [

	^ selectedClsVars
		ifNil: [ selectedClsVars := OrderedCollection new ]
]

{ #category : 'layout' }
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
