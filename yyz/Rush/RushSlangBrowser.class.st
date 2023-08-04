Class {
	#name : #RushSlangBrowser,
	#superclass : #RushBasicClassBrowser,
	#instVars : [
		'translatedSourcePresenter',
		'inlineCheckPresenter'
	],
	#category : #Rush
}

{ #category : #initialization }
RushSlangBrowser >> browserTitle [ 

	^ 'Slang Browser'
]

{ #category : #private }
RushSlangBrowser >> configureCodeGeneratorFor: aMethod [ 

	| mClass mClassGenerator cg |
	
	mClass := aMethod methodClass. "#SmartSyntaxInterpreterPlugin"
	mClassGenerator := mClass codeGeneratorClass. "SmartSyntaxPluginCodeGenerator"
	cg := mClassGenerator new.

	cg isInterpreterPlugin
		ifFalse: [ 
			cg vmMaker: VMMaker new.
			cg vmMaker vmmakerConfiguration: VMMakerConfiguration ].
	
	cg pluginClass: mClass.
	cg vmClass: mClass.
	cg addClass: mClass.		
	cg doInlining: RushSettings inlineMethods.	
	^ cg
]

{ #category : #'private-instance side' }
RushSlangBrowser >> connectInstMethodsPresenter [

	super connectInstMethodsPresenter.
	instMethods
		transmitTo: translatedSourcePresenter 
		transform: [ :aMethod |
			aMethod
				ifNotNil: [ self translateSourceCode: aMethod ]
				ifNil: [ '' ] ]
]

{ #category : #initialization }
RushSlangBrowser >> initializeInstMethodsPresenter [

	super initializeInstMethodsPresenter.
	inlineCheckPresenter := self newCheckBox
		label: 'Inline';
		state: RushSettings inlineMethods;
		whenChangedDo: [ : c | RushSettings inlineMethods: c ].
]

{ #category : #initialization }
RushSlangBrowser >> initializePresenters [

	super initializePresenters.
	translatedSourcePresenter := self newCode.
	classes items: self slangClasses
]

{ #category : #layout }
RushSlangBrowser >> instMethodsLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight 
				add: 'Instance Methods' expand: false;
				add: inlineCheckPresenter expand: false;
				yourself) expand: false;
		  add: instMethods;
		  yourself
]

{ #category : #layout }
RushSlangBrowser >> lowerPaneLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: 0.3;
		add: (	SpBoxLayout newTopToBottom
			spacing: self spacingBetweenPanes;
			add: classDefinition;
			yourself);
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: srcCodePresenter;
			add: translatedSourcePresenter;
			yourself);
		yourself
]

{ #category : #initialization }
RushSlangBrowser >> slangClasses [
	" Answer a <Collection> of <Class>"
	
	^ (SortedCollection 
		sortUsing: [ : c1 : c2 | c1 name < c2 name ])
			addAll: SlangClass withAllSubclasses;
			yourself

]

{ #category : #'private-instance side' }
RushSlangBrowser >> translateSourceCode: aMethod [

	^ String streamContents: [ : stream | 
		self translateSourceCodeFromMethod: aMethod in: stream ].
]

{ #category : #private }
RushSlangBrowser >> translateSourceCodeFromMethod: aMethod in: aWriteStream [ 

	| cg |

	cg := self configureCodeGeneratorFor: aMethod.
	cg methods 
		at: aMethod selector
		ifPresent: [ : tm | (tm asCASTIn: cg) prettyPrintOn: aWriteStream ]
		ifAbsent: [ aWriteStream << 'Translation not found for the selected method' ]
]

{ #category : #accessing }
RushSlangBrowser >> translatedSourcePresenter [

	^ translatedSourcePresenter
]

{ #category : #accessing }
RushSlangBrowser >> translatedSourcePresenter: anObject [

	translatedSourcePresenter := anObject
]
