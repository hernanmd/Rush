Class {
	#name : #RushRefsClassBrowser,
	#superclass : #RushClassBrowser,
	#instVars : [
		'references',
		'referenceMethod'
	],
	#category : #Rush
}

{ #category : #'private-instance side' }
RushRefsClassBrowser >> addInstanceMethodsColumnsTo: instMthdsTablePresenter [

	(super addInstanceMethodsColumnsTo: instMthdsTablePresenter)
		addColumn: ((SpStringTableColumn title: 'Senders' evaluated: [ : im | self displaySendersIn: im ])
			width: 30;
			beNotExpandable;
			yourself)
]

{ #category : #initialization }
RushRefsClassBrowser >> connectClassesPresenter [ 

	super connectClassesPresenter.
	classes
		transmitTo: references
		transform: [ :aClass |
			aClass
				ifNotNil: [ self systemNavigation allReferencesTo: aClass binding ]
				ifNil: [ Array empty ] ]
		postTransmission: [ :list | references items: list items ]
]

{ #category : #initialization }
RushRefsClassBrowser >> connectPresenters [ 

	super connectPresenters.
	self connectReferencesPresenter
]

{ #category : #initialization }
RushRefsClassBrowser >> connectReferencesPresenter [

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
RushRefsClassBrowser >> displaySendersIn: im [

	^ self displaySendersSetting
		ifTrue: [ im senders size asString ]
		ifFalse: [ 'NC' ]
]

{ #category : #accessing }
RushRefsClassBrowser >> displaySendersSetting [

	^ RushSettings computeSenders
]

{ #category : #initialization }
RushRefsClassBrowser >> initializePresenters [ 

	super initializePresenters.
	self initializeReferencesPresenter.
]

{ #category : #initialization }
RushRefsClassBrowser >> initializeReferencesPresenter [

	references := self newFilteringList.
	references listPresenter
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ].
		
	referenceMethod := self newCode.
]

{ #category : #layout }
RushRefsClassBrowser >> lowerPaneLayout [

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
