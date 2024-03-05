Class {
	#name : 'RushBrowseCommand',
	#superclass : 'StInspectorBrowseSelectedCommand',
	#category : 'Rush-Commands',
	#package : 'Rush',
	#tag : 'Commands'
}

{ #category : 'default' }
RushBrowseCommand class >> defaultDescription [

	^ 'Browse with Rush'
]

{ #category : 'deafult' }
RushBrowseCommand class >> defaultIconName [

	^ #hierarchy
]

{ #category : 'default' }
RushBrowseCommand class >> defaultName [ 

	^ 'Rush Browse'
]

{ #category : 'documentation' }
RushBrowseCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : 'execution' }
RushBrowseCommand >> execute [ 

	self context systemNavigation rushBrowse: self interestingObject
]
