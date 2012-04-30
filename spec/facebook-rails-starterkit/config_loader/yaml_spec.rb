require 'spec_helper'

module Rails
	def self.root
		File.join SPEC_DIR, 'fixtures'
	end
end

describe ConfigLoader::Yaml do
	subject { config }
	let(:config) { ConfigLoader::Yaml.new('facebook.yml') }

	its(:file_name) { should == 'facebook.yml' }
	its(:root) 			{ should == 'facebook' }
	its(:ext) 			{ should == 'yml' }

	its(:as_yaml) { should_not be_nil }
	its(:as_hash) { should be_a Hash }

	specify { subject.as_hash.domain == 'www.facebook.com' }

	describe 'no root' do
		subject { config }
		let(:config) { ConfigLoader::Yaml.new('htc.yml') }

		its(:root) 	 { should == nil }
		specify { subject.as_hash.domain == 'www.htc.com' }
	end

	describe 'specific root' do
		subject { config }
		let(:config) { ConfigLoader::Yaml.new('htc.yml', :root) }

		its(:root) 	 { should == 'root' }
		specify { subject.as_hash.domain == 'www.htc.dk' }
	end
end
