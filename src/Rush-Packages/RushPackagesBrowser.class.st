Class {
	#name : 'RushPackagesBrowser',
	#superclass : 'RushBasicClassBrowser',
	#instVars : [
		'packages',
		'packagesPresenter',
		'allClasses',
		'extendedClassesPresenter',
		'traitsPresenter',
		'unsentsPresenter'
	],
	#category : 'Rush-Packages',
	#package : 'Rush-Packages'
}

{ #category : 'initialization' }
RushPackagesBrowser >> browserTitle [ 

	^ 'Packages Browser'
]

{ #category : 'layout' }
RushPackagesBrowser >> classTemplateFor: aPackage [

	aPackage ifNil: [ ^ '' ].

	^ 'Object subclass: #NameOfSubclass
	slots: {}
	classVariables: {}
	package: ''' , aPackage name , ''' '
]

{ #category : 'initialization' }
RushPackagesBrowser >> connectPackagesPresenter [

	packagesPresenter
		transmitTo: classes
		transform: [ :aPackage |
			aPackage
				ifNotNil: [ aPackage definedClasses asArray ]
				ifNil: [ #(  ) ] ].

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

	classes
		transmitTo: unsentsPresenter
		transform: [ : aClass |
			aClass
				ifNotNil: [ aClass allUnsentMessages asArray ]
				ifNil: [ #(  ) ] ].

	packagesPresenter
		transmitTo: classDefinition
		transform: [ :aPackage | self classTemplateFor: aPackage ]
]

{ #category : 'initialization' }
RushPackagesBrowser >> connectPresenters [

	self connectPackagesPresenter.
	super connectPresenters.
]

{ #category : 'initialization' }
RushPackagesBrowser >> defaultClasses [

	^ Array empty
]

{ #category : 'initialization' }
RushPackagesBrowser >> defaultPackages [

	^ RPackageOrganizer default packages reject: #isTestPackage
]

{ #category : 'initialization' }
RushPackagesBrowser >> initializePackagesPresenter [

	packagesPresenter := self newFilteringList.
	packagesPresenter listPresenter
		display: [ :package | package name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: self packages.
		
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

{ #category : 'initialization' }
RushPackagesBrowser >> initializePresenters [ 

	super initializePresenters.
	self initializePackagesPresenter.
]

{ #category : 'opening' }
RushPackagesBrowser >> openOnClass: aClass [

	packagesPresenter items: self defaultPackages.
	packagesPresenter selectItem: (RPackageOrganizer default packageOf: aClass).
	super openOnClass: aClass
]

{ #category : 'opening' }
RushPackagesBrowser >> openOnMethod: aMethod [ 

	packagesPresenter selectItem: (RPackageOrganizer default packageOf: aMethod methodClass) packageName.
	super openOnMethod: aMethod.
]

{ #category : 'layout' }
RushPackagesBrowser >> packageAllClassesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'All Classes' expand: false;
		  add: classes;
		  yourself
]

{ #category : 'layout' }
RushPackagesBrowser >> packageExtendedClassesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Extended Classes' expand: false;
		  add: extendedClassesPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesBrowser >> packageTraitsLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Traits' expand: false;
		  add: traitsPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesBrowser >> packageUnsentLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Unsents' expand: false;
		  add: unsentsPresenter;
		  yourself
]

{ #category : 'initialization' }
RushPackagesBrowser >> packages [

	^ packages
		ifNil: [ packages := self defaultPackages ]
]

{ #category : 'layout' }
RushPackagesBrowser >> packagesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Packages' expand: false;
		  add: packagesPresenter;
		  yourself
]

{ #category : 'layout' }
RushPackagesBrowser >> upperPaneLayout [

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
