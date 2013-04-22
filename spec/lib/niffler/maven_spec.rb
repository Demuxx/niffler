require 'spec_helper'
require 'json'
require 'niffler/maven'

describe Niffler::Maven do
  describe '#group_query' do 
    before do
      @result = Niffler::Maven.group_query("guice")
    end # before
    
    it 'returns a Niffler::Maven object' do
      @result.should be_kind_of(Niffler::Maven)
    end # it
    
    it 'returns the group name' do
      @result.group.should eq("org.apache.servicemix.bundles")
    end # it
    
    it 'returns the artifact name' do
      @result.artifact.should eq("org.apache.servicemix.bundles.guice")
    end # it
    
    it 'returns the latest version' do
      @result.version.should eq("3.0_1")
    end # it
    
    it 'returns the repository' do
      @result.repository.should eq("central")
    end # it
    
    it 'returns the packaging' do
      @result.packaging.should eq("bundle")
    end # it
  end # describe 
  
  describe '#groups_query' do
    context 'with a valid group name only' do
      before do
        @results = Niffler::Maven.groups_query("guice")
      end # before
      
      it 'returns an array of Mavens' do
        @results.should be_kind_of(Array)
        @results.count.should eq(235)
        @results.last.should be_kind_of(Niffler::Maven)
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
  
  describe '#artifacts_query' do
    context 'with a valid artifact name' do
      before do
        @results = Niffler::Maven.artifacts_query("guice")
      end # before
      
      it 'returns an array of responses' do
        @results.should be_kind_of(Array)
        @results.last.should be_kind_of(Niffler::Maven)
      end # it
    end # context
  end # describe

  describe '#artifact_query' do
    context 'with a valid artifact name' do
      before do
        @result = Niffler::Maven.artifact_query("guice-maven-plugin")
      end # before
      
      it 'returns the group name' do
        @result.group.should eq("org.apache.camel")
      end # it

      it 'returns the artifact name' do
        @result.artifact.should eq("guice-maven-plugin")
      end # it

      it 'returns the latest version' do
        @result.version.should eq("2.11.0")
      end # it

      it 'returns the repository' do
        @result.repository.should eq("central")
      end # it

      it 'returns the packaging' do
        @result.packaging.should eq("maven-plugin")
      end # it
    end # context
  end # describe
  
  describe '#hash_query' do
    context 'with a valid hash' do
      before do
        @result = Niffler::Maven.hash_query("35379fb6526fd019f331542b4e9ae2e566c57933")
      end # before
      
      it 'returns the group name' do
        @result.group.should eq("org.eclipse.jetty")
      end # it

      it 'returns the artifact name' do
        @result.artifact.should eq("jetty-webapp")
      end # it

      it 'returns the latest version' do
        @result.version.should eq("7.3.0.v20110203")
      end # it

      it 'returns the packaging' do
        @result.packaging.should eq("jar")
      end # it
    end # context
  end # describe hash
end # describe Niffler