Class {
	#name : #RushBrowseCommand,
	#superclass : #StInspectorBrowseSelectedCommand,
	#category : #Rush
}

{ #category : #default }
RushBrowseCommand class >> defaultDescription [

	^ 'Browse with Rush'
]

{ #category : #deafult }
RushBrowseCommand class >> defaultIconName [

	^ #hierarchy
]

{ #category : #default }
RushBrowseCommand class >> defaultName [ 

	^ 'Rush Browse'
]

{ #category : #documentation }
RushBrowseCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : #executing }
RushBrowseCommand >> execute [ 

	self context systemNavigation rushBrowse: self interestingObject
]
