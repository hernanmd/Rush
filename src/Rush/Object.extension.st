Extension { #name : 'Object' }

{ #category : '*Rush' }
Object >> asRushDisplayItem [ 

	^ [ self name ]
	on: MessageNotUnderstood 
	do: [ : ex | self displayString ]
]
