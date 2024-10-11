Extension { #name : 'CompiledCode' }

{ #category : '*Rush' }
CompiledCode >> asRushSelectionIn: aRushBrowser [

	aRushBrowser updateSelectedMethod: self
]
