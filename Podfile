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

# project 'data'

target 'data' do
	project 'data/data'
	
	platform :ios, '9.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	target 'data tests' do
		inherit! :complete
		
		pod 'Nimble'
		pod 'Quick'
	end
end

# project 'product spec'

target 'product spec' do
	project 'product spec/product spec'
	
	platform :ios, '9.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSXmlProcessor'
	
	target 'product spec tests' do
		inherit! :complete
		
		pod 'Nimble'
		pod 'Quick'
	end
end

# project 'ui'

target 'ui' do
	project 'ui/ui'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSOrientationPatch'
	
	target 'ui tests' do
		inherit! :complete
		
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
