Class {
	#name : 'RushClassListType',
	#superclass : 'RushListType',
	#category : 'Rush-UI',
	#package : 'Rush',
	#tag : 'UI'
}

{ #category : 'initialization' }
RushClassListType >> connectToSourcePresenter [

	self listPresenter
		transmitTo: self srcCodePresenter
		transform: [ :aMethod |
			aMethod
				ifNotNil: [
					self srcCodePresenter beForMethod: aMethod.
					aMethod sourceCode ]
				ifNil: [ '' ] ]
]

{ #category : 'as yet unclassified' }
RushClassListType >> defaultClasses [

	^ Smalltalk image allClasses asSortedCollection: [ : a : b | a name < b name ]
]

{ #category : 'initialization' }
RushClassListType >> initializePresenters [

	super initializePresenters.
	list := self instantiate: SpFilteringListPresenter.
	list
		items: self defaultClasses;
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		sortingBlock: [ :a :b | a name < b name ];
		itemFilter: [ :item :string | item asString asLowercase beginsWith: string asLowercase ].
]
