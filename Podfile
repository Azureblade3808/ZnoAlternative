workspace 'ZnoAlternative'

# project 'app'

target 'app' do
	project 'app/app'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSOrientationPatch'
	pod 'ReactiveCocoa'
end

# project 'ui'

target 'ui' do
	project 'ui/ui'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSOrientationPatch'
	pod 'ReactiveCocoa'
	
	target 'ui tests' do
		inherit! :search_paths
		
		pod 'Nimble'
		pod 'Quick'
	end
end

# project 'ui examples'

target 'ui examples' do
	project 'ui examples/ui examples'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSOrientationPatch'
	pod 'ReactiveCocoa'
end
