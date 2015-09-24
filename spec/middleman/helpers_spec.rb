require 'spec_helper'

describe Middleman::Contrib::Helpers do
  let :app do
    Middleman::Application.server.inst { activate :contrib }
  end
  
  describe 'sub_pages' do
    it 'returns an array of pages in the specified folder and any subfolders, sorted shallowist pages first and then alphabetically' do
      paths = app.sub_pages('topic').map(&:path)

      expect(paths).to eq ['topic/sub_a.html', 'topic/sub_b.html', 'topic/sub_a/sub_sub_a.html', 'topic/sub_a/sub_sub_b.html']
    end

    it 'returns only the sub pages that match the specified regular expression' do
      paths = app.sub_pages('topic', filter: /\A.*a.html.*\z/).map(&:path)

      expect(paths).to eq ['topic/sub_a.html', 'topic/sub_a/sub_sub_a.html']
    end

    it 'takes in a relative path from source and returns an array of pages found below it' do
      paths = app.sub_pages('topic/sub_a').map(&:path)

      expect(paths).to eq ['topic/sub_a/sub_sub_a.html', 'topic/sub_a/sub_sub_b.html']
    end

    
    context 'passing an empty string for the directory path' do
      it 'returns a full listing of all the files' do
        # Just testing that it returns more than 0 items
        expect(app.sub_pages('').size).to be > 0
      end

      it 'filters results by matching the specified regular expression' do
        paths = app.sub_pages('', filter: /\Atopic\/.*a.html.*\z/).map(&:path)

        expect(paths).to eq ['topic/sub_a.html', 'topic/sub_a/sub_sub_a.html']
      end
    end


    context 'passing "/" for the directory path' do
      it 'returns a full listing of all the files' do
        # Just testing that it returns more than 0 items
        expect(app.sub_pages('/').size).to be > 0
      end

      it 'filters results by matching the specified regular expression' do
        paths = app.sub_pages('/', filter: /\Atopic\/.*a.html.*\z/).map(&:path)

        expect(paths).to eq ['topic/sub_a.html', 'topic/sub_a/sub_sub_a.html']
      end
    end


    context 'passed the "max_depth" option' do
      it 'limits the results to those items no deeper than the specified value' do
        paths = app.sub_pages('topic', max_depth: 1).map(&:path)

        expect(paths).to eq ['topic/sub_a.html', 'topic/sub_b.html']
      end

      it 'calculates the maximum depth relative to the directory path passed' do
        paths = app.sub_pages('topic/sub_a', max_depth: 1).map(&:path)

        expect(paths).to eq ['topic/sub_a/sub_sub_a.html', 'topic/sub_a/sub_sub_b.html']
      end
    end
  end


  describe 'ancestors' do
    context 'site root has an index.html page' do
      it 'returns an empty array for index.html' do
        app.current_path = '/index.html'
        expect(app.ancestors.map(&:path)).to eq []
      end

      it 'returns an array with just index.html in it for a top-level page' do
        app.current_path = '/topic.html'
        expect(app.ancestors.map(&:path)).to eq ['index.html']
      end

      it 'returns an array of all the ancestral pages from parent to eldest ancestor' do
        app.current_path = '/topic/sub_a/sub_sub_b.html'
        expect(app.ancestors.map(&:path)).to eq ['topic/sub_a.html', 'topic.html', 'index.html']
      end

      it 'skips any pages in the middle that don\'t exist including index.html since no top-level ancestor' do
        app.current_path = '/deep/sub_c/sub_sub_a.html'
        expect(app.ancestors.map(&:path)).to eq []
      end
    end
  end
end
