Class {
	#name : 'BaselineOfRush',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRush',
	#package : 'BaselineOfRush'
}

{ #category : 'baselines' }
BaselineOfRush >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			
			self vmMaker: spec.
			spec 
				package: 'Rush';
				package: 'Rush-Packages'  with: [ spec requires: #(Rush) ];
				package: 'Rush-Slang'     with: [ spec requires: #(Rush) ];
				package: 'Rush-Adaptive'  with: [ spec requires: #(Rush) ];
				package: 'Rush-Druid'     with: [ spec requires: #(Rush VMMaker) ];
				package: 'Rush-Tests'	     with: [ spec requires: #(Rush) ].

			spec 
				group: 'Core' 						with: #('Rush');
				group: 'Slang'                 with: #('Core' 'Rush-Slang');
				group: 'Packages'              with: #('Rush-Packages');
				group: 'Adaptive'              with: #('Rush-Adaptive');
				group: 'Druid'                 with: #('Core' 'Rush-Slang' 'Rush-Druid');
				group: 'Tests' 						with: #('Core' 'Rush-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]

{ #category : 'baselines' }
BaselineOfRush >> vmMaker: spec [

	spec
		baseline: 'VMMaker'
		with: [ spec repository: 'github://pharo-project/pharo-vm:pharo-12/src' ]
]
