require 'spec_helper'
require 'json'
require 'niffler/maven'

#require 'helpers/realweb_helpers'

describe Niffler::Maven do
  #include ResponseHelpers
  
  #before do
  #  ensure_service_running(:fake_service)
  #end
  
  #after do
  #  ensure_all_services_stopped
  #end
  
  describe '#group' do
    context 'with a valid hash' do
      
    end # context
    
    context 'with a valid group name only' do
      before do
        @results = Niffler::Maven.group_query("guice")
        @result = @results.first
      end # before
      
      it 'returns an array of responses' do
        @results.should be_kind_of(Array)
        @results.count.should eq(235)
        @result.should be_kind_of(Niffler::Maven)
      end # it
      
      it 'returns the group name' do
        @result.group.should eq("com.jolira")
      end # it
      
      it 'returns the artifact name' do
        @result.artifact.should eq("guice")
      end # it
      
      it 'returns the latest version' do
        @result.version.should eq("3.0.0")
      end # it
      
      it 'returns the repository' do
        @result.repository.should eq("central")
      end # it
      
      it 'returns the packaging' do
        @result.packaging.should eq("jar")
      end # it
    end # context
    
    context 'with a group AND version' do
      pending "returns correctly when a version is also specified"
    end # context
    
    context 'with a group AND packaging are specified' do
      pending "returns correctly when packaging is also specified"
    end # context
    
    context 'with a group AND classifier are specified' do
      pending "returns correctly when a classifier (i) is also specified"
    end # context
  end # describe
  
  describe '#artifact' do
    context 'with a valid artifact name' do
      pending "returns correctly when an artifact OR group is specified."
    end # context
  end # describe
end # describe Niffler