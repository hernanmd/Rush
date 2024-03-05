"
This is a basic class hierarchy browser (CHB) which tries to stay close to the original CHB from Smalltalk-80.

### Example

```smalltalk
RushBasicAdaptiveBrowser new open.
```
"
Class {
	#name : 'RushBasicAdaptiveBrowser',
	#superclass : 'RushMinimalBrowser',
	#instVars : [
		'addPresenterButton',
		'removePresenterButton',
		'firstListPresenter',
		'accessorMap'
	],
	#category : 'Rush-Adaptive',
	#package : 'Rush-Adaptive'
}

{ #category : 'instance creation' }
RushBasicAdaptiveBrowser class >> open [
	<example>

	self new open
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> addToLayout: headerTitle [

	self nextPresenter
		add: (self newRushList: headerTitle)
		expand: true
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> browserTitle [ 

	^ 'Basic Adaptive Browser'
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> buildOrganizationProtocols: aClass [

	^ aClass
		  ifNotNil: [
			  aClass protocols
				  collect: [ :each | aClass -> each ]
				  as: OrderedCollection ]
		  ifNil: [ Array empty ]
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> compare: a and: b [

	^ (a respondsTo: #name)
		ifTrue: [ a name < b name ]
		ifFalse: [ a displayString < b displayString ]
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> connectPresenters [

	firstListPresenter
		transmitTo: self srcCodePresenter
		transform: [ : anObject | self sourcePresenterFor: anObject ].

	self hasNextPresenter
		ifTrue: [ 
			self halt.
			firstListPresenter 
				transmitTo: self nextPresenter
				transform: [ : aClass | self buildOrganizationProtocols: aClass ]
				postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ] ]
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> dynamicLayout [

	^ self nextPresenter children first.
]

{ #category : 'testing' }
RushBasicAdaptiveBrowser >> hasNextPresenter [

	^ self dynamicLayout children size > 2
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> initialize [

	super initialize.
	self initializeAccessorMap.
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> initializeAccessorMap [

	accessorMap := Dictionary new
		at: 'Methods' put: #methods;
		at: 'Instance Variables' put: #instanceVariables;
		at: 'Class Variables' put: #classVariables;
		at: 'Transformations' put: #transformations;
		at: 'Refactorings' put: #refactorings;
		at: 'All Instances' put: #allInstances;
		at: 'Properties' put: #properties;
		yourself.
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> initializeButtonsPresenter [

	addPresenterButton := self newButton
		icon: (self iconNamed: #smallAdd);
		contextMenu: self newButtonAddMenuPresenter;
		yourself.
		
	removePresenterButton := self newButton
		icon: (self iconNamed: #smallDelete);
		yourself.
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> initializePresenters [

	firstListPresenter := self instantiate: RushListType defaultFirstListType on: self.
	self initializeCodePresenter.
	self initializeButtonsPresenter.
]

{ #category : 'controlling' }
RushBasicAdaptiveBrowser >> itemChangedFor: anObject [

	self lastSelectedPresenter
		transmitTo: self srcCodePresenter
		transform: [ : item | self sourcePresenterFor: item ]

]

{ #category : 'private' }
RushBasicAdaptiveBrowser >> itemFor: aString [ 

	^ firstListPresenter listPresenter selectedItem 
		ifNotNil: [: selectedItem | 
			(selectedItem perform: (accessorMap at: aString))
				ifNil: [ OrderedCollection new ]
				ifNotNil: [ : selectionItems | selectionItems ] ]
		ifNil: [ 	self halt. OrderedCollection new ]

]

{ #category : 'accessing' }
RushBasicAdaptiveBrowser >> lastSelectedPresenter [

	^ (self presenters select: [ : p | p isKindOf: SpListPresenter ]) last.

]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> layoutChildren [

	^ self layout children
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> lowerPaneLayout [

	^ SpBoxLayout newLeftToRight
		add: srcCodePresenter;
		yourself
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForAllInstances [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'All Instances';
				icon: (self iconNamed: #smallOpen);
				shortcut: $a meta;
				action: [ self addToLayout: 'All Instances' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForClassVariables [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Class Variables';
				icon: (self iconNamed: #smallOpen);
				shortcut: $o meta;
				action: [ self addToLayout: 'Class Variables' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForInstanceVariables [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Instance Variables';
				icon: (self iconNamed: #smallOpen);
				shortcut: $o meta;
				action: [ self addToLayout: 'Instance Variables' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForMethods [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Methods';
				icon: (self iconNamed: #smallOpen);
				shortcut: $o meta;
				action: [ self addToLayout: 'Methods' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForProperties [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Properties';
				icon: (self iconNamed: #refresh);
				shortcut: $p meta;
				action: [ self addToLayout: 'Properties' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForRefactorings [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Refactorings';
				icon: (self iconNamed: #refresh);
				shortcut: $o meta;
				action: [ self addToLayout: 'Refactorings' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemForTransformations [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ [ : item |
			item
				name: 'Transformations';
				icon: (self iconNamed: #refresh);
				shortcut: $o meta;
				action: [ self addToLayout: 'Transformations' ] ]
]

{ #category : 'menu building' }
RushBasicAdaptiveBrowser >> menuItemsForSelectedExpansion [
	"Answer a <Collection> of menu items <BlockClosure>"
	
	^ { 
		self menuItemForMethods .
		self menuItemForInstanceVariables .
		self menuItemForClassVariables .
		self menuItemForProperties .
		self menuItemForAllInstances .
		self menuItemForTransformations .
		self menuItemForRefactorings }
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> newButtonAddMenuPresenter [

	| newMenu |
	
	newMenu := self newMenu.
	self menuItemsForSelectedExpansion do: [ : itemBlock |
		newMenu addItem: itemBlock ].
	^ newMenu
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> newRushList: headerString [

	| newList |
	
	newList := (self instantiate: RushListType) listPresenter
		headerTitle: headerString;
		items: (self itemFor: headerString);
		display: [ : item | item asRushDisplayItem ];
		sortingBlock: [ :a :b | self compare: a and: b ];
		whenSelectionChangedDo: [ :selection | self itemChangedFor: selection  ];
		yourself.

	firstListPresenter 
		transmitTo: newList
		transform: [ : anObject | 
			anObject 
				ifNotNil: [ : object | object perform: (accessorMap at: headerString) ]
				ifNil: [ OrderedCollection new ] ].
	
	^ newList
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> nextPresenter [

	^ self layoutChildren first
]

{ #category : 'initialization' }
RushBasicAdaptiveBrowser >> selectClass: anObject [

	anObject asRushSelectionIn: self

]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> sourcePresenterFor: anObject [ 

	^ anObject
		ifNotNil: [
			anObject isClass
				ifTrue: [ anObject definitionString ]
				ifFalse: [ 
					self srcCodePresenter beForMethod: anObject.
					anObject sourceCode ] ]
		ifNil: [ '' ]
]

{ #category : 'layout' }
RushBasicAdaptiveBrowser >> upperPaneLayout [

	^ SpBoxLayout newLeftToRight
		spacing: self spacingBetweenPanes;
		add: (SpBoxLayout newTopToBottom
			add: (SpBoxLayout newLeftToRight 
				add: addPresenterButton expand: false;
				add: removePresenterButton expand: false;
				yourself) expand: false;
			add: firstListPresenter;
			yourself);
		yourself
]
