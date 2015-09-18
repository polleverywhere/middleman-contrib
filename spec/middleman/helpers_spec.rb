require 'spec_helper'

describe Middleman::Contrib::Helpers do
  let :app do
    Middleman::Application.server.inst { activate :contrib }
  end
  
  describe 'sub_pages' do
    it 'returns an array of pages in the specified folder, recursively digging through sub-folders' do
      paths = app.sub_pages('topic').map(&:path)
      
      expect(paths).to eq ['topic/sub_a/sub_sub_a.html', 'topic/sub_a/sub_sub_b.html', 'topic/sub_a.html', 'topic/sub_b.html']
    end

    it 'returns an array of pages that match the specified regular expression' do
      paths = app.sub_pages(/\Atopic\/.*a.html.*\z/).map(&:path)

      expect(paths).to eq ['topic/sub_a/sub_sub_a.html', 'topic/sub_a.html']
    end

    it 'returns an array of pages in a folder in the order specified by the block' do
      paths = app.sub_pages('topic') { |page| [page.path.count('/'), page.path] }.map(&:path)

      expect(paths).to eq ['topic/sub_a.html', 'topic/sub_b.html', 'topic/sub_a/sub_sub_a.html', 'topic/sub_a/sub_sub_b.html']
    end
  end
end
