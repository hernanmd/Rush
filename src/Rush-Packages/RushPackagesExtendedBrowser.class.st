Class {
	#name : 'RushPackagesExtendedBrowser',
	#superclass : 'RushPackagesBrowser',
	#instVars : [
		'extendedClassesPresenter',
		'traitsPresenter',
		'unsentsPresenter'
	],
	#category : 'Rush-Packages',
	#package : 'Rush-Packages'
}

{ #category : 'initialization' }
RushPackagesExtendedBrowser >> connectPackagesPresenter [

	super connectPackagesPresenter.
	packagesPresenter
		transmitTo: extendedClassesPresenter
		transform: [ :aPackage |
			aPackage
				ifNotNil: [ aPackage extendedClasses asArray ]
				ifNil: [ #(  ) ] ].

	packagesPresenter
		transmitTo: traitsPresenter
		transform: [ :aPackage |
			aPackage
				ifNotNil: [ aPackage asRingDefinition traits asArray ]
				ifNil: [ #(  ) ] ].

	classes transmitTo: unsentsPresenter transform: [ :aClass |
		aClass
			ifNotNil: [ aClass allUnsentMessages asArray ]
			ifNil: [ #(  ) ] ]
]

{ #category : 'initialization' }
RushPackagesExtendedBrowser >> initializePresenters [

	super initializePresenters.
	extendedClassesPresenter := self newFilteringList.
	extendedClassesPresenter listPresenter
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #class ];
		sortingBlock: [ :a :b | a name < b name ].

	traitsPresenter := self newFilteringList.
	traitsPresenter listPresenter
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #trait ];
		sortingBlock: [ :a :b | a name < b name ].
		
	unsentsPresenter := self newFilteringList.
	unsentsPresenter listPresenter
		sortingBlock: [ :a :b | a < b ].
]

{ #category : 'layout' }
RushPackagesExtendedBrowser >> packageAllClassesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'All Classes' expand: false;
		  add: classes;
		  yourself
]

{ #category : 'layout' }
RushPackagesExtendedBrowser >> packageExtendedClassesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Extended Classes' expand: false;
		  add: extendedClassesPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesExtendedBrowser >> packageTraitsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Traits' expand: false;
		  add: traitsPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesExtendedBrowser >> packageUnsentLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Unsents' expand: false;
		  add: unsentsPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesExtendedBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self packagesLayout;
			add: self packageAllClassesLayout;
			add: self packageExtendedClassesLayout;
			add: self packageTraitsLayout;
			add: self packageUnsentLayout;
			yourself);
		yourself
]
