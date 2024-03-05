Class {
	#name : 'RushMethodListType',
	#superclass : 'RushListType',
	#category : 'Rush-UI',
	#package : 'Rush',
	#tag : 'UI'
}

{ #category : 'accessing' }
RushMethodListType >> defaultMethods [

	^ Smalltalk image allClasses asSortedCollection: [ : a : b | a name < b name ]
]

{ #category : 'accessing' }
RushMethodListType >> listPresenter [

	^ self list listPresenter
		items: self defaultMethods;
		display: [ :class | class name];
		displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		sortingBlock: [ :a :b | a name < b name ]
]
