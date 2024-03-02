Class {
	#name : 'RushMethodListType',
	#superclass : 'RushListType',
	#category : 'Rush-Lists',
	#package : 'Rush',
	#tag : 'Lists'
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
